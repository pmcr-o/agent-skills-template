from pathlib import Path

root = Path(__file__).parents[1]
required = ["SKILL.md", "agents", "scripts", "references", "assets", "tests"]
missing = [name for name in required if not (root / name).exists()]
if missing:
    raise SystemExit("missing: " + ", ".join(missing))
print("PASS: dotagents-skill-creator structure")
