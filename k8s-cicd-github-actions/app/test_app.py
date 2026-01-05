from app import app

def test_healthz():
    client = app.test_client()
    r = client.get("/healthz")
    assert r.status_code == 200
    assert r.json["status"] == "ok"
