from flask import Flask # type: ignore
import random
import os  # Add this import

app = Flask(__name__)

@app.route("/")
def test():
    return "Testing the poetry app!"

@app.route("/json")
def test_json():
    return {
        "message": "This is a JSON response",
        "status": "success",
        "data": {
            "numbers": [1, 2, 3, 4, 5],
            "boolean": True
        }
    }

@app.route("/html")
def test_html():
    random_numbers = [random.randint(1, 100) for _ in range(3)]
    random_colors = ['red', 'blue', 'green', 'yellow', 'purple', 'orange']
    random_words = ['Python', 'Docker', 'Flask', 'Web', 'Cloud', 'Code']
    
    return f"""
    <h1>HTML Test Page</h1>
    <p>This is a simple HTML response from Flask</p>
    <ul>
        <li>Random Numbers: {', '.join(map(str, random_numbers))}</li>
        <li>Random Color: {random.choice(random_colors)}</li>
        <li>Random Word: {random.choice(random_words)}</li>
    </ul>
    """

@app.route("/error")
def test_error():
    return "This is a test error page", 500

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000))
    print(f"Starting server on port {port}")
    app.run(host="0.0.0.0", port=port)