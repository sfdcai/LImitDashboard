public with sharing class ObservabilitySchedulable implements Schedulable {
    public void execute(SchedulableContext context) {
        HealthService service = new HealthService();
        service.execute();
        System.enqueueJob(new LimitsService());
        new StorageCollectorService().execute();
        new CDCMonitorService().execute();
    }

    public static void scheduleHourly() {
        System.schedule('Observability Hourly', '0 0 * * * ?', new ObservabilitySchedulable());
    }
}
