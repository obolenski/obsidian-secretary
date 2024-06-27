import json
import os
from datetime import datetime
import urllib.parse
import requests
from github_interaction import write_file
from pytz import timezone

allowed_chat_id = os.environ['telegram_chat_id']
telegram_token = os.environ['telegram_token']
telegram_base_url = f"https://api.telegram.org/bot{telegram_token}"

CET = timezone('CET')
OK = { "statusCode": 200 }

def lambda_handler(event, context):
    request_body = json.loads(event['body'])
    chat_id = request_body['message']['chat']['id']
    message = request_body['message']['text']

    if str(chat_id) != str(allowed_chat_id):
        send_message(f"someone is bothering us - {chat_id}", allowed_chat_id)
        print(f"Unauthorized chat_id: {chat_id}")
        return OK
    
    if message.startswith("/"):
        return OK

    res = make_freestyle_note(message)
    send_message(res, allowed_chat_id)
    
    return OK

def make_freestyle_note(message):
    timestamp = datetime.now(CET)
    filename = timestamp.strftime("%Y-%m-%d_%H-%M-%S.md")

    with open('frontmatter.md', 'r') as file:
        frontmatter = file.read()

    file_contents = frontmatter + message

    res = write_file(file_contents, filename)
    return res

def send_message(text, target_chat_id):
    encoded_text = urllib.parse.quote_plus(text)
    url = f"{telegram_base_url}/sendMessage?text={encoded_text}&chat_id={target_chat_id}&parse_mode=Markdown"
    requests.get(url)
