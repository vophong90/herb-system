import Link from "next/link";

export default function HomePage() {
  return (
    <ul>
      <li><Link href="/admin/import-herbs">1. Import danh sách cây thuốc</Link></li>
      <li><Link href="/admin/herb/placeholder">2. Nhập & chỉnh sửa thông tin cây thuốc</Link></li>
      <li><Link href="/admin/compounds/import">3. Import & chuẩn hóa hợp chất</Link></li>
    </ul>
  );
}
