# PMCR-O message envelope

Each frame is append-only JSONL and carries only its increment.

Required fields: frame_id, trail_id, cycle_id, seq, role, kind, parent_id,
prev_hash, hash, status, payload.

Owned kinds:

- orchestrator: orchestrator.route
- planner: planner.plan
- maker: maker.result
- checker: checker.verdict
- reflector: reflector.reflect

A role may emit only its own kind. The maker never emits a verdict. The
checker reads plan/maker artifacts without editing them and is the only role
that can emit PASS, LOOP, or HALT. Reflect records one earned constraint and
one unexecuted next seed. Catalog discovery is read-only and is not a verdict.

A later frame may supersede an earlier claim, but it never erases the earlier
frame. A child scope inherits grants but cannot widen them.
