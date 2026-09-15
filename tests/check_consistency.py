"""Static checks only: this does not execute T-SQL or compile LaTeX."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
sql = (ROOT / "database/schema.sql").read_text(encoding="utf-8")
dictionary = (ROOT / "chuong3/3.4_tu_dien_du_lieu.tex").read_text(encoding="utf-8")
tables = {}
for name, body in re.findall(r"CREATE TABLE (\[?\w+\]?) \((.*?)\n\);", sql, re.S):
    name = name.strip("[]")
    columns = re.findall(r"^\s+(\w+)\s+(?:N?VARCHAR\([^)]+\)|INT|DATETIME|DECIMAL\([^)]+\))", body, re.M)
    tables[name] = columns
    for column in columns:
        assert re.search(r"\b" + column + r"\s*&", dictionary), (name, column, "missing dictionary entry")
    assert "PRIMARY KEY CLUSTERED" in body, name
assert len(tables) == 10, tables.keys()

for table, body in re.findall(r"CREATE TABLE (\[?\w+\]?) \((.*?)\n\);", sql, re.S):
    for column, target, key in re.findall(r"FOREIGN KEY \((\w+)\)\s+REFERENCES (\[?\w+\]?)\((\w+)\)", body):
        assert target.strip("[]") in tables, target
        assert key in tables[target.strip("[]")], (target, key)
        index = r"ON " + re.escape(table) + r"\(" + column + r"(?:,|\))"
        unique_prefix = r"UNIQUE \(" + column + r"(?:,|\))"
        assert re.search(index, sql) or re.search(unique_prefix, body), (table, column, "FK lacks leading index")

assert "SuiTxDigest VARCHAR(100) UNIQUE" not in sql
for table, column in [("CUSTOMER", "WalletAddress"), ("CREDIT_TRANSACTION", "SuiTxDigest")]:
    assert f"ON {table}({column}) WHERE {column} IS NOT NULL" in sql
assert "EndDate DATETIME NULL" in sql
assert "UNIQUE (CustomerID, MerchantID)" in sql
assert "ManagerID VARCHAR(36) NULL" in sql

sources = list(ROOT.glob("*.tex")) + list(ROOT.glob("chuong*/*.tex"))
for source in sources:
    text = source.read_text(encoding="utf-8")
    uncommented = "\n".join(re.split(r"(?<!\\)%", line)[0] for line in text.splitlines())
    assert not re.search(r"MySQL|PostgreSQL|InnoDB|AUTO\\_INCREMENT", uncommented), source
    for command, target in re.findall(r"\\(input|include|lstinputlisting)(?:\[[^\]]*\])?\{([^}]+)\}", uncommented):
        path = ROOT / target
        if command != "lstinputlisting":
            path = path if path.suffix == ".tex" else Path(str(path) + ".tex")
        assert path.exists(), (source, path)
    stack = []
    for kind, env in re.findall(r"\\(begin|end)\{([^}]+)\}", uncommented):
        if kind == "begin":
            stack.append(env)
        else:
            assert stack and stack.pop() == env, (source, env)
    assert not stack, (source, stack)

ddl_section = (ROOT / "chuong4/4.4_ma_lenh_tao_bang.tex").read_text(encoding="utf-8")
assert r"\lstinputlisting[style=sqlstyle]{database/schema.sql}" in ddl_section
diagram = (ROOT / "chuong3/3.3_so_do_logic.tex").read_text(encoding="utf-8")
assert "ManagerID" in diagram and r"\textbf{ROLE}" in diagram
print(f"PASS: {len(tables)} tables, dictionary columns, FK/index references, nullable unique indexes, and {len(sources)} TeX sources.")
print("Not executed here: SQL Server constraint tests; LaTeX compilation and visual review.")
