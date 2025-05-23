# Snapshot report for `public-test/test-bundle/test/backend-snapshot-tests/datasets.e2e.js`

The actual snapshot is saved in `datasets.e2e.js.snap`.

Generated by [AVA](https://avajs.dev).

## getDatasets

> Snapshot 1

    [
      {
        colorLayerNames: [],
        created: 'created',
        directoryName: '2012-06-28_Cortex',
        folderId: '570b9f4e4bb848d0885ea917',
        id: 'id',
        isActive: false,
        isEditable: true,
        isUnreported: true,
        lastUsedByUser: 0,
        name: '2012-06-28_Cortex',
        owningOrganization: 'Organization_X',
        segmentationLayerNames: [],
        status: 'No longer available on datastore.',
        tags: [],
      },
      {
        colorLayerNames: [],
        created: 'created',
        directoryName: '2012-09-28_ex145_07x2',
        folderId: '570b9f4e4bb848d0885ea917',
        id: 'id',
        isActive: false,
        isEditable: true,
        isUnreported: true,
        lastUsedByUser: 0,
        name: '2012-09-28_ex145_07x2',
        owningOrganization: 'Organization_X',
        segmentationLayerNames: [],
        status: 'No longer available on datastore.',
        tags: [],
      },
      {
        colorLayerNames: [],
        created: 'created',
        directoryName: 'Experiment_001',
        folderId: '570b9f4e4bb848d0885ea917',
        id: 'id',
        isActive: false,
        isEditable: true,
        isUnreported: true,
        lastUsedByUser: 0,
        name: 'Experiment_001',
        owningOrganization: 'Organization_X',
        segmentationLayerNames: [],
        status: 'No longer available on datastore.',
        tags: [],
      },
      {
        colorLayerNames: [],
        created: 'created',
        directoryName: 'confocal-multi_knossos',
        folderId: '570b9f4e4bb848d0885ea917',
        id: 'id',
        isActive: false,
        isEditable: true,
        isUnreported: true,
        lastUsedByUser: 0,
        name: 'confocal-multi_knossos',
        owningOrganization: 'Organization_X',
        segmentationLayerNames: [],
        status: 'No longer available on datastore.',
        tags: [],
      },
      {
        colorLayerNames: [],
        created: 'created',
        directoryName: 'l4_sample',
        folderId: '570b9f4e4bb848d0885ea917',
        id: 'id',
        isActive: false,
        isEditable: true,
        isUnreported: true,
        lastUsedByUser: 0,
        name: 'l4_sample',
        owningOrganization: 'Organization_X',
        segmentationLayerNames: [],
        status: 'No longer available on datastore.',
        tags: [],
      },
      {
        colorLayerNames: [],
        created: 'created',
        directoryName: 'rgb',
        folderId: '570b9f4e4bb848d0885ea917',
        id: 'id',
        isActive: false,
        isEditable: true,
        isUnreported: true,
        lastUsedByUser: 0,
        name: 'rgb',
        owningOrganization: 'Organization_X',
        segmentationLayerNames: [],
        status: 'No longer available on datastore.',
        tags: [],
      },
      {
        colorLayerNames: [],
        created: 'created',
        directoryName: 'test-dataset',
        folderId: '570b9f4e4bb848d0885ea917',
        id: 'id',
        isActive: true,
        isEditable: true,
        isUnreported: false,
        lastUsedByUser: 0,
        name: 'test-dataset',
        owningOrganization: 'Organization_X',
        segmentationLayerNames: [
          'segmentation',
        ],
        status: '',
        tags: [],
      },
    ]

## getActiveDatasets

> Snapshot 1

    [
      {
        allowedTeams: [],
        allowedTeamsCumulative: [],
        created: 'created',
        dataSource: {
          dataLayers: [
            {
              boundingBox: {
                depth: 100,
                height: 100,
                topLeft: [
                  50,
                  50,
                  25,
                ],
                width: 100,
              },
              category: 'segmentation',
              elementClass: 'uint32',
              largestSegmentId: 176,
              name: 'segmentation',
              resolutions: [
                [
                  1,
                  1,
                  1,
                ],
              ],
            },
          ],
          id: 'id',
          scale: {
            factor: [
              11.24,
              11.24,
              28,
            ],
            unit: 'nanometer',
          },
        },
        dataStore: {
          allowsUpload: true,
          jobsEnabled: false,
          jobsSupportedByAvailableWorkers: [],
          name: 'localhost',
          url: 'http://localhost:9000',
        },
        description: null,
        directoryName: 'test-dataset',
        folderId: '570b9f4e4bb848d0885ea917',
        id: 'id',
        isActive: true,
        isEditable: true,
        isPublic: false,
        isUnreported: false,
        lastUsedByUser: 0,
        logoUrl: '/assets/images/mpi-logos.svg',
        metadata: [],
        name: 'test-dataset',
        owningOrganization: 'Organization_X',
        publication: null,
        sortingKey: 'sortingKey',
        tags: [],
        usedStorageBytes: 0,
      },
    ]

## getDatasetAccessList

> Snapshot 1

    [
      {
        email: 'user_A@scalableminds.com',
        firstName: 'user_A',
        id: 'id',
        isAdmin: true,
        isAnonymous: false,
        isDatasetManager: true,
        lastName: 'last_A',
        teams: [
          {
            id: 'id',
            isTeamManager: true,
            name: 'team_X1',
          },
          {
            id: 'id',
            isTeamManager: false,
            name: 'team_X3',
          },
          {
            id: 'id',
            isTeamManager: true,
            name: 'team_X4',
          },
        ],
      },
      {
        email: 'user_B@scalableminds.com',
        firstName: 'user_B',
        id: 'id',
        isAdmin: false,
        isAnonymous: false,
        isDatasetManager: true,
        lastName: 'last_B',
        teams: [
          {
            id: 'id',
            isTeamManager: true,
            name: 'team_X1',
          },
        ],
      },
    ]

## updateDatasetTeams

> Snapshot 1

    [
      '570b9f4b2a7c0e3b008da6ec',
      '59882b370d889b84020efd3f',
      '59882b370d889b84020efd6f',
      '69882b370d889b84020efd4f',
    ]

## Zarr streaming

> Snapshot 1

    '{"multiscales":[{"version":"0.4","name":"segmentation","axes":[{"name":"c","type":"channel"},{"name":"x","type":"space","unit":"nanometer"},{"name":"y","type":"space","unit":"nanometer"},{"name":"z","type":"space","unit":"nanometer"}],"datasets":[{"path":"1","coordinateTransformations":[{"type":"scale","scale":[1,11.24,11.24,28]}]}]}]}'

> Snapshot 2

    'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAA='

## Zarr 3 streaming

> Snapshot 1

    '{"zarr_format":3,"node_type":"group","attributes":{"ome":{"version":"0.5","multiscales":[{"name":"segmentation","axes":[{"name":"c","type":"channel"},{"name":"x","type":"space","unit":"nanometer"},{"name":"y","type":"space","unit":"nanometer"},{"name":"z","type":"space","unit":"nanometer"}],"datasets":[{"path":"1","coordinateTransformations":[{"type":"scale","scale":[1,11.24,11.24,28]}]}]}]}}}'

> Snapshot 2

    'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAA='
