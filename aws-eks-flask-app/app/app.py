from flask import Flask, request, jsonify
import boto3, psycopg2, os, time

app = Flask(__name__)

S3_BUCKET = os.getenv("S3_BUCKET", "my-eks-flask-bucket1" )
POSTGRES_HOST = os.getenv("POSTGRES_HOST", "postgres")
POSTGRES_DB = os.getenv("POSTGRES_DB", "mydatabase")
POSTGRES_USER = os.getenv("POSTGRES_USER", "postgres")
POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD", "password")

s3 = boto3.client("s3")

def get_db_conn():
    while True:
        try:
            conn = psycopg2.connect(
                host=POSTGRES_HOST,
                dbname=POSTGRES_DB,
                user=POSTGRES_USER,
                password=POSTGRES_PASSWORD
            )
            return conn
        except Exception as e:
            print("Postgres not ready, retrying...", e)
            time.sleep(5)

@app.route("/up")
def up():
    return {"status": "ok"}

@app.route("/upload", methods=["POST"])
def upload():
    file = request.files["file"]
    s3.upload_fileobj(file, S3_BUCKET, file.filename)
    return {"message": f"{file.filename} uploaded to S3"}

@app.route("/file/<name>")
def get_file(name):
    url = s3.generate_presigned_url("get_object", Params={"Bucket": S3_BUCKET, "Key": name}, ExpiresIn=3600)
    return {"url": url}

@app.route("/dbtest")
def dbtest():
    conn = get_db_conn()
    cur = conn.cursor()
    cur.execute("CREATE TABLE IF NOT EXISTS test (id SERIAL PRIMARY KEY, msg TEXT);")
    cur.execute("INSERT INTO test (msg) VALUES ('hello from flask') RETURNING id;")
    conn.commit()
    cur.execute("SELECT * FROM test;")
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return {"records": rows}
