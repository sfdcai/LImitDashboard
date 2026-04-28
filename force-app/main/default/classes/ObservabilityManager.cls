public with sharing class ObservabilityManager {
    public static void runAll() {
        List<ObservabilityCollector> collectors = new List<ObservabilityCollector>{
            new HealthService(),
            new StorageCollectorService(),
            new CDCMonitorService(),
            new EmailMetricsService(),
            new LicenseCollectorService(),
            new AsyncJobMonitorService()
        };
        for (ObservabilityCollector collector : collectors) {
            collector.execute();
        }
        System.enqueueJob(new LimitsService());
    }
}
