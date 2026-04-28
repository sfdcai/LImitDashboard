# Dashboard and Report Configuration

## Dashboard 1: Org Health Overview
- Report type: Org Limits custom object.
- Components: API Usage Gauge (`Api_Usage_Percentage__c`), Storage Gauge (`Storage_Usage_Percentage__c`), Streaming Used vs Limit.

## Dashboard 2: License Utilization
- Report type: License Usage.
- Components: stacked bar `Used_Licenses__c` vs `Total_Licenses__c`; table sorted by `Remaining_Licenses__c`.

## Dashboard 3: Async Job Health
- Report type: Async Job Monitor.
- Components: failed jobs in last 24h, donut by `Status__c`, table by `Apex_Class__c`.

## Dashboard 4: Integration Health
- Report type: Integration Log.
- Components: success/failure pie by `Status__c`; average `Response_Time_ms__c` line trend.

## Dashboard 5: Email Processing
- Report type: Email Metrics.
- Components: avg attachments per case, avg processing time trend, total attachment MB trend.
