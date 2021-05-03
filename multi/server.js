const ws = require("ws");

/* ポート番号は班ごとに変えたいので「5000+班番号」とすること */
const server = new ws.Server({ port: 5001 });

/**
 * 'connection' = 「クライアントとの接続が確立した時」の挙動を登録する。
 * 繋がった瞬間の動作なので、クライアントからデータが到着した時や切断要求が来た時の
 * 挙動登録を行う。
 * @param {WebSocket} WebSocketオブジェクト
 */
server.on("connection", (ws) => {
  /**
   * 'message' = 「クライアントからデータが到着した時」の挙動を登録する。
   * 送られてきたデータを全てのクライアントに対して送信する。
   * @param {string} 送信されたデータ文字列
   */
  ws.on("message", (message) => {
    server.clients.forEach((client) => {
      if (client.readyState === ws.OPEN) {
        client.send(message);
      }
    });
  });

  /**
   * 'close' = 「クライアントが切断要求してきた時」の挙動を登録する。
   * 切断処理は明示的に書かなくても実行されるので切断前に行いたい処理を書いておく。
   * 今回は切断要求が来たことがわかるように適当な文字列を出力するのみ。
   */
  ws.on("close", () => {
    console.log("bye");
  });
});

/* サーバ起動確認のためにメッセージ出力 */
console.log("Server is ready, waiting on " + server.address().port);
