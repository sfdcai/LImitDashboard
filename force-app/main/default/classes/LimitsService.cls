public with sharing class LimitsService implements Queueable, Database.AllowsCallouts, ObservabilityCollector {
    @TestVisible private static String apiVersion = 'v60.0';

    public void execute(QueueableContext context) {
        execute();
    }

    public void execute() {
        Datetime startedAt = Datetime.now();
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(URL.getOrgDomainUrl().toExternalForm() + '/services/data/' + apiVersion + '/limits');
            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
            req.setTimeout(10000);

            HttpResponse res = new Http().send(req);
            if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
                Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                Org_Limits__c record = new Org_Limits__c();
                record.Timestamp__c = Datetime.now();
                record.Api_Used__c = getNestedDecimal(payload, 'DailyApiRequests', 'Remaining') != null && getNestedDecimal(payload, 'DailyApiRequests', 'Max') != null
                    ? getNestedDecimal(payload, 'DailyApiRequests', 'Max') - getNestedDecimal(payload, 'DailyApiRequests', 'Remaining') : null;
                record.Api_Limit__c = getNestedDecimal(payload, 'DailyApiRequests', 'Max');
                record.Streaming_Used__c = getNestedDecimal(payload, 'DailyStreamingApiEvents', 'Remaining') != null && getNestedDecimal(payload, 'DailyStreamingApiEvents', 'Max') != null
                    ? getNestedDecimal(payload, 'DailyStreamingApiEvents', 'Max') - getNestedDecimal(payload, 'DailyStreamingApiEvents', 'Remaining') : null;
                record.Streaming_Limit__c = getNestedDecimal(payload, 'DailyStreamingApiEvents', 'Max');
                SObjectAccessDecision decision = Security.stripInaccessible(AccessType.CREATABLE, new List<SObject>{record});
                insert decision.getRecords();
                AlertEngine.evaluateApiUsage((Org_Limits__c) decision.getRecords()[0]);
            } else {
                logError('LimitsService', req.getEndpoint(), startedAt, 'Failed HTTP status ' + res.getStatusCode() + ': ' + res.getBody());
            }
        } catch (Exception ex) {
            logError('LimitsService', '/services/data/' + apiVersion + '/limits', startedAt, ex.getMessage());
        }
    }

    @TestVisible
    private static Decimal getNestedDecimal(Map<String, Object> payload, String parentKey, String childKey) {
        if (payload == null || !payload.containsKey(parentKey)) {
            return null;
        }
        Map<String, Object> parent = (Map<String, Object>) payload.get(parentKey);
        Object raw = parent != null ? parent.get(childKey) : null;
        return raw == null ? null : Decimal.valueOf(String.valueOf(raw));
    }

    private static void logError(String systemName, String endpoint, Datetime startedAt, String msg) {
        Integration_Log__c logEntry = new Integration_Log__c(
            System_Name__c = systemName,
            Endpoint__c = endpoint,
            Status__c = 'Failed',
            Response_Time_ms__c = Datetime.now().getTime() - startedAt.getTime(),
            Error_Message__c = msg,
            Timestamp__c = Datetime.now()
        );
        insert (Integration_Log__c) Security.stripInaccessible(AccessType.CREATABLE, new List<SObject>{logEntry}).getRecords()[0];
    }
}
