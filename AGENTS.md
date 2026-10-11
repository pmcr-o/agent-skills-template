# PMCR-O agent contract

1. Read `.agents/project.json`, `.agents/catalog.json`, `.agents/routing.json`, and `AGENTS.md` before acting.
2. Treat `.pmcro` as canonical authority. `.agents` and host folders are projections only: `host -> .agents -> .pmcro`.
3. Projection is not activation. A host participates only after a host-specific bootstrap instantiates a bounded I under `.pmcro/protocol/host-activation.json`.
4. Every new root seed enters `ORCHESTRATE -> PLAN -> MAKE -> CHECK -> REFLECT` in that order. No same-cycle backward jump.
5. Every bounded phase may recursively use the same lifecycle inside its own phase domain. Inner cycles inherit and may narrow, but never widen, the parent authority ceiling.
6. Every new semantic frame carries `pmcro.i-context/v1`: entity, role, behavior, intent, lineage root, parent/object/addressed I references, authority ceiling, and meta depth. This is operational accountability, not a consciousness claim.
7. Preserve the immutable raw seed and source lineage. Refined interpretations do not rewrite the source intent.
8. Invoke only registered marketplace capabilities under applicable grants. Missing capability routes to the registered skill creator; unresolved authority HALTs.
9. Each I owns a local trail. Cross-I handoffs reference source trails/messages; I's do not co-edit one shared mutable trail.
10. Transport, model identity, subscriptions, economic preference, or competitive selection never grant authority.
11. Maker never self-certifies. Model/session output remains evidence until independent CHECK returns PASS, LOOP, or HALT.
12. REFLECT records earned constraints and an unexecuted next seed. That seed begins a new cycle through ORCHESTRATE.
