local env = {
  namespace: std.extVar('qbec.io/env'),
};
local p = import '../params.libsonnet';
local params = p.components.clockapp;

[
  {
    apiVersion: 'v1',
    kind: 'Namespace',
    metadata: {
      name: params.name,
    },
  },
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      labels: { app: params.name },
      name: params.name,
    },
    spec: {
      replicas: params.replicas,
      selector: {
        matchLabels: {
          app: params.name,
        },
      },
      template: {
        metadata: {
          labels: { app: params.name },
        },
        spec: {
          containers: [
            {
              name: params.name,
              image: params.image,
            },
          ],
        },
      },
    },
  },
  {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      labels: { app: params.name },
      name: params.serviceName,
    },
    spec: {
      selector: {
        app: params.name,
      },
      ports: [
        {
          name: params.name,
          port: params.servicePort,
          protocol: params.serviceProtocol,
          targetPort: params.containerPort,
        },
      ],
    },
  },
]