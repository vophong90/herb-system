-- 003_compounds.sql

-- Import batches
IF OBJECT_ID('dbo.compound_import_batches', 'U') IS NULL
BEGIN
  CREATE TABLE dbo.compound_import_batches (
    id uniqueidentifier NOT NULL CONSTRAINT DF_cib_id DEFAULT NEWID(),
    herb_id uniqueidentifier NOT NULL,
    status nvarchar(30) NOT NULL CONSTRAINT DF_cib_status DEFAULT 'draft', -- draft|normalized|committed
    uploaded_filename nvarchar(255) NULL,
    created_at datetime2 NOT NULL CONSTRAINT DF_cib_created DEFAULT SYSUTCDATETIME(),
    updated_at datetime2 NOT NULL CONSTRAINT DF_cib_updated DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_cib PRIMARY KEY (id),
    CONSTRAINT FK_cib_herb FOREIGN KEY (herb_id) REFERENCES dbo.herbs(id) ON DELETE CASCADE
  );

  CREATE INDEX IX_cib_herb ON dbo.compound_import_batches(herb_id);
END
GO

-- Import items (each row in CSV)
IF OBJECT_ID('dbo.compound_import_items', 'U') IS NULL
BEGIN
  CREATE TABLE dbo.compound_import_items (
    id uniqueidentifier NOT NULL CONSTRAINT DF_cii_id DEFAULT NEWID(),
    batch_id uniqueidentifier NOT NULL,
    input_name nvarchar(255) NOT NULL,
    normalize_status nvarchar(30) NOT NULL CONSTRAINT DF_cii_status DEFAULT 'pending',
      -- pending|matched|ambiguous|not_found|needs_review|confirmed
    suggested_pubchem_id int NULL,
    suggested_smiles nvarchar(2000) NULL,
    confidence_score float NULL,
    resolved_pubchem_id int NULL,
    resolved_smiles nvarchar(2000) NULL,
    resolver_note nvarchar(500) NULL,
    created_at datetime2 NOT NULL CONSTRAINT DF_cii_created DEFAULT SYSUTCDATETIME(),
    updated_at datetime2 NOT NULL CONSTRAINT DF_cii_updated DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_cii PRIMARY KEY (id),
    CONSTRAINT FK_cii_batch FOREIGN KEY (batch_id) REFERENCES dbo.compound_import_batches(id) ON DELETE CASCADE
  );

  CREATE INDEX IX_cii_batch ON dbo.compound_import_items(batch_id);
  CREATE INDEX IX_cii_input_name ON dbo.compound_import_items(input_name);
END
GO

-- Canonical compounds (confirmed)
IF OBJECT_ID('dbo.compounds', 'U') IS NULL
BEGIN
  CREATE TABLE dbo.compounds (
    id uniqueidentifier NOT NULL CONSTRAINT DF_compounds_id DEFAULT NEWID(),
    pubchem_id int NOT NULL,
    canonical_name nvarchar(255) NULL,
    smiles nvarchar(2000) NULL,
    inchi nvarchar(max) NULL,
    inchikey nvarchar(100) NULL,
    source_json nvarchar(max) NULL,
    created_at datetime2 NOT NULL CONSTRAINT DF_compounds_created DEFAULT SYSUTCDATETIME(),
    updated_at datetime2 NOT NULL CONSTRAINT DF_compounds_updated DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_compounds PRIMARY KEY (id)
  );

  CREATE UNIQUE INDEX UX_compounds_pubchem ON dbo.compounds(pubchem_id);
END
GO

-- Link herb <-> compound
IF OBJECT_ID('dbo.herb_compounds', 'U') IS NULL
BEGIN
  CREATE TABLE dbo.herb_compounds (
    id uniqueidentifier NOT NULL CONSTRAINT DF_hc_id DEFAULT NEWID(),
    herb_id uniqueidentifier NOT NULL,
    compound_id uniqueidentifier NOT NULL,
    evidence nvarchar(500) NULL,
    created_at datetime2 NOT NULL CONSTRAINT DF_hc_created DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_hc PRIMARY KEY (id),
    CONSTRAINT FK_hc_herb FOREIGN KEY (herb_id) REFERENCES dbo.herbs(id) ON DELETE CASCADE,
    CONSTRAINT FK_hc_compound FOREIGN KEY (compound_id) REFERENCES dbo.compounds(id) ON DELETE CASCADE
  );

  CREATE UNIQUE INDEX UX_hc_unique ON dbo.herb_compounds(herb_id, compound_id);
  CREATE INDEX IX_hc_herb ON dbo.herb_compounds(herb_id);
END
GO
