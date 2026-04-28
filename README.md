# Salesforce Observability Dashboard Framework

> Enterprise-grade, **non-AI** observability for Salesforce orgs.

Track limits, licenses, storage, async jobs, integrations, CDC usage, and email operations with deployable SFDX metadata + Apex collectors.

## Why this project?

Salesforce operations teams often fly blind until limits are breached or jobs fail. This framework gives you:

- **Historical trend tracking** with custom objects.
- **Operational visibility** across core platform health dimensions.
- **Dashboard-first design** for admins and architects.
- **Extensibility hooks** for alerting and integration patterns.

---

## What’s included

### Data model
Custom objects and metadata for:

- `Org_Limits__c`
- `License_Usage__c`
- `Async_Job_Monitor__c`
- `CDC_Metrics__c`
- `Integration_Log__c`
- `Email_Metrics__c`
- `Monitoring_Threshold__mdt`

### Apex service layer
- `LimitsService` (Queueable + callout to REST limits endpoint)
- `HealthService` (licenses + async jobs)
- `StorageCollectorService`
- `CDCMonitorService`
- `EmailMetricsService`
- `AlertEngine` (threshold email logic)
- `DataRetentionBatch` (30-day purge)
- `ObservabilitySchedulable` (hourly runner)
- `ObservabilityManager` (manual orchestration)

### Operations docs
- Deployment runbook
- Dashboard/report configuration guidance

---

## Quick start

### 1) Deploy
```bash
sf org login web --alias targetOrg
sf project deploy start --source-dir force-app/main/default --target-org targetOrg
```

### 2) Run tests
```bash
sf apex run test --tests ObservabilityFrameworkTest --target-org targetOrg --code-coverage --result-format human
```

### 3) Start hourly monitoring
Run in Execute Anonymous:
```apex
ObservabilitySchedulable.scheduleHourly();
```

### 4) Validate data ingestion
Run in Execute Anonymous:
```apex
ObservabilityManager.runAll();
```
Then review records in custom objects and wire reports/dashboards.

---

## Packaged analytics assets

This package now includes deployable **reports and dashboard metadata** under:

- `force-app/main/default/reports/OBS_Observability/`
- `force-app/main/default/dashboards/OBS_Observability/`
- `force-app/main/default/reportFolders/`
- `force-app/main/default/dashboardFolders/`

All these assets are prefixed with **OBS** for easy discovery in installed orgs.

## Target dashboards

1. **Org Health Overview**
2. **License Utilization**
3. **Async Job Health**
4. **Integration Health**
5. **Email Processing**

See `force-app/main/default/metadata/Dashboard_Recommendations.md` for suggested components.

---

## Publishing a project website (GitHub Pages)

This repository includes a ready-to-publish marketing/documentation site in `docs/`.

- In GitHub repo settings, open **Pages**.
- Set source to **Deploy from a branch**.
- Select your branch and `/docs` folder.
- Save — your site will publish automatically.

Customize `docs/index.md`, `docs/pricing.md`, and `docs/contact.md` with your company branding.

---

## Who this is for

- Salesforce Architects
- Platform Engineering teams
- Managed Services providers
- SI partners delivering proactive managed support

---

## Roadmap

- Threshold-driven multi-channel alerting (Slack, Teams, webhook)
- Packaged dashboard templates
- Advanced anomaly detection layer
- External observability sink integration (e.g., SIEM / APM)

---

## License

Use internally or adapt for client delivery.
