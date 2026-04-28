public with sharing class EmailMetricsService implements ObservabilityCollector {
    public void execute() {
        List<AggregateResult> metrics = [
            SELECT ParentId caseId, COUNT(Id) emailCount, SUM(TextBodyLength) sizeEstimate
            FROM EmailMessage
            WHERE ParentId != null
            AND CreatedDate = LAST_N_DAYS:1
            GROUP BY ParentId
            LIMIT 2000
            WITH USER_MODE
        ];
        List<Email_Metrics__c> rows = new List<Email_Metrics__c>();
        for (AggregateResult ar : metrics) {
            Decimal sizeMb = ar.get('sizeEstimate') == null ? 0 : Decimal.valueOf(String.valueOf(ar.get('sizeEstimate'))) / (1024 * 1024);
            rows.add(new Email_Metrics__c(
                Case_Id__c = (Id) ar.get('caseId'),
                Email_Count__c = Decimal.valueOf(String.valueOf(ar.get('emailCount'))),
                Attachment_Count__c = 0,
                Total_Attachment_Size_MB__c = sizeMb,
                Processing_Time_ms__c = 0,
                Timestamp__c = Datetime.now()
            ));
        }
        if (!rows.isEmpty()) {
            insert Security.stripInaccessible(AccessType.CREATABLE, rows).getRecords();
        }
    }
}
