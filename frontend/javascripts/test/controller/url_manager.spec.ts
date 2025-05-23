import "test/mocks/lz4";
import test from "ava";
import UrlManager, {
  updateTypeAndId,
  encodeUrlHash,
  type UrlManagerState,
  getDatasetNameFromLocation,
  getUpdatedPathnameWithNewDatasetName,
} from "oxalis/controller/url_manager";
import { location } from "libs/window";
import Constants, { type Vector3, ViewModeValues } from "oxalis/constants";
import defaultState from "oxalis/default_state";
import update from "immutability-helper";
import DATASET from "../fixtures/dataset_server_object";
import _ from "lodash";

test("UrlManager should replace tracing in url", (t) => {
  // Without annotationType (Explorational and Task don't appear in the URL)
  t.is(
    updateTypeAndId("abc/def/annotations/annotationId", "Explorational", "newAnnotationId"),
    "abc/def/annotations/newAnnotationId",
  );
  t.is(
    updateTypeAndId("abc/def/annotations/annotationId/readOnly", "Task", "newAnnotationId"),
    "abc/def/annotations/newAnnotationId/readOnly",
  );

  // With annotationType (CompoundTask / CompoundProject)
  t.is(
    updateTypeAndId(
      "abc/def/annotations/CompoundTask/annotationId",
      "CompoundProject",
      "newAnnotationId",
    ),
    "abc/def/annotations/CompoundProject/newAnnotationId",
  );
  t.is(
    updateTypeAndId(
      "abc/def/annotations/CompoundTask/annotationId/readOnly",
      "CompoundProject",
      "newAnnotationId",
    ),
    "abc/def/annotations/CompoundProject/newAnnotationId/readOnly",
  );
});

test("UrlManager should parse full csv url hash", (t) => {
  const state = {
    position: [555, 278, 482] as Vector3,
    mode: "flight" as const,
    zoomStep: 2.0,
    rotation: [40.45, 13.65, 0.8] as Vector3,
    activeNode: 2,
  } as const;
  location.hash = `#${[
    ...state.position,
    ViewModeValues.indexOf(state.mode),
    state.zoomStep,
    ...state.rotation,
    state.activeNode,
  ].join(",")}`;
  t.deepEqual(UrlManager.parseUrlHash(), state);
});

test("UrlManager should parse csv url hash without optional values", (t) => {
  const state = {
    position: [555, 278, 482] as Vector3,
    mode: "flight" as const,
    zoomStep: 2.0,
    rotation: [40.45, 13.65, 0.8] as Vector3,
    activeNode: 2,
  };
  const { rotation, ...stateWithoutRotation } = state;
  location.hash = `#${[
    ...state.position,
    ViewModeValues.indexOf(state.mode),
    state.zoomStep,
    state.activeNode,
  ].join(",")}`;
  t.deepEqual(UrlManager.parseUrlHash(), stateWithoutRotation as Partial<UrlManagerState>);
  const { activeNode, ...stateWithoutActiveNode } = state;
  location.hash = `#${[
    ...state.position,
    ViewModeValues.indexOf(state.mode),
    state.zoomStep,
    ...state.rotation,
  ].join(",")}`;
  t.deepEqual(UrlManager.parseUrlHash(), stateWithoutActiveNode);
  const { activeNode: _, rotation: __, ...stateWithoutOptionalValues } = state;
  location.hash = `#${[...state.position, ViewModeValues.indexOf(state.mode), state.zoomStep].join(
    ",",
  )}`;
  t.deepEqual(UrlManager.parseUrlHash(), stateWithoutOptionalValues);
});

test("UrlManager should build csv url hash and parse it again", (t) => {
  const mode = Constants.MODE_ARBITRARY;
  const urlState = {
    position: [0, 0, 0] as Vector3,
    mode,
    zoomStep: 1.3,
    rotation: [0, 0, 180] as Vector3,
  };
  const initialState = update(defaultState, {
    temporaryConfiguration: {
      viewMode: {
        $set: mode,
      },
    },
  });
  const hash = UrlManager.buildUrlHashCsv(initialState);
  location.hash = `#${hash}`;
  t.deepEqual(UrlManager.parseUrlHash(), urlState);
});

test("UrlManager should build csv url hash with additional coordinates and parse it again", (t) => {
  const mode = Constants.MODE_ARBITRARY;
  const urlState = {
    position: [0, 0, 0] as Vector3,
    mode,
    zoomStep: 1.3,
    rotation: [0, 0, 180] as Vector3,
    additionalCoordinates: [{ name: "t", value: 123 }],
  };
  const initialState = update(defaultState, {
    temporaryConfiguration: {
      viewMode: {
        $set: mode,
      },
    },
    flycam: {
      additionalCoordinates: { $set: [{ name: "t", value: 123 }] },
    },
  });

  const hash = UrlManager.buildUrlHashCsv(initialState);
  location.hash = `#${hash}`;
  t.deepEqual(UrlManager.parseUrlHash(), urlState);
});

test("UrlManager should parse url hash with comment links", (t) => {
  const state = {
    position: [555, 278, 482] as Vector3,
    activeNode: 2,
  };

  for (const [key, value] of Object.entries(state)) {
    location.hash = `#${key}=${value}`;
    t.deepEqual(UrlManager.parseUrlHash(), {
      [key]: value,
    });
  }
});

test("UrlManager should parse json url hash", (t) => {
  const state = {
    position: [555, 278, 482] as Vector3,
    additionalCoordinates: [],
    mode: "flight" as const,
    zoomStep: 2.0,
    rotation: [40.45, 13.65, 0.8] as Vector3,
    activeNode: 2,
  };
  location.hash = `#${encodeUrlHash(JSON.stringify(state))}`;
  t.deepEqual(UrlManager.parseUrlHash(), state);
});

test("UrlManager should parse incomplete json url hash", (t) => {
  const state = {
    position: [555, 278, 482] as Vector3,
    additionalCoordinates: [],
    mode: "flight" as const,
    zoomStep: 2.0,
    rotation: [40.45, 13.65, 0.8] as Vector3,
    activeNode: 2,
  };
  const { rotation, ...stateWithoutRotation } = state;
  location.hash = `#${encodeUrlHash(JSON.stringify(stateWithoutRotation))}`;
  t.deepEqual(UrlManager.parseUrlHash(), stateWithoutRotation);
  const { activeNode, ...stateWithoutActiveNode } = state;
  location.hash = `#${encodeUrlHash(JSON.stringify(stateWithoutActiveNode))}`;
  t.deepEqual(UrlManager.parseUrlHash(), stateWithoutActiveNode);
});

test("UrlManager should build json url hash and parse it again", (t) => {
  const mode = Constants.MODE_ARBITRARY;
  const urlState = {
    position: [0, 0, 0] as Vector3,
    additionalCoordinates: [],
    mode,
    zoomStep: 1.3,
    rotation: [0, 0, 180] as Vector3 as Vector3,
  };
  const initialState = update(defaultState, {
    temporaryConfiguration: {
      viewMode: {
        $set: mode,
      },
    },
  });
  const hash = UrlManager.buildUrlHashJson(initialState);
  location.hash = `#${hash}`;
  t.deepEqual(UrlManager.parseUrlHash(), urlState as Partial<UrlManagerState>);
});

test("UrlManager should build default url in csv format", (t) => {
  UrlManager.initialize();
  const url = UrlManager.buildUrl();
  t.is(url, "#0,0,0,0,1.3");
});

test("The dataset name should be correctly extracted from view URLs", (t) => {
  const datasetNameEasy = "extract_me";
  const datasetNameComplex = "$find1-me9";
  // View
  location.pathname = `/datasets/${datasetNameEasy}-${DATASET.id}/view`;
  t.is(datasetNameEasy, getDatasetNameFromLocation(location) as string);
  // Sandbox
  location.pathname = `/datasets/${datasetNameEasy}-${DATASET.id}/sandbox/hybrid`;
  t.is(datasetNameEasy, getDatasetNameFromLocation(location) as string);
  // View - complex
  location.pathname = `/datasets/${datasetNameComplex}-${DATASET.id}/sandbox/hybrid`;
  t.is(datasetNameComplex, getDatasetNameFromLocation(location) as string);
  // Sandbox - complex
  location.pathname = `/datasets/${datasetNameComplex}-${DATASET.id}/sandbox/hybrid`;
  t.is(datasetNameComplex, getDatasetNameFromLocation(location) as string);
});

test("Inserting an updated dataset name in the URL should yield the correct URL", (t) => {
  const testDatasetEasy = update(_.clone(DATASET), { name: { $set: "extract_me" } });
  const testDatasetComplex = update(_.clone(DATASET), { name: { $set: "$3xtr4c7-me9" } });
  // View
  location.pathname = `/datasets/replace_me-${testDatasetEasy.id}/view`;
  const newPathName1 = getUpdatedPathnameWithNewDatasetName(location, testDatasetEasy);
  const expectedPathname1 = `/datasets/${testDatasetEasy.name}-${testDatasetEasy.id}/view`;
  t.is(expectedPathname1, newPathName1);
  // Sandbox
  location.pathname = `/datasets/replace_me-${testDatasetEasy.id}/sandbox/skeleton`;
  const newPathName2 = getUpdatedPathnameWithNewDatasetName(location, testDatasetEasy);
  const expectedPathname2 = `/datasets/${testDatasetEasy.name}-${testDatasetEasy.id}/sandbox/skeleton`;
  t.is(expectedPathname2, newPathName2);
  // View - complex
  location.pathname = `/datasets/replace_me-${testDatasetComplex.id}/view`;
  const newPathName3 = getUpdatedPathnameWithNewDatasetName(location, testDatasetComplex);
  const expectedPathname3 = `/datasets/${testDatasetComplex.name}-${testDatasetComplex.id}/view`;
  t.is(expectedPathname3, newPathName3);
  // Sandbox - complex
  location.pathname = `/datasets/replace_me-${testDatasetComplex.id}/sandbox/skeleton`;
  const newPathName4 = getUpdatedPathnameWithNewDatasetName(location, testDatasetComplex);
  const expectedPathname4 = `/datasets/${testDatasetComplex.name}-${testDatasetComplex.id}/sandbox/skeleton`;
  t.is(expectedPathname4, newPathName4);
});
