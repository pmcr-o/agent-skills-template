---
name: pmcro-generic-crud
description: Apply a bounded CRUD lifecycle to skills, plugins, agent surfaces, catalogs, memory, trails, and domain resources.
---

# PMCR-O Generic CRUD

Use CRUD as the reusable lifecycle lens for governed resources:

- create stages a candidate and never publishes automatically;
- read returns an authorized progressive-disclosure projection;
- update creates a version linked to its predecessor and checks the expected version;
- delete revokes, tombstones, or archives by default; physical deletion needs
  an explicit policy and a fresh checker.

Specialized actions such as check, compile, send, calculate, and promote keep
their own typed contracts. CRUD organizes lifecycle state; it does not erase
domain semantics.

For .NET Clean Architecture, an EntityBase can assign Guid.NewGuid() for new
entities. A constrained IGenericRepository<TEntity> can provide CRUD access
for TEntity : EntityBase, and a UnitOfWork can expose Repository<TEntity>().
The in-memory example is a contract simulation until a real infrastructure
adapter is checked.
