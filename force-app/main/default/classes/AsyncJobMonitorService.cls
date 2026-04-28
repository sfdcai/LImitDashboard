public with sharing class AsyncJobMonitorService implements ObservabilityCollector {
    public void execute() {
        HealthService.collectAsyncJobs();
    }
}
