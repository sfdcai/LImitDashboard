public with sharing class LimitsCollectorService implements ObservabilityCollector {
    public void execute() {
        System.enqueueJob(new LimitsService());
    }
}
