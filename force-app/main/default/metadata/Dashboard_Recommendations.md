# Dashboard and Report Configuration (OBS Package)

All packaged analytics assets are prefixed with **OBS** so they are clearly identifiable after installation.

## Deployed report folder
- `OBS_Observability`

## Deployed reports
- `OBS Org Limits Snapshot`
- `OBS License Utilization`
- `OBS Async Job Health`
- `OBS Integration Health`
- `OBS Email Processing`

## Deployed dashboard
- `OBS Org Observability Dashboard`

## Optional: Expand into separate dashboards
You can clone the packaged dashboard and split into dedicated dashboards:

1. **OBS Org Health Overview**
   - API Usage Gauge (%), Storage Usage Gauge (%), Streaming Usage trend.
2. **OBS License Utilization**
   - Used vs total licenses, remaining licenses by type.
3. **OBS Async Job Health**
   - Failed jobs in last 24h, jobs by status.
4. **OBS Integration Health**
   - Success vs failure rate, average response time.
5. **OBS Email Processing**
   - Avg attachments per case, processing time trends.
