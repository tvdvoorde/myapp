import pytest
import os


@pytest.fixture()
def client():
    os.environ["TF_VAR_environment"] = "dev"
    from app import app as flask_app
    flask_app.testing = True
    with flask_app.test_client() as client:
        yield client


def test_hello(client):
    response = client.get("/")
    assert response.status_code == 200
    assert b"Hello World (Dev)" in response.data


def test_health(client):
    response = client.get("/health")
    assert response.status_code == 200
    assert response.data == b"OK"
