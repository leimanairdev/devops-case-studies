# Proposed Monitoring Dashboard + Alerts

## Dashboard Panels (minimum useful set)
### Service Golden Signals
- Traffic: requests per second, request concurrency (in-flight)
- Errors: 5xx rate, 504 rate at load balancer, error rate by endpoint
- Latency: p50/p95/p99, heatmap, top N slow endpoints
- Saturation: CPU, memory, pod restarts, container throttling

### Dependency Health
- Database:
  - Active connections vs max connections
  - Connection pool utilization / wait time
  - Slow query rate and p95 query duration
  - Lock wait time / deadlocks (if available)
- Load balancer:
  - Target response time
  - 4xx/5xx by target group
  - Surge queue / spillover (if applicable)

### Capacity + Cost (optional but nice)
- Node utilization, pod density, pending pods
- Autoscaler activity (scale up/down events)

## Alerts (examples)
### Paging Alerts (high urgency)
1. Error budget burn:
   - Fast burn: 5xx rate > 2% for 5 minutes AND RPS above baseline
   - Slow burn: 5xx rate > 1% for 30 minutes
2. Latency + errors:
   - p95 > 1000ms for 5 minutes AND 5xx rate > 1%
3. Database connection saturation:
   - Active connections > 80% of max for 5 minutes OR pool wait time > threshold

### Ticket / Slack Alerts (lower urgency)
- Slow query rate increasing week-over-week
- CPU throttling above threshold
- Increased pod restarts or OOM kills (Out Of Memory kills)

## Runbook Linkage
Each paging alert should link to a short runbook section:
- “Check traces for top slow spans”
- “Check DB connection saturation + pool wait”
- “Scale API replicas and validate autoscaler signals”
- “Validate timeouts alignment”
