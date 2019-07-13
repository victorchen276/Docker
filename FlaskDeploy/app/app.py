from flask import Flask

app = Flask(__name__)

@app.route("/")
def index():
  return """
  <h1>Python Flask in Docker!</h1>
  <p>A sample web-app for running Flask inside Docker.</p>
  """
@app.route("/hello/<username>")
def hello(username):
    page_html = """
    <h1>Python Falsk in Docker!</h1>
    <a href="/"> [Back to Home] </a>
    <hr>
    """
    page_html += "<h2> Hello, %s </h2>" % (username)

    return page_html

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0')