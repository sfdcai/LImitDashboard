public with sharing class DataRetentionBatch implements Database.Batchable<SObject> {
    private static final Integer RETENTION_DAYS = 30;

    public Database.QueryLocator start(Database.BatchableContext context) {
        DateTime threshold = DateTime.now().addDays(-RETENTION_DAYS);
        return Database.getQueryLocator([
            SELECT Id FROM Org_Limits__c WHERE Timestamp__c < :threshold
        ]);
    }

    public void execute(Database.BatchableContext context, List<SObject> scope) {
        if (!scope.isEmpty()) {
            delete scope;
        }
    }

    public void finish(Database.BatchableContext context) {
        DateTime threshold = DateTime.now().addDays(-RETENTION_DAYS);
        delete [SELECT Id FROM License_Usage__c WHERE CreatedDate < :threshold LIMIT 10000];
        delete [SELECT Id FROM Async_Job_Monitor__c WHERE Created_Date__c < :threshold LIMIT 10000];
        delete [SELECT Id FROM CDC_Metrics__c WHERE Timestamp__c < :threshold LIMIT 10000];
        delete [SELECT Id FROM Integration_Log__c WHERE Timestamp__c < :threshold LIMIT 10000];
        delete [SELECT Id FROM Email_Metrics__c WHERE Timestamp__c < :threshold LIMIT 10000];
    }
}
