import base64
import json
import os
from datetime import datetime
import requests
import urllib.parse

allowed_chat_id = os.environ['telegram_chat_id']
telegram_token = os.environ['telegram_token']
gh_username = os.environ['gh_username']
gh_token = os.environ['gh_token']
gh_repo = os.environ['gh_repo']

telegram_base_url = f"https://api.telegram.org/bot{telegram_token}"

def lambda_handler(event, context):
    request_body = json.loads(event['body'])
    chat_id = request_body['message']['chat']['id']
    message = request_body['message']['text']

    if message.startswith('/'):
        return {
            'statusCode': 200
        }

    if str(chat_id) == str(allowed_chat_id):
        res = write_file(message)
        send_message(res, allowed_chat_id)
    else:
        send_message("someone is bothering us", allowed_chat_id)
        print(f"Unauthorized chat_id: {chat_id}")
    
    return {
        'statusCode': 200
    }

def write_file(message):
    timestamp = datetime.now()
    filename = timestamp.strftime("%Y%m%d-%H%M%S.md")

    frontmatter = """---
bot: telegram
tags:
  - bot
---

"""
    message_with_frontmatter = frontmatter + message

    headers = {
        'Authorization': f'token {gh_token}',
        'Accept': 'application/vnd.github.v3+json'
    }

    url = f'https://api.github.com/repos/{gh_username}/{gh_repo}/contents/Bots/{filename}'
    data = {
        'message': f'[BOT] Added {filename}',
        'content': base64.b64encode(message_with_frontmatter.encode()).decode()
    }

    response = requests.put(url, headers=headers, json=data)

    if response.status_code == 201:
        return f'Successfully created file: {filename.replace(".md", "")}'
    else:
        return f'Failed to create file: {filename.replace(".md", "")}'


def send_message(text, target_chat_id):
    encoded_text = urllib.parse.quote_plus(text)
    url = f"{telegram_base_url}/sendMessage?text={encoded_text}&chat_id={target_chat_id}&parse_mode=Markdown"
    requests.get(url)
