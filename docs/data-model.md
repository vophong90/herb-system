# Herb System Data Model

## Herbs
Core fields:
- vietnamese_name (required)
- latin_name (required)
- distribution
- used_part
- uses
- extra_json (future expansion)

Uniqueness:
- code (optional unique)
- otherwise unique(vietnamese_name, latin_name)

## Compounds workflow
Step 3 uses a staging model:
- compound_import_batches: one CSV upload per herb
- compound_import_items: each compound row from CSV; normalized via PubChem; flagged for review
Commit creates/updates:
- compounds (canonical; pubchem_id unique)
- herb_compounds (link table; unique(herb_id, compound_id))

## Docking jobs (Azure Batch)
- docking_jobs tracks job/task ids and storage refs for inputs/outputs.
