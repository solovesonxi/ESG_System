import json
import os
import sys

from sqlalchemy import create_engine, MetaData, select, literal, text
from sqlalchemy.schema import CreateTable

# 从项目配置读取默认数据库 URL（Postgres 配置）
try:
    from backend.core.dependencies import SQLALCHEMY_DATABASE_URL
except Exception:
    SQLALCHEMY_DATABASE_URL = None

DEFAULT_URL = os.getenv("DATABASE_URL") or SQLALCHEMY_DATABASE_URL
DEFAULT_OUT = "./static/init_db.sql"
DEFAULT_TABLES = None


def quote_name(preparer, name):
    return preparer.quote(name)


def table_qualified_name(preparer, table):
    if table.schema:
        return f"{quote_name(preparer, table.schema)}.{quote_name(preparer, table.name)}"
    return quote_name(preparer, table.name)


def dump_db(url, out_path, tables=None):
    engine = create_engine(url, pool_pre_ping=True,
        connect_args={"options": "-c client_encoding=utf8"} if "postgres" in url else {}, )
    metadata = MetaData()
    metadata.reflect(bind=engine, only=tables)
    preparer = engine.dialect.identifier_preparer

    with engine.connect() as conn, open(out_path, "w", encoding="utf-8") as f:
        try:
            if engine.dialect.name == "postgresql":
                search_path = conn.execute(text("SHOW search_path")).scalar()
                f.write(f"-- search_path: {search_path}\n\n")
        except Exception:
            pass

        for table in metadata.sorted_tables:
            ddl = str(CreateTable(table).compile(dialect=engine.dialect))
            f.write(ddl.rstrip() + ";\n\n")

            sel = select(table)
            rows = conn.execute(sel).fetchall()
            if not rows:
                continue

            col_names = [quote_name(preparer, c.name) for c in table.columns if c.name.lower() != "id"]
            qualified = table_qualified_name(preparer, table)

            for row in rows:
                vals = []
                for i, v in enumerate(row):
                    # 跳过id列（假设id是第一个列）
                    if table.columns[i].name.lower() == "id":
                        continue

                    if v is None:
                        vals.append("NULL")
                        continue

                    # 优先尝试用SQLAlchemy literal
                    try:
                        lit = literal(v)
                        compiled = lit.compile(dialect=engine.dialect, compile_kwargs={"literal_binds": True})
                        vals.append(str(compiled))
                        continue
                    except Exception:
                        pass

                    # 回退到JSON序列化
                    try:
                        sval = json.dumps(v, ensure_ascii=False)
                    except Exception:
                        sval = str(v)
                    escaped = sval.replace("'", "''")
                    vals.append(f"'{escaped}'")

                if col_names:
                    f.write(f"INSERT INTO {qualified} ({', '.join(col_names)}) "
                            f"VALUES ({', '.join(vals)});\n")
            f.write("\n")
    print(f"dumped to {out_path}")


def parse_simple_args(argv):
    url = os.getenv("DATABASE_URL") or DEFAULT_URL
    out = DEFAULT_OUT
    tables = DEFAULT_TABLES
    for a in argv:
        if a.startswith("--url="):
            url = a.split("=", 1)[1]
        elif a.startswith("--out="):
            out = a.split("=", 1)[1]
        elif a.startswith("--tables="):
            val = a.split("=", 1)[1]
            tables = val.split(",") if val else None
    return url, out, tables


if __name__ == "__main__":
    url, out, tables = parse_simple_args(sys.argv[1:])
    if not url:
        raise SystemExit("No database URL provided. Set DATABASE_URL env or use --url=...")
    dump_db(url, out, tables)
