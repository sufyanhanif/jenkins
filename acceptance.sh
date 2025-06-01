import requests

def test_homepage():
    response = requests.get("http://localhost:5000")
    assert response.status_code == 200
    assert "Hello, world!" in response.text

if __name__ == "__main__":
    test_homepage()
    print("Acceptance test passed")
