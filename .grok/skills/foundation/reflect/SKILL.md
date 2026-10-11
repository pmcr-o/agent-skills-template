---
name: reflect
description: Record an earned constraint and one unexecuted next seed after an independent PMCR-O checker frame.
---

# PMCR-O Reflect

Wait for a completed checker.verdict frame with independent=true. If no eligible
frame is available within the scan cap, return WAIT and make no frame.

For an eligible verdict, copy the evidence boundary, record one earned
constraint, and emit exactly one messy next seed at meta, meta2, or meta3.
Leave that seed unexecuted. Reflect does not change PASS, LOOP, or HALT, does
not edit maker output, and does not certify work.

The next orchestrator must re-derive intent from the seed instead of jumping
directly to MAKE, CHECK, or REFLECT.
