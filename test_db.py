import psycopg2

try:
    conn = psycopg2.connect(
        dbname="certificate_db",
        user="root",
        password="vkoCPvy3OSyZ9xE57sqF0mZU",
        host="certificate-db",
        port="5432"
    )
    print("Successfully connected to the database!")
    conn.close()
except Exception as e:
    print(f"Error connecting to the database: {e}")
