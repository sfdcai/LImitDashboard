# Salesforce Observability Deployment Guide

## Deploy
1. Authenticate org: `sf org login web --alias targetOrg`
2. Deploy metadata: `sf project deploy start --source-dir force-app/main/default --target-org targetOrg`
3. Run tests: `sf apex run test --tests ObservabilityFrameworkTest --target-org targetOrg --code-coverage --result-format human`
4. Schedule hourly job in Execute Anonymous:
   ```apex
   ObservabilitySchedulable.scheduleHourly();
   ```

## Manual execution
Run in Execute Anonymous:
```apex
ObservabilityManager.runAll();
```

## Optional retention schedule
```apex
Database.executeBatch(new DataRetentionBatch(), 200);
```
