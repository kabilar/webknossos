# Changelog (Unreleased)

All notable (yet unreleased) user-facing changes to WEBKNOSSOS are documented in this file.
See `CHANGELOG.released.md` for the changes which are part of official releases.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Calendar Versioning](http://calver.org/) `0Y.0M.MICRO`.
For upgrade instructions, please check the [migration guide](MIGRATIONS.released.md).

## Unreleased
[Commits](https://github.com/scalableminds/webknossos/compare/25.03.1...HEAD)

### Added
- Added the option for the owner to lock explorative annotations. Locked annotations cannot be modified by any user. An annotation can be locked in the annotations table and when viewing the annotation via the navbar dropdown menu. [#7801](https://github.com/scalableminds/webknossos/pull/7801)
- Added the option to set a default mapping for a dataset in the dataset view configuration. The default mapping is loaded when the dataset is opened and the user / url does not configure something else. [#7858](https://github.com/scalableminds/webknossos/pull/7858)
- Uploading an annotation into a dataset that it was not created for now also works if the dataset is in a different organization. [#7816](https://github.com/scalableminds/webknossos/pull/7816)
- When downloading + reuploading an annotation that is based on a segmentation layer with active mapping, that mapping is now still be selected after the reupload. [#7822](https://github.com/scalableminds/webknossos/pull/7822)
- In the Voxelytics workflow list, the name of the WEBKNOSSOS user who started the job is displayed. [#7794](https://github.com/scalableminds/webknossos/pull/7795)
- Start an alignment job (aligns the section in a dataset) via the "AI Analysis" button. [#7820](https://github.com/scalableminds/webknossos/pull/7820)
- Added additional validation for the animation job modal. Bounding boxes must be larger then zero. [#7883](https://github.com/scalableminds/webknossos/pull/7883)

### Changed
- The "WEBKNOSSOS Changelog" modal now lazily loads its content potentially speeding up the initial loading time of WEBKNOSSOS and thus improving the UX. [#7843](https://github.com/scalableminds/webknossos/pull/7843)
- Updated the min max settings for the histogram to allow floating point color layers to have negative min / max values. [#7873](https://github.com/scalableminds/webknossos/pull/7873)
- Made the login, registration, forgot password and dataset dashboard pages more mobile friendly. [#7876](https://github.com/scalableminds/webknossos/pull/7876)
- From now on only project owner get a notification email upon project overtime. The organization specific email list `overTimeMailingList` was removed. [#7842](https://github.com/scalableminds/webknossos/pull/7842)
- Replaced skeleton comment tab component with antd's `<Tree />`component. [#7802](https://github.com/scalableminds/webknossos/pull/7802)

### Fixed
- Fixed a bug where the warning to zoom in to see the agglomerate mapping was shown to the user even when the 3D viewport was maximized and no volume data was shown. [#7865](https://github.com/scalableminds/webknossos/issues/7865) 
- Fixed a bug where brushing on a fallback segmentation with active mapping and with segment index file would lead to failed saves. [#7833](https://github.com/scalableminds/webknossos/pull/7833)
- Fixed a bug where sometimes old mismatching javascript code would be served after upgrades. [#7854](https://github.com/scalableminds/webknossos/pull/7854)
- Fixed a bug where dataset uploads of zipped tiff data via the UI would be rejected. [#7856](https://github.com/scalableminds/webknossos/pull/7856)
- Fixed a bug with incorrect valiation of layer names in the animation modal. [#7882](https://github.com/scalableminds/webknossos/pull/7882)

- It is now possible to focus a bounding box in the bounding box tab by clicking its edges in a viewport or via a newly added context menu entry. [#8054](https://github.com/scalableminds/webknossos/pull/8054)
### Added
- Added an assertion to the backend to ensure unique keys in the metadata info of datasets and folders. [#8068](https://github.com/scalableminds/webknossos/issues/8068)
- It is now possible to add metadata in annotations to Trees and Segments. [#7875](https://github.com/scalableminds/webknossos/pull/7875)
- Added a summary row to the time tracking overview, where times and annotations/tasks are summed. [#8092](https://github.com/scalableminds/webknossos/pull/8092)
- Most sliders have been improved: Wheeling above a slider now changes its value and double-clicking its knob resets it to its default value. [#8095](https://github.com/scalableminds/webknossos/pull/8095)
- Increased loading speed for precomputed meshes. [#8110](https://github.com/scalableminds/webknossos/pull/8110)

### Changed
- When deleting a dataset / layer, layers that are referenced in other datasets are moved there instead of being deleted. [#8437](https://github.com/scalableminds/webknossos/pull/8437/)
- Added a parameter to the reserve manual upload route allowing to make the request fail if the name is already taken. Moreover, the new dataset's id and directory name are returned in the response. [#8476](https://github.com/scalableminds/webknossos/pull/8476)
- The skeleton tool can no longer be activated if the skeleton layer is invisible. [#8501](https://github.com/scalableminds/webknossos/pull/8501)
- Improved speed of mesh rendering and mouse interaction in 3D viewport. [#8106](https://github.com/scalableminds/webknossos/pull/8106)
- Numbered docker image now use different and larger numbers. [#8147](https://github.com/scalableminds/webknossos/pull/8147)

### Fixed
- Fixed a Bug where the "Save view configuration as default" modal's text included undefined.  [#8514](https://github.com/scalableminds/webknossos/pull/8514)
- Fixed the alignment of the button that allows restricting floodfill operations to a bounding box. [#8388](https://github.com/scalableminds/webknossos/pull/8388) 
- Fixed that it was possible to trigger the find largest segment id job on layers which are not stored as segmentation layers on the server. [#8503](https://github.com/scalableminds/webknossos/pull/8503)
- Fixed a rare and subtle bug related to volume annotation and undo/redo. [#7506](https://github.com/scalableminds/webknossos/pull/7506)
- Fixed a bug where segment statistics would sometimes be wrong in case of an on-disk segmentation fallback layer with segment index file. [#8460](https://github.com/scalableminds/webknossos/pull/8460)
- Fixed a bug where sometimes outdated segment statistics would be displayed. [#8460](https://github.com/scalableminds/webknossos/pull/8460)
- Fixed a bug where outbound zarr streaming would contain a typo in the zarr header dimension_separator field. [#8510](https://github.com/scalableminds/webknossos/pull/8510)
- Fixed a bug where sometimes large skeletons were not saved correctly, making them inaccessible on the next load. [#8513](https://github.com/scalableminds/webknossos/pull/8513)
- Fixed that meshes weren't loaded correctly if the precomputed mesh file contained multiple levels-of-detail. [#8519](https://github.com/scalableminds/webknossos/pull/8519)
- Fixed that authentication-related token renewal did not work properly in certain scenarios. [#8532](https://github.com/scalableminds/webknossos/pull/8532)

### Removed

### Breaking Changes
- Removed `docker-compose.yml` in favor of `tools/hosting/docker-compose.yml` [#8147](https://github.com/scalableminds/webknossos/pull/8147)
