import websockets.*;

/* サーバとの通信を管理するオブジェクト */
WebsocketClient ws;

/* draw()の中で数字をカウントアップしながら送信するため */
int counter = 0;

void setup() {
  /*
      サーバプログラムが同じパソコンで動いているなら「localhost」
      別のパソコンやクラウド上で動いているならサーバ名やIPアドレス
   */
  final String SRV_NAME = "localhost";
  /* サーバプログラムと同じポート番号を設定すること */
  final int SRV_PORT = 5001;

  /* サーバへの接続を設定・開始 */
  ws = new WebsocketClient(this, "ws://" + SRV_NAME + ":" + SRV_PORT);
}

void draw() {
  /* データ送信。送信データはString型のみ。*/
  ws.sendMessage(str(counter));
  counter++;

  delay(1000);
}

/* サーバからデータを受信したら呼ばれる関数 */
void webSocketEvent(String msg) {
  /* 受け取ったデータをそのまま表示 */
  println(msg);
}
