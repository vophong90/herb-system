-- 004_docking.sql
IF OBJECT_ID('dbo.docking_jobs', 'U') IS NULL
BEGIN
  CREATE TABLE dbo.docking_jobs (
    id uniqueidentifier NOT NULL CONSTRAINT DF_dj_id DEFAULT NEWID(),
    herb_id uniqueidentifier NULL,
    compound_id uniqueidentifier NULL,

    status nvarchar(30) NOT NULL CONSTRAINT DF_dj_status DEFAULT 'queued',
      -- queued|submitted|running|succeeded|failed|canceled

    batch_job_id nvarchar(100) NULL,
    batch_task_id nvarchar(100) NULL,

    params_json nvarchar(max) NULL,
    input_refs_json nvarchar(max) NULL,
    output_refs_json nvarchar(max) NULL,

    created_at datetime2 NOT NULL CONSTRAINT DF_dj_created DEFAULT SYSUTCDATETIME(),
    updated_at datetime2 NOT NULL CONSTRAINT DF_dj_updated DEFAULT SYSUTCDATETIME(),

    CONSTRAINT PK_dj PRIMARY KEY (id),
    CONSTRAINT FK_dj_herb FOREIGN KEY (herb_id) REFERENCES dbo.herbs(id),
    CONSTRAINT FK_dj_compound FOREIGN KEY (compound_id) REFERENCES dbo.compounds(id)
  );

  CREATE INDEX IX_dj_status ON dbo.docking_jobs(status);
  CREATE INDEX IX_dj_herb ON dbo.docking_jobs(herb_id);
  CREATE INDEX IX_dj_compound ON dbo.docking_jobs(compound_id);
END
GO
