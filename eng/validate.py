from pathlib import Path
import hashlib, json, sys

R = Path(__file__).resolve().parents[1]
FAIL: list[str] = []


def load(rel: str) -> dict:
    value = json.loads((R / rel).read_text(encoding="utf-8-sig"))
    if not isinstance(value, dict):
        raise ValueError(f"expected object: {rel}")
    return value


def check(condition: bool, message: str) -> None:
    if not condition:
        FAIL.append(message)


shape = load(".pmcro/protocol/repository-shape.json")
check(shape.get("schema") == "pmcro.repository-shape/v1", "repository shape schema")
for rel in list(shape.get("requiredTopLevel", [])) + list(shape.get("pmcroAdditions", [])):
    check((R / rel).exists(), f"missing repository surface {rel}")
for rel in shape.get("githubSurfaces", []):
    check((R / ".github" / rel).exists(), f"missing github surface {rel}")

catalog = load(".pmcro/control/catalog.json")
for row in catalog.get("skills", []):
    base = R / ".pmcro/plugins" / row["plugin"] / "skills" / row["id"]
    check((base / "SKILL.md").is_file(), f"{row['plugin']}/{row['id']} SKILL.md")
    for part in ("agents", "scripts", "references", "assets", "tests"):
        path = base / part
        check(path.is_dir() and any(x.is_file() for x in path.rglob("*")), f"{row['plugin']}/{row['id']} {part}")

activation = load(".pmcro/protocol/host-activation.json")
check(activation.get("rootSeedPhase") == "ORCHESTRATE", "host activation ORCHESTRATE-first")
check(activation.get("activation", {}).get("projectionAloneIsActivation") is False, "projection is not activation")
check(activation.get("activation", {}).get("hostSpecificBootstrapRequired") is True, "host bootstrap required")
check(activation.get("activation", {}).get("bootstrapMustRunContinuously") is True, "host bootstrap continuous")
check(activation.get("activation", {}).get("bootstrapMayRequireHumanPhaseInvocation") is False, "no human phase gate")
check(activation.get("authorityCeiling", {}).get("rule") == "inherit-or-narrow-never-widen", "authority ceiling law")
check(activation.get("checker", {}).get("independent") is True, "independent checker")
check(activation.get("checker", {}).get("makerMaySelfApprove") is False, "maker cannot self-approve")
check(activation.get("executionCadence") == {
    "questionGate": False,
    "humanPhaseGate": False,
    "autonomousUntilBoundary": True,
    "reflectedNextSeedAutoAdmit": True,
}, "continuous execution cadence")

required_host_files = ("catalog.json", "project.json", "routing.json", "grants.json", "lifecycle.json")
for host in activation.get("requiredProjectedHosts", []):
    root = R / host
    check(root.is_dir(), f"missing host projection {host}")
    for name in required_host_files:
        check((root / name).is_file(), f"{host} missing {name}")
    bootstrap = root / "ACTIVATE.md"
    check(bootstrap.is_file(), f"{host} missing ACTIVATE.md")
    if bootstrap.is_file():
        text = bootstrap.read_text(encoding="utf-8-sig")
        for phrase in (
            "I AM the Orchestrator.",
            "I AM the Planner.",
            "I AM the Maker.",
            "I AM the Checker.",
            "I AM the Reflector.",
            "Projection is not activation.",
            "Never ask the human to invoke the next phase",
            "resume from durable queue/trail state",
        ):
            check(phrase in text, f"{host} activation missing phrase: {phrase}")
        check(f"{host} -> .agents -> .pmcro" in text, f"{host} activation authority chain")

icontext = load(".pmcro/protocol/i-context.schema.json")
check(icontext.get("properties", {}).get("schema", {}).get("const") == "pmcro.i-context/v1", "I-context schema")
check(icontext.get("properties", {}).get("consciousnessClaim", {}).get("const") is False, "I-context consciousness law")
check("addressedIRef" in icontext.get("required", []), "I-context addressed I")

lockp = R / ".pmcro/upstream-lock.json"
if lockp.is_file():
    lock = json.loads(lockp.read_text(encoding="utf-8-sig"))
    mirror = R / lock.get("mirror", ".pmcro/upstream/dotnet-skills")
    if not mirror.is_dir():
        FAIL.append("missing pinned upstream mirror")
    else:
        h = hashlib.sha256()
        count = 0
        for path in sorted(x for x in mirror.rglob("*") if x.is_file() and ".git" not in x.parts):
            rel = path.relative_to(mirror).as_posix()
            digest = hashlib.sha256(path.read_bytes()).hexdigest()
            h.update(rel.encode())
            h.update(b"\0")
            h.update(digest.encode())
            h.update(b"\n")
            count += 1
        check(h.hexdigest() == lock.get("treeDigest") and count == lock.get("files"), "pinned upstream mirror digest/files mismatch")

print("REPOSITORY-STRUCTURE-PASS" if not FAIL else "REPOSITORY-STRUCTURE-FAIL")
for item in FAIL:
    print("FAIL", item)
sys.exit(1 if FAIL else 0)
