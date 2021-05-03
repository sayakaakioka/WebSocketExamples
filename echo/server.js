const ws = require("ws");

/* ポート番号は班ごとに変えたいので「5000+班番号」とすること */
const server = new ws.Server({ port: 5001 });

/*
 * JavaScriptでは名前を持たない関数を作ることができる。
 * let ret = function(a, b){
 *   return a + b;
 * };

 * これを簡潔に「アロー関数」を使って簡潔に書くと次のようになる。
 * 引数がひとつならば()は省略可能だが、引数がない時も含めてそれ以外は省略不可。
 * let ret = (a, b) => {
 *   return a + b;
 * };
 *
 * 以下の例では、各イベントが起きた時に実行する関数を登録しており、
 * 具体的な関数名を書くスタイルではなく、アロー関数を使った無名関数を使っている。
 */

/**`
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
    /* 動作確認のために受け取ったメッセージをそのまま出力 */
    console.log(message);

    /*
     * server.clients.forEach()はclientsの全てに対して引数内の処理を実行する。
     * clientsの要素を先頭からひとつずつclientに入れてループ処理する。
     */
    server.clients.forEach((client) => {
      /* clientとの通信が確立されていればデータを送信 */
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
console.log("Server is ready,  waiting on " + server.address().port);
