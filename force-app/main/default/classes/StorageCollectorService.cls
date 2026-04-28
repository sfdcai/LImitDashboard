public with sharing class StorageCollectorService implements ObservabilityCollector {
    public void execute() {
        Organization orgInfo = [
            SELECT Name, StorageUsed, FileStorageUsed
            FROM Organization
            LIMIT 1
            WITH USER_MODE
        ];
        Org_Limits__c row = new Org_Limits__c(
            Timestamp__c = Datetime.now(),
            Data_Storage_Used_MB__c = orgInfo.StorageUsed,
            File_Storage_Used_MB__c = orgInfo.FileStorageUsed,
            Data_Storage_Limit_MB__c = 0,
            File_Storage_Limit_MB__c = 0
        );
        insert (Org_Limits__c) Security.stripInaccessible(AccessType.CREATABLE, new List<SObject>{row}).getRecords()[0];
    }
}
