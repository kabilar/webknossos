package models.dataset

import com.scalableminds.util.cache.AlfuCache
import com.scalableminds.util.geometry.{BoundingBox, Vec3Int}
import com.scalableminds.util.tools.Fox
import com.scalableminds.webknossos.datastore.explore.{
  ExploreRemoteDatasetRequest,
  ExploreRemoteDatasetResponse,
  ExploreRemoteLayerParameters
}
import com.scalableminds.webknossos.datastore.models.{AdditionalCoordinate, RawCuboidRequest}
import com.scalableminds.webknossos.datastore.models.datasource.{DataLayer, GenericDataSource}
import com.scalableminds.webknossos.datastore.rpc.RPC
import com.scalableminds.webknossos.datastore.services.DirectoryStorageReport
import com.typesafe.scalalogging.LazyLogging
import controllers.RpcTokenHolder
import play.api.libs.json.JsObject
import play.utils.UriEncoding
import utils.ObjectId

import scala.concurrent.ExecutionContext
import scala.concurrent.duration.DurationInt

class WKRemoteDataStoreClient(dataStore: DataStore, rpc: RPC) extends LazyLogging {

  private lazy val hasSegmentIndexFileCache: AlfuCache[(String, String, String), Boolean] =
    AlfuCache(timeToLive = 1 minute)

  def getDataLayerThumbnail(organizationName: String,
                            dataset: Dataset,
                            dataLayerName: String,
                            mag1BoundingBox: BoundingBox,
                            mag: Vec3Int,
                            mappingName: Option[String],
                            intensityRangeOpt: Option[(Double, Double)],
                            colorSettingsOpt: Option[ThumbnailColorSettings]): Fox[Array[Byte]] = {
    val targetMagBoundingBox = mag1BoundingBox / mag
    logger.debug(s"Thumbnail called for: $organizationName/${dataset.name}, Layer: $dataLayerName")
    rpc(s"${dataStore.url}/data/datasets/${urlEncode(organizationName)}/${dataset.urlEncodedName}/layers/$dataLayerName/thumbnail.jpg")
      .addQueryString("token" -> RpcTokenHolder.webknossosToken)
      .addQueryString("mag" -> mag.toMagLiteral())
      .addQueryString("x" -> mag1BoundingBox.topLeft.x.toString)
      .addQueryString("y" -> mag1BoundingBox.topLeft.y.toString)
      .addQueryString("z" -> mag1BoundingBox.topLeft.z.toString)
      .addQueryString("width" -> targetMagBoundingBox.width.toString)
      .addQueryString("height" -> targetMagBoundingBox.height.toString)
      .addQueryStringOptional("mappingName", mappingName)
      .addQueryStringOptional("intensityMin", intensityRangeOpt.map(_._1.toString))
      .addQueryStringOptional("intensityMax", intensityRangeOpt.map(_._2.toString))
      .addQueryStringOptional("color", colorSettingsOpt.map(_.color.toHtml))
      .addQueryStringOptional("invertColor", colorSettingsOpt.map(_.isInverted.toString))
      .getWithBytesResponse
  }

  def getLayerData(organizationName: String,
                   dataset: Dataset,
                   layerName: String,
                   mag1BoundingBox: BoundingBox,
                   mag: Vec3Int,
                   additionalCoordinates: Option[Seq[AdditionalCoordinate]]): Fox[Array[Byte]] = {
    val targetMagBoundingBox = mag1BoundingBox / mag
    logger.debug(s"Fetching raw data. Mag $mag, mag1 bbox: $mag1BoundingBox, target-mag bbox: $targetMagBoundingBox")
    rpc(
      s"${dataStore.url}/data/datasets/${urlEncode(organizationName)}/${dataset.urlEncodedName}/layers/$layerName/readData")
      .addQueryString("token" -> RpcTokenHolder.webknossosToken)
      .postJsonWithBytesResponse(
        RawCuboidRequest(mag1BoundingBox.topLeft, targetMagBoundingBox.size, mag, additionalCoordinates))
  }

  def findPositionWithData(organizationName: String, dataset: Dataset, dataLayerName: String): Fox[JsObject] =
    rpc(
      s"${dataStore.url}/data/datasets/${urlEncode(organizationName)}/${dataset.urlEncodedName}/layers/$dataLayerName/findData")
      .addQueryString("token" -> RpcTokenHolder.webknossosToken)
      .getWithJsonResponse[JsObject]

  private def urlEncode(text: String) = UriEncoding.encodePathSegment(text, "UTF-8")

  def fetchStorageReport(organizationName: String, datasetName: Option[String]): Fox[List[DirectoryStorageReport]] =
    rpc(s"${dataStore.url}/data/datasets/measureUsedStorage/${urlEncode(organizationName)}")
      .addQueryString("token" -> RpcTokenHolder.webknossosToken)
      .addQueryStringOptional("datasetName", datasetName)
      .silent
      .getWithJsonResponse[List[DirectoryStorageReport]]

  def addDataSource(organizationName: String,
                    datasetName: String,
                    dataSource: GenericDataSource[DataLayer],
                    folderId: Option[ObjectId],
                    userToken: String): Fox[Unit] =
    for {
      _ <- rpc(s"${dataStore.url}/data/datasets/$organizationName/$datasetName")
        .addQueryString("token" -> userToken)
        .addQueryStringOptional("folderId", folderId.map(_.toString))
        .put(dataSource)
    } yield ()

  def hasSegmentIndexFile(organizationName: String, datasetName: String, layerName: String)(
      implicit ec: ExecutionContext): Fox[Boolean] = {
    val cacheKey = (organizationName, datasetName, layerName)
    hasSegmentIndexFileCache.getOrLoad(
      cacheKey,
      k =>
        rpc(s"${dataStore.url}/data/datasets/${k._1}/${k._2}/layers/${k._3}/hasSegmentIndex")
          .addQueryString("token" -> RpcTokenHolder.webknossosToken)
          .silent
          .getWithJsonResponse[Boolean]
    )
  }

  def exploreRemoteDataset(layerParameters: List[ExploreRemoteLayerParameters],
                           organizationName: String,
                           userToken: String): Fox[ExploreRemoteDatasetResponse] =
    rpc(s"${dataStore.url}/data/datasets/exploreRemote")
      .addQueryString("token" -> userToken)
      .postJsonWithJsonResponse[ExploreRemoteDatasetRequest, ExploreRemoteDatasetResponse](
        ExploreRemoteDatasetRequest(layerParameters, organizationName))

}
