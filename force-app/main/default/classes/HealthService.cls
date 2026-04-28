public with sharing class HealthService implements ObservabilityCollector {
    public void execute() {
        collectLicenses();
        collectAsyncJobs();
    }

    public static void collectLicenses() {
        List<License_Usage__c> licenseRows = new List<License_Usage__c>();
        for (UserLicense ul : [
            SELECT Name, TotalLicenses, UsedLicenses
            FROM UserLicense
            WITH USER_MODE
        ]) {
            licenseRows.add(new License_Usage__c(
                License_Name__c = ul.Name,
                Total_Licenses__c = ul.TotalLicenses,
                Used_Licenses__c = ul.UsedLicenses
            ));
        }
        if (!licenseRows.isEmpty()) {
            SObjectAccessDecision decision = Security.stripInaccessible(AccessType.CREATABLE, licenseRows);
            insert decision.getRecords();
        }
    }

    public static void collectAsyncJobs() {
        List<Async_Job_Monitor__c> monitorRows = new List<Async_Job_Monitor__c>();
        for (AsyncApexJob job : [
            SELECT Id, JobType, Status, NumberOfErrors, JobItemsProcessed, CreatedDate, ApexClass.Name
            FROM AsyncApexJob
            WHERE CreatedDate = LAST_N_DAYS:1
            AND Status IN ('Holding', 'Queued', 'Preparing', 'Processing', 'Failed')
            ORDER BY CreatedDate DESC
            LIMIT 5000
            WITH USER_MODE
        ]) {
            monitorRows.add(new Async_Job_Monitor__c(
                Job_Id__c = (String) job.Id,
                Job_Type__c = job.JobType,
                Status__c = job.Status,
                Apex_Class__c = job.ApexClass != null ? job.ApexClass.Name : null,
                Records_Processed__c = job.JobItemsProcessed,
                Errors__c = job.NumberOfErrors,
                Created_Date__c = job.CreatedDate
            ));
        }
        if (!monitorRows.isEmpty()) {
            SObjectAccessDecision decision = Security.stripInaccessible(AccessType.CREATABLE, monitorRows);
            insert decision.getRecords();
        }
    }
}
