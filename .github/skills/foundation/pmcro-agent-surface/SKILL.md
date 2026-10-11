---
name: pmcro-agent-surface
description: Expose a project component, workflow, MCP endpoint, or skill as a typed PMCR-O surface.
---

# PMCR-O Agent Surface

Use one stable typed boundary for a capability. Declare identity, version,
scope, dependencies, inputs, outputs, grant, limits, lifecycle, entrypoint,
and evidence tier.

Choose exactly one mode: inspect, simulate, replay, execute, or check.
Filesystem discovery is read-only by default. Simulation returns predicted
transitions with simulation=true and verified=false. Execution records actual
commands or MAF/MCP calls and their evidence. Only a fresh checker may issue
PASS, LOOP, or HALT.

An independently addressable surface is not automatically an independent
checker. independentSurface describes identity; independentChecker describes
fresh verdict authority.
