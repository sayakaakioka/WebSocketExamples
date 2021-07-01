# -*- coding:utf-8 -*-
import websocket
import threading
import time

# 動作検証用の乱数生成にのみ使用
import random

def on_message(ws, message):
    # 変数への変更をスレッド間で共有したいのでglobal化
    # Read Onlyで良い場合には不要
    global msg
    with msgLock:
        msg = message

    with printLock:
        print("on_message: " + message)

def on_error(ws, error):
    with printLock:
        print("ERROR: " + error)

def on_close(ws):
    with printLock:
        print("CONNECTION CLOSED")

def on_open(ws):
    thread = threading.Thread(target=sendLoop, args=(ws,))
    thread.setDaemon(True)
    thread.start()

def sendLoop(ws):
    # 関数ローカルの変数はlocalStorage以外はスレッド間で共有される
    localStorage.counter = 0
    while True:
        # このあたりで適当にセンサ情報を取得するなど

        with lock:
            ws.send("From Python {}".format(localStorage.counter))

        # global化した変数の挙動確認のためにランダム時間でsleep
        time.sleep(random.random())

        # on_message()で受け取ったデータが共有されていることを確認
        with printLock:
            print("sendLoop: " + msg)

        localStorage.counter += 1


lock = threading.Lock()
printLock = threading.Lock()
msgLock = threading.Lock()

# sendLoop()を呼び出すスレッドがひとつのみの場合は不要
localStorage = threading.local()

msg = ""

# 通信の様子を詳しく見たい場合には利用
#websocket.enableTrace(True)

ws = websocket.WebSocketApp("ws://192.168.50.24:10001", on_open=on_open, on_message=on_message, on_error=on_error, on_close=on_close)
ws.run_forever()


