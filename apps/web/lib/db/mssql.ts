import sql from "mssql";

export async function getPool() {
  const conn = process.env.AZURE_SQL_CONNECTION_STRING;
  if (!conn) throw new Error("Missing AZURE_SQL_CONNECTION_STRING");

  return sql.connect(conn);
}
