-- 002_herbs.sql
IF OBJECT_ID('dbo.herbs', 'U') IS NULL
BEGIN
  CREATE TABLE dbo.herbs (
    id uniqueidentifier NOT NULL CONSTRAINT DF_herbs_id DEFAULT NEWID(),
    code nvarchar(50) NULL,
    vietnamese_name nvarchar(255) NOT NULL,
    latin_name nvarchar(255) NOT NULL,
    distribution nvarchar(500) NULL,
    used_part nvarchar(255) NULL,
    uses nvarchar(max) NULL,
    extra_json nvarchar(max) NULL, -- store JSON as text (Azure SQL supports JSON functions on NVARCHAR)
    created_at datetime2 NOT NULL CONSTRAINT DF_herbs_created DEFAULT SYSUTCDATETIME(),
    updated_at datetime2 NOT NULL CONSTRAINT DF_herbs_updated DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_herbs PRIMARY KEY (id)
  );

  -- stable unique: prefer CODE if provided; otherwise unique by (vietnamese_name, latin_name)
  CREATE UNIQUE INDEX UX_herbs_code_notnull
    ON dbo.herbs(code)
    WHERE code IS NOT NULL;

  CREATE UNIQUE INDEX UX_herbs_name_pair
    ON dbo.herbs(vietnamese_name, latin_name);

  CREATE INDEX IX_herbs_vn ON dbo.herbs(vietnamese_name);
  CREATE INDEX IX_herbs_latin ON dbo.herbs(latin_name);
END
GO
