# docs/README.md

# Supporting Documentation

The `docs/` folder contains supporting, historical, or exploratory Perch notes.

The authoritative product architecture lives in:

```text
design_bible/
```

Use `docs/` for:

- early notes
- supporting explanations
- historical context
- marketing-adjacent planning
- non-authoritative working material

Do not treat `docs/` as equal authority to the Design Bible.

If a `docs/` file conflicts with the Design Bible, the Design Bible wins unless an Architecture Decision Record explicitly says otherwise.

## Current supporting files

| File | Suggested status |
|---|---|
| `architecture_decisions.md` | Historical / superseded by `design_bible/decisions/` |
| `philosophy.md` | Historical / partially merged into `design_bible/governance/PERCH_PHILOSOPHY.md` |
| `master_roadmap.md` | Historical or empty placeholder |
| `product_intelligence.md` | Useful supporting note; candidate future ADR or reference doc |

## Recommended future action

Create an ADR or reference file for product intelligence / privacy-respecting analytics before implementing telemetry.
