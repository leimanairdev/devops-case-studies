cat > incident-response-postmortem/README.md << 'EOF'
# Incident Response: Latency & 504 Errors

This case study documents an incident involving intermittent latency spikes and 504 Gateway Timeout errors under peak traffic. It demonstrates structured incident analysis, clear communication, and actionable remediation planning.

## Summary
- API response time increased from ~200ms to ~3000ms
- ~5% of requests returned 504 errors
- Duration: ~45 minutes during peak traffic

## What’s Included
- `postmortem.md`: incident timeline, analysis approach, and remediation plan
- `monitoring.md`: dashboard and alerting improvements

## Goals
- Provide a repeatable postmortem format
- Highlight monitoring gaps and how to close them
- Prioritize fixes that reduce MTTR and prevent recurrence
EOF
