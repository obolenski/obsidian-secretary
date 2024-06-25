import os
import base64
import requests

gh_username = os.environ['gh_username']
gh_token = os.environ['gh_token']
gh_repo = os.environ['gh_repo']

def write_file(message, filename, folder = "Bots"):
    url = f'https://api.github.com/repos/{gh_username}/{gh_repo}/contents/{folder}/{filename}'

    headers = {
        'Authorization': f'token {gh_token}',
        'Accept': 'application/vnd.github.v3+json'
    }

    data = {
        'message': f'[BOT] Added {filename}',
        'content': base64.b64encode(message.encode()).decode()
    }

    response = requests.put(url, headers=headers, json=data)

    if response.status_code == 201:
        return "I have noted that down"
    else:
        print(response.json())
        return "I am afraid to inform you that I was unable to note that down"
