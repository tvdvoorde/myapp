import os
from flask import Flask

app = Flask(__name__)

environment = os.environ.get("TF_VAR_environment", "unknown")


@app.route("/")
def hello():
    return f"Hello World ({environment.capitalize()})"


@app.route("/health")
def health():
    return "OK"


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    app.run(host="0.0.0.0", port=port)
