const ws = require("ws");

/* ポート番号は班ごとに変えたいので「5000+班番号」とすること */
const server = new ws.Server({ port: 5001 });

/**`
 * 'connection' = 「クライアントとの接続が確立した時」の挙動を登録する。
 * 繋がった瞬間の動作なので、クライアントからデータが到着した時や切断要求が来た時の
 * 挙動登録を行う。
 * @param {WebSocket} WebSocketオブジェクト
 */
server.on("connection", (ws) => {
  /**
   * 今回は各クライアントが名前を持つので、名前を保存する変数を用意する。
   * @param {string} クライアントの名前
   */
  ws.name = "anonymous";

  /**
   * 'message' = 「クライアントからデータが到着した時」の挙動を登録する。
   * 送られてきたデータを全てのクライアントに対して送信する。
   * @param {string} 送信されたデータ文字列
   */
  ws.on("message", (message) => {
    /* 動作確認のために受け取ったメッセージをそのまま出力 */
    console.log(message);

    /*
     * メッセージは「{文字列},{文字列}」形式なので正規表現で前半と後半に分ける
     */
    const pattern = /^\{(.*?)\},\{(.*?)\}/;
    let tokens = message.match(pattern);

    if (tokens != null && tokens.length === 3) {
      /* メッセージの形式が正しいので処理を進める */
      if ("REGISTER" === tokens[2] && ws.readyState === ws.OPEN) {
        /* {文字列},{REGISTER}ならば前半文字列を名前として登録する */
        ws.name = tokens[1];

        /* 送信者をSERVERとしてウェルカムメッセージ送信 */
        ws.send("{SERVER},{Welcome, " + ws.name + "!}");
      } else if ("" === tokens[1]) {
        /* 宛先が空なので全員に送信する */
        server.clients.forEach((client) => {
          /* clientとの通信が確立されていればデータを送信 */
          if (client.readyState === ws.OPEN) {
            client.send("{" + ws.name + "},{" + tokens[2] + "}");
          }
        });
      } else {
        /* 指定した宛先と送信者のみに送信するために送信者を抽出 */
        let dest = tokens[1].split(",");

        server.clients.forEach((client) => {
          dest.forEach((d) => {
            if (client.name === d && client.readyState === ws.OPEN) {
              /* 指定された相手に送信 */
              client.send("{" + ws.name + "},{" + tokens[2] + "}");
            } else if (client === ws && client.readyState === ws.OPEN) {
              /* 送信者に送信 */
              client.send("{" + ws.name + "},{" + tokens[2] + "}");
            }
          });
        });
      }
    } else {
      /* メッセージ形式が正しくない */
      console.log("Illegal format message.");
    }
  });

  /**
   * 'close' = 「クライアントが切断要求してきた時」の挙動を登録する。
   * 切断処理は明示的に書かなくても実行されるので切断前に行いたい処理を書いておく。
   * 今回は切断要求が来たことがわかるように適当な文字列を出力するのみ。
   */
  ws.on("close", () => {
    console.log("Bye, " + ws.name + "!");
  });
});

/* サーバ起動確認のためにメッセージ出力 */
console.log("Server is ready,  waiting on " + server.address().port);
