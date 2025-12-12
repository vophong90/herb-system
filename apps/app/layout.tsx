export default function RootLayout({
  children
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="vi">
      <body style={{ fontFamily: "sans-serif", padding: 24 }}>
        <h1>🌿 Herb System Admin</h1>
        <hr />
        {children}
      </body>
    </html>
  );
}
