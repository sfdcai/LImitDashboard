public with sharing class AlertEngine {
    public static void evaluateApiUsage(Org_Limits__c latest) {
        if (latest == null || latest.Api_Limit__c == null || latest.Api_Limit__c == 0 || latest.Api_Used__c == null) {
            return;
        }
        Decimal pct = (latest.Api_Used__c / latest.Api_Limit__c) * 100;
        List<Monitoring_Threshold__mdt> configs = [
            SELECT DeveloperName, Threshold_Value__c, Alert_Email__c
            FROM Monitoring_Threshold__mdt
            WHERE DeveloperName = 'API_Usage'
            LIMIT 1
        ];
        if (configs.isEmpty()) {
            return;
        }
        Monitoring_Threshold__mdt cfg = configs[0];
        if (cfg.Threshold_Value__c != null && pct > cfg.Threshold_Value__c && String.isNotBlank(cfg.Alert_Email__c)) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] { cfg.Alert_Email__c });
            mail.setSubject('Salesforce API threshold breached');
            mail.setPlainTextBody('Current API usage is ' + pct.setScale(2) + '%, above threshold ' + cfg.Threshold_Value__c + '%.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}
