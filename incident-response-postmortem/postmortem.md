# Incident Post-Mortem: Intermittent Latency Spikes + 504s

## Summary
On 2025-12-31, the API experienced a significant increase in response time (baseline ~200ms to peak ~3000ms at p95/p99) and an elevated error rate (~5% of requests returned 504 Gateway Timeout). The issue lasted 45 minutes during peak traffic.

## Impact
- Duration: 45 minutes
- Customer impact: Slower responses for most users; ~5% request failures (504)
- Systems affected: API service and upstream dependencies (timeouts observed at the edge / load balancer)
- Severity: SEV-2 (partial outage / major degradation)

## Detection
- Detected via monitoring alert on latency + 5xx errors
- Time to detect: ~7 minutes (monitoring gaps identified below)

## Timeline (UTC)
- 15:00 — Peak traffic begins; p95 latency ~200–300ms.
- 15:05 — Latency starts spiking intermittently.
- 15:07 — 504 errors begin appearing.
- 15:12 — On-call receives and acknowledges alert.
- 15:15 — Initial triage confirms elevated latency and 504s at the load balancer.
- 15:25 — Mitigation attempt: scale API horizontally; partial improvement.
- 15:35 — Tracing indicates most time spent waiting on database calls / connection acquisition.
- 15:40 — Apply mitigation: adjust connection pooling / reduce contention, restart pods to reset pools.
- 15:45 — Error rate drops; latency begins trending down.
- 15:50 — Service returns to normal; close incident.
- 15:55 — Post-incident review started; remediation items drafted.

## Root Cause (Hypothetical)
During peak traffic, database connection usage and connection-pool contention increased significantly. Requests spent excessive time waiting for database connections and executing slower queries under load. This pushed response times beyond configured upstream timeouts, resulting in 504 Gateway Timeout errors.

### Contributing Factors
- Autoscaling was primarily CPU-based and did not account for concurrency / in-flight requests.
- No direct alerting on database connection saturation or connection-pool wait time.
- Timeout settings between load balancer ↔ API ↔ database were not aligned for peak conditions.

## Root Cause Analysis Approach
We followed a structured “metrics → logs → traces → dependencies” process:
1. Metrics: validated p95/p99 latency, 5xx rate, traffic levels, CPU/memory, and saturation indicators.
2. Logs: correlated slow requests and timeout events; identified endpoints most affected.
3. Traces: isolated the dominant slow spans to database calls and connection acquisition.
4. Dependencies: checked database health (connections, slow queries, lock waits).

## What Went Well
- On-call quickly confirmed user impact and narrowed the issue using traces.
- Scaling the API reduced some pressure immediately.
- Incident communication remained clear and continuous.

## What Didn’t Go Well
- Alerting was delayed; it did not page at the earliest symptom onset.
- DB connection pressure was not visible on primary dashboards.
- Runbook coverage for “latency spikes + 504s” was incomplete.

## Monitoring / Alerting Gaps
- Missing alert: database connection utilization (used vs max).
- Missing alert: connection pool wait time / acquire latency.
- Missing alert: slow query rate and lock wait time.
- Latency alert was single-signal instead of multi-signal (latency + errors + traffic).

## Remediation Items
### P0 (immediate)
- Add alerts for DB connection saturation, pool wait time, and slow query rate.
- Add multi-signal paging alerts (latency + 5xx + traffic).
- Align upstream timeouts with service-level objectives (SLOs).

### P1 (near-term)
- Autoscale using concurrency signals (in-flight requests, queue depth), not only CPU.
- Add load testing for peak profile and validate pool sizing.
- Update runbooks with a decision tree for latency + 504 troubleshooting.

### P2 (longer-term)
- Optimize identified slow queries and add indexes where appropriate.
- Add caching for hot endpoints and reduce unnecessary DB calls.
- Consider read replicas / scaling strategy based on growth trends.

## Preventive Measures
- Service-level objective (SLO) based alerting (error budget burn alerts: fast + slow).
- Regular performance regression tests in staging.
- Capacity planning tied to traffic forecasts and load tests.

## Assumptions
- 504 errors originated at the load balancer due to upstream timeouts.
- Primary bottleneck was database connection contention and query latency under load.
- Distributed tracing was available across the API and database spans.
