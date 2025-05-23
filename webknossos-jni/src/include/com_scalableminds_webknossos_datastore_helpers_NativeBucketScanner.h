/* DO NOT EDIT THIS FILE - it is machine generated */
#include <jni.h>
/* Header for class com_scalableminds_webknossos_datastore_helpers_NativeBucketScanner */

#ifndef _Included_com_scalableminds_webknossos_datastore_helpers_NativeBucketScanner
#define _Included_com_scalableminds_webknossos_datastore_helpers_NativeBucketScanner
#ifdef __cplusplus
extern "C" {
#endif
/*
 * Class:      com_scalableminds_webknossos_datastore_helpers_NativeBucketScanner
 * Method:     collectSegmentIds
 * Signature:  ([BIZZ)[J
 */
JNIEXPORT jlongArray JNICALL Java_com_scalableminds_webknossos_datastore_helpers_NativeBucketScanner_collectSegmentIds
  (JNIEnv *, jobject, jbyteArray, jint, jboolean, jboolean);

/*
 * Class:      com_scalableminds_webknossos_datastore_helpers_NativeBucketScanner
 * Method:     countSegmentVoxels
 * Signature:  ([BIZJ)J
 */
JNIEXPORT jlong JNICALL Java_com_scalableminds_webknossos_datastore_helpers_NativeBucketScanner_countSegmentVoxels
  (JNIEnv *, jobject, jbyteArray, jint, jboolean, jlong);

/*
 * Class:      com_scalableminds_webknossos_datastore_helpers_NativeBucketScanner
 * Method:     extendSegmentBoundingBox
 * Signature:  ([BIZIJIIIIIIIII)[I
 */
JNIEXPORT jintArray JNICALL Java_com_scalableminds_webknossos_datastore_helpers_NativeBucketScanner_extendSegmentBoundingBox
  (JNIEnv *, jobject, jbyteArray, jint, jboolean, jint, jlong, jint, jint, jint, jint, jint, jint, jint, jint, jint);

#ifdef __cplusplus
}
#endif
#endif
