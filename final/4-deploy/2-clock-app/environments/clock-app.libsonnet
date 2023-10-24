
// this file has the baseline default parameters
{
  components: {
    clockapp: {
      name: 'clock-app',
      image: 'cr.yandex/crpjp4ujjlrt73g1f32k/clock-app',
      replicas: 1,
      serviceName: 'clock-app-svc',
      servicePort: 80,
      serviceProtocol: 'TCP',
      containerPort: 8000,
    },
  },
}
