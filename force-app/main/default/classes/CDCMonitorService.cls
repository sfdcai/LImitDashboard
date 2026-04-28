public with sharing class CDCMonitorService implements ObservabilityCollector {
    public void execute() {
        List<CDC_Metrics__c> rows = new List<CDC_Metrics__c>();
        for (EventBusSubscriber sub : [
            SELECT Name, Position
            FROM EventBusSubscriber
            LIMIT 2000
            WITH USER_MODE
        ]) {
            rows.add(new CDC_Metrics__c(
                Object_Name__c = sub.Name,
                Events_Published__c = 0,
                Events_Consumed__c = sub.Position,
                Replay_Lag__c = 0,
                Timestamp__c = Datetime.now()
            ));
        }
        if (!rows.isEmpty()) {
            insert Security.stripInaccessible(AccessType.CREATABLE, rows).getRecords();
        }
    }
}
