from websocket import create_connection
import time

ws = create_connection("ws://localhost:5001")
counter = 0
while True:
    try:
        ws.send("From Python send-only client: {}".format(counter))
        counter += 1
        time.sleep(1)
    except KeyboardInterrupt:
        print("Client terminated by KeyboardInterrupt.")
        ws.close()
        break
    except:
        print("Client terminated with unknown status.")
        ws.close()
        break

