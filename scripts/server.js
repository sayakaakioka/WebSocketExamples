const fs = require("fs");

/* コマンドライン引数のチェック */
let portNum;
if (
  process.argv.length != 3 ||
  (portNum = parseInt(process.argv[2], 10)) <= 0
) {
  console.error("usage: % node server.js <port#>");
  return;
}
process.env.TZ='Asia/Tokyo';

/* 待ち受け開始 */
const ws = require("ws");
const server = new ws.Server({ port: portNum });
printMessage("Server is ready,  waiting on " + server.address().port);

/**
 * クライアントとの接続が確立した時の処理。
 * @param {WebSocket} WebSocketオブジェクト
 */
server.on("connection", (ws, req) => {
  /* クライアントのIPアドレス */
  const ipAddr = req.socket.remoteAddress;
  printMessage("Connected from " + ipAddr + ".");

  /**
   * メッセージ到着時の処理。
   * 送られてきたデータを全てのクライアントに対して送信する。
   * @param {string} 送信されたデータ文字列
   */
  ws.on("message", (message) => {
    printMessage("[BROADCAST by " + ipAddr + "]: " + message);

    server.clients.forEach((client) => {
      if (client.readyState === ws.OPEN) {
        client.send(message);
      }
    });
  });

  /**
   * クライアント切断時の処理
   */
  ws.on("close", () => {
    printMessage("Connection closed by " + ipAddr + ".");
  });
});

/**
 * ファイル出力用の関数
 * @param {string} 出力メッセージ
 */
function printMessage(message) {
  console.log(new Date().toLocaleString() + "\t" + message); 
}
