import websockets.*;

/* サーバとの通信を管理するオブジェクト */
WebsocketClient ws;

/* draw()の中で数字をカウントアップしながら送信するため */
int counter = 0;

/* 自分の名前 */
final String MY_NAME = "Processing";

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
  ws.sendMessage(MY_NAME + "," + str(counter) + "," + str(counter*2) + "," + str(counter*4));
  counter++;

  delay(1000);
}

/* サーバからデータを受信したら呼ばれる関数 */
void webSocketEvent(String msg) {
  /* 受け取ったデータをカンマで切り分けて先頭から順に配列に保存 */
  String[] data = msg.split(",");

  /* 配列の先頭に入っている名前が自分の名前じゃない時だけ処理 */
  if(!MY_NAME.equals(data[0]) && data.length == 4){
    println(data[1] + ", " + data[2] + ", " + data[3]);
  }
}
