import urllib.request
import json
import urllib.error

url = "https://generativelanguage.googleapis.com/v1beta/models?key=AIzaSyDPB97jxDD7KF4iA3X5x0sWqlwXmZBHzHE"

try:
    req = urllib.request.Request(url)
    with urllib.request.urlopen(req) as response:
        result = json.loads(response.read().decode())
        models = [m['name'] for m in result.get('models', []) if 'gemini-1.5-flash' in m['name']]
        print("Models matching 'gemini-1.5-flash':", models)
except urllib.error.URLError as e:
    print("Error:", e)
