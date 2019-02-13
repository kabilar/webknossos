# Snapshot report for `public/test-bundle/test/backend-snapshot-tests/projects.e2e.js`

The actual snapshot is saved in `projects.e2e.js.snap`.

Generated by [AVA](https://ava.li).

## projects-createProject(project: APIProjectType)

    {
      expectedTime: 60000,
      id: 'fixed-project-id',
      isBlacklistedFromReport: true,
      name: 'test-new-project',
      owner: {
        email: 'user_A@scalableminds.com',
        firstName: 'user_A',
        id: '570b9f4d2a7c0e4d008da6ef',
        isAnonymous: false,
        lastName: 'BoyA',
        teams: [
          {
            id: '570b9f4b2a7c0e3b008da6ec',
            isTeamManager: true,
            name: 'team_X1',
          },
          {
            id: '59882b370d889b84020efd3f',
            isTeamManager: false,
            name: 'team_X3',
          },
          {
            id: '59882b370d889b84020efd6f',
            isTeamManager: true,
            name: 'team_X4',
          },
        ],
      },
      paused: false,
      priority: 1,
      team: '570b9f4b2a7c0e3b008da6ec',
      teamName: 'team_X1',
    }

## projects-deleteProject(projectName: string)

    {
      messages: [
        {
          success: 'Project was removed',
        },
      ],
    }

## projects-getProject(projectName: string)

    {
      expectedTime: 90,
      id: '58135bfd2faeb3190181c057',
      isBlacklistedFromReport: false,
      name: 'Test_Project',
      owner: {
        email: 'user_A@scalableminds.com',
        firstName: 'user_A',
        id: '570b9f4d2a7c0e4d008da6ef',
        isAnonymous: false,
        lastName: 'BoyA',
        teams: [
          {
            id: '570b9f4b2a7c0e3b008da6ec',
            isTeamManager: true,
            name: 'team_X1',
          },
          {
            id: '59882b370d889b84020efd3f',
            isTeamManager: false,
            name: 'team_X3',
          },
          {
            id: '59882b370d889b84020efd6f',
            isTeamManager: true,
            name: 'team_X4',
          },
        ],
      },
      paused: false,
      priority: 100,
      team: '570b9f4b2a7c0e3b008da6ec',
      teamName: 'team_X1',
    }

## projects-getProjects()

    [
      {
        expectedTime: 90,
        id: '58135bfd2faeb3190181c057',
        isBlacklistedFromReport: false,
        name: 'Test_Project',
        owner: {
          email: 'user_A@scalableminds.com',
          firstName: 'user_A',
          id: '570b9f4d2a7c0e4d008da6ef',
          isAnonymous: false,
          lastName: 'BoyA',
          teams: [
            {
              id: '570b9f4b2a7c0e3b008da6ec',
              isTeamManager: true,
              name: 'team_X1',
            },
            {
              id: '59882b370d889b84020efd3f',
              isTeamManager: false,
              name: 'team_X3',
            },
            {
              id: '59882b370d889b84020efd6f',
              isTeamManager: true,
              name: 'team_X4',
            },
          ],
        },
        paused: false,
        priority: 100,
        team: '570b9f4b2a7c0e3b008da6ec',
        teamName: 'team_X1',
      },
      {
        expectedTime: 90,
        id: '68135bfd2faeb3190181c058',
        isBlacklistedFromReport: false,
        name: 'Test_Project2',
        owner: {
          email: 'user_D@scalableminds.com',
          firstName: 'user_D',
          id: '870b9f4d2a7c0e4d008da6ef',
          isAnonymous: false,
          lastName: 'BoyD',
          teams: [
            {
              id: '69882b370d889b84020efd4f',
              isTeamManager: true,
              name: 'team_X2',
            },
          ],
        },
        paused: false,
        priority: 100,
        team: '69882b370d889b84020efd4f',
        teamName: 'team_X2',
      },
      {
        expectedTime: 90,
        id: '78135bfd2faeb3190181c058',
        isBlacklistedFromReport: false,
        name: 'Test_Project3(for_annotation_mutations)',
        owner: {
          email: 'user_D@scalableminds.com',
          firstName: 'user_D',
          id: '870b9f4d2a7c0e4d008da6ef',
          isAnonymous: false,
          lastName: 'BoyD',
          teams: [
            {
              id: '69882b370d889b84020efd4f',
              isTeamManager: true,
              name: 'team_X2',
            },
          ],
        },
        paused: false,
        priority: 100,
        team: '69882b370d889b84020efd4f',
        teamName: 'team_X2',
      },
    ]

## projects-getProjectsWithOpenAssignments()

    [
      {
        expectedTime: 90,
        id: '58135bfd2faeb3190181c057',
        isBlacklistedFromReport: false,
        name: 'Test_Project',
        numberOfOpenAssignments: 19,
        owner: {
          email: 'user_A@scalableminds.com',
          firstName: 'user_A',
          id: '570b9f4d2a7c0e4d008da6ef',
          isAnonymous: false,
          lastName: 'BoyA',
          teams: [
            {
              id: '570b9f4b2a7c0e3b008da6ec',
              isTeamManager: true,
              name: 'team_X1',
            },
            {
              id: '59882b370d889b84020efd3f',
              isTeamManager: false,
              name: 'team_X3',
            },
            {
              id: '59882b370d889b84020efd6f',
              isTeamManager: true,
              name: 'team_X4',
            },
          ],
        },
        paused: false,
        priority: 100,
        team: '570b9f4b2a7c0e3b008da6ec',
        teamName: 'team_X1',
      },
      {
        expectedTime: 90,
        id: '68135bfd2faeb3190181c058',
        isBlacklistedFromReport: false,
        name: 'Test_Project2',
        numberOfOpenAssignments: 10,
        owner: {
          email: 'user_D@scalableminds.com',
          firstName: 'user_D',
          id: '870b9f4d2a7c0e4d008da6ef',
          isAnonymous: false,
          lastName: 'BoyD',
          teams: [
            {
              id: '69882b370d889b84020efd4f',
              isTeamManager: true,
              name: 'team_X2',
            },
          ],
        },
        paused: false,
        priority: 100,
        team: '69882b370d889b84020efd4f',
        teamName: 'team_X2',
      },
      {
        expectedTime: 90,
        id: '78135bfd2faeb3190181c058',
        isBlacklistedFromReport: false,
        name: 'Test_Project3(for_annotation_mutations)',
        numberOfOpenAssignments: 10,
        owner: {
          email: 'user_D@scalableminds.com',
          firstName: 'user_D',
          id: '870b9f4d2a7c0e4d008da6ef',
          isAnonymous: false,
          lastName: 'BoyD',
          teams: [
            {
              id: '69882b370d889b84020efd4f',
              isTeamManager: true,
              name: 'team_X2',
            },
          ],
        },
        paused: false,
        priority: 100,
        team: '69882b370d889b84020efd4f',
        teamName: 'team_X2',
      },
    ]

## projects-increaseProjectTaskInstances(projectName: string, delta?: number)

    {
      expectedTime: 90,
      id: '68135bfd2faeb3190181c058',
      isBlacklistedFromReport: false,
      name: 'Test_Project2',
      numberOfOpenAssignments: 20,
      owner: {
        email: 'user_D@scalableminds.com',
        firstName: 'user_D',
        id: '870b9f4d2a7c0e4d008da6ef',
        isAnonymous: false,
        lastName: 'BoyD',
        teams: [
          {
            id: '69882b370d889b84020efd4f',
            isTeamManager: true,
            name: 'team_X2',
          },
        ],
      },
      paused: false,
      priority: 100,
      team: '69882b370d889b84020efd4f',
      teamName: 'team_X2',
    }

## projects-pauseProject(projectName: string)

    {
      expectedTime: 90,
      id: '58135bfd2faeb3190181c057',
      isBlacklistedFromReport: false,
      name: 'Test_Project',
      owner: {
        email: 'user_A@scalableminds.com',
        firstName: 'user_A',
        id: '570b9f4d2a7c0e4d008da6ef',
        isAnonymous: false,
        lastName: 'BoyA',
        teams: [
          {
            id: '570b9f4b2a7c0e3b008da6ec',
            isTeamManager: true,
            name: 'team_X1',
          },
          {
            id: '59882b370d889b84020efd3f',
            isTeamManager: false,
            name: 'team_X3',
          },
          {
            id: '59882b370d889b84020efd6f',
            isTeamManager: true,
            name: 'team_X4',
          },
        ],
      },
      paused: true,
      priority: 100,
      team: '570b9f4b2a7c0e3b008da6ec',
      teamName: 'team_X1',
    }

## projects-resumeProject(projectName: string)

    {
      expectedTime: 90,
      id: '58135bfd2faeb3190181c057',
      isBlacklistedFromReport: false,
      name: 'Test_Project',
      owner: {
        email: 'user_A@scalableminds.com',
        firstName: 'user_A',
        id: '570b9f4d2a7c0e4d008da6ef',
        isAnonymous: false,
        lastName: 'BoyA',
        teams: [
          {
            id: '570b9f4b2a7c0e3b008da6ec',
            isTeamManager: true,
            name: 'team_X1',
          },
          {
            id: '59882b370d889b84020efd3f',
            isTeamManager: false,
            name: 'team_X3',
          },
          {
            id: '59882b370d889b84020efd6f',
            isTeamManager: true,
            name: 'team_X4',
          },
        ],
      },
      paused: false,
      priority: 100,
      team: '570b9f4b2a7c0e3b008da6ec',
      teamName: 'team_X1',
    }

## projects-revertedProject

    {
      expectedTime: 5400000,
      id: '58135bfd2faeb3190181c057',
      isBlacklistedFromReport: false,
      name: 'Test_Project',
      owner: {
        email: 'user_A@scalableminds.com',
        firstName: 'user_A',
        id: '570b9f4d2a7c0e4d008da6ef',
        isAnonymous: false,
        lastName: 'BoyA',
        teams: [
          {
            id: '570b9f4b2a7c0e3b008da6ec',
            isTeamManager: true,
            name: 'team_X1',
          },
          {
            id: '59882b370d889b84020efd3f',
            isTeamManager: false,
            name: 'team_X3',
          },
          {
            id: '59882b370d889b84020efd6f',
            isTeamManager: true,
            name: 'team_X4',
          },
        ],
      },
      paused: false,
      priority: 100,
      team: '570b9f4b2a7c0e3b008da6ec',
      teamName: 'team_X1',
    }

## projects-updateProject(projectName: string, project: APIProjectType)

    {
      expectedTime: 5400000,
      id: '58135bfd2faeb3190181c057',
      isBlacklistedFromReport: false,
      name: 'Test_Project',
      owner: {
        email: 'user_A@scalableminds.com',
        firstName: 'user_A',
        id: '570b9f4d2a7c0e4d008da6ef',
        isAnonymous: false,
        lastName: 'BoyA',
        teams: [
          {
            id: '570b9f4b2a7c0e3b008da6ec',
            isTeamManager: true,
            name: 'team_X1',
          },
          {
            id: '59882b370d889b84020efd3f',
            isTeamManager: false,
            name: 'team_X3',
          },
          {
            id: '59882b370d889b84020efd6f',
            isTeamManager: true,
            name: 'team_X4',
          },
        ],
      },
      paused: false,
      priority: 1337,
      team: '570b9f4b2a7c0e3b008da6ec',
      teamName: 'team_X1',
    }