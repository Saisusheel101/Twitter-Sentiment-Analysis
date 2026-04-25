# Dataset Format Guide

This project expects the tweet input file as CSV with at least two fields:

1. `id` (tweet identifier)
2. `text` (tweet content)

## Required schema

```text
id,text
12345,This policy is good
12346,This is causing problems
```

## Important formatting notes

- Keep one tweet per row.
- Ensure `id` and `text` are not empty.
- Use UTF-8 encoding.
- If tweet text contains commas, ensure the CSV is properly quoted.

## Common issues

- **Bad delimiter**: if file is tab-separated, convert to comma-separated.
- **Missing text**: rows with null text are filtered out by the Pig script.
- **Unexpected columns**: extra columns are ignored, but first two must be `id,text`.
