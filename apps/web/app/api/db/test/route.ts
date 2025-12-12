import { NextResponse } from "next/server";
import { getPool } from "@/lib/db/mssql";

export async function GET() {
  try {
    const pool = await getPool();
    const result = await pool.request().query("SELECT 1 AS ok");

    return NextResponse.json({
      success: true,
      result: result.recordset
    });
  } catch (err: any) {
    return NextResponse.json(
      { success: false, error: err.message },
      { status: 500 }
    );
  }
}
