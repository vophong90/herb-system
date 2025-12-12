# API Contract (Draft)

## Step 1 - Import herbs CSV
POST /api/herbs/import
- CSV columns: vietnamese_name, latin_name
- Output: { inserted, updated, errors[] }

GET /api/herbs
- Query: q=...
- Output: list herbs

## Step 2 - Edit herb details
GET /api/herbs/:id
PATCH /api/herbs/:id
- Body: distribution, used_part, uses, extra_json

## Step 3 - Import compounds CSV + Normalize + Commit
POST /api/compounds/import
- Body: herb_id + CSV (compound common names)
- Output: batch_id + preview items

POST /api/compounds/normalize
- Body: batch_id
- Output: items with normalize_status + suggested_pubchem_id/smiles

POST /api/compounds/commit
- Body: batch_id + final mapping per item (pubchem_id/smiles)
- Output: committed counts

## Docking (Azure Batch)
POST /api/docking/submit
GET /api/docking/status/:id
GET /api/docking/results/:id
