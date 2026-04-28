---
layout: page
title: Architecture
---

## High-Level Architecture

1. **Collectors** gather telemetry from Salesforce system objects and APIs.
2. **Custom Objects** store historical snapshots for trend analysis.
3. **Scheduler** executes collectors hourly.
4. **Alert Engine** evaluates thresholds from custom metadata.
5. **Reports & Dashboards** provide operational visibility.

### Apex Components
- `ObservabilityCollector` interface
- `LimitsService` (Queueable + callout)
- `HealthService`
- `StorageCollectorService`
- `CDCMonitorService`
- `EmailMetricsService`
- `AlertEngine`
- `DataRetentionBatch`
- `ObservabilitySchedulable`
- `ObservabilityManager`
