import os
import sys
from slack_sdk import WebClient

client = WebClient(os.environ["SLACK_BOT_TOKEN"])
args = sys.argv

response = client.chat_postMessage(
    channel="#notifications",
    text="Process #{} terminated.".format(args[1])
)