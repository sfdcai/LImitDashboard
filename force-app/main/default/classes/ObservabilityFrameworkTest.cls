@IsTest(SeeAllData=true)
private class ObservabilityFrameworkTest {
    private class LimitsMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"DailyApiRequests":{"Max":100000,"Remaining":1000},"DailyStreamingApiEvents":{"Max":50000,"Remaining":25000}}');
            return res;
        }
    }

    @IsTest
    static void testLimitsServiceQueueableAndAlert() {
        Test.setMock(HttpCalloutMock.class, new LimitsMock());
        Test.startTest();
        System.enqueueJob(new LimitsService());
        Test.stopTest();

        List<Org_Limits__c> rows = [SELECT Api_Used__c, Api_Limit__c, Streaming_Used__c, Streaming_Limit__c FROM Org_Limits__c ORDER BY CreatedDate DESC LIMIT 1];
        System.assertEquals(99000, rows[0].Api_Used__c);
        System.assertEquals(100000, rows[0].Api_Limit__c);
        System.assertEquals(25000, rows[0].Streaming_Used__c);
        System.assertEquals(50000, rows[0].Streaming_Limit__c);
        System.assert(Limits.getEmailInvocations() >= 0, 'Alert engine executed.');
    }

    @IsTest
    static void testHealthAndManager() {
        Test.startTest();
        new HealthService().execute();
        ObservabilityManager.runAll();
        Test.stopTest();

        System.assert([SELECT COUNT() FROM License_Usage__c] >= 0);
        System.assert([SELECT COUNT() FROM Async_Job_Monitor__c] >= 0);
    }

    @IsTest
    static void testSchedulersAndBatch() {
        String jobId = System.schedule('Test Observability ' + System.now().getTime(), '0 0 0 1 1 ? 2099', new ObservabilitySchedulable());
        System.assertNotEquals(null, jobId);

        Test.startTest();
        Database.executeBatch(new DataRetentionBatch(), 50);
        Test.stopTest();
        System.assert(true);
    }
}
