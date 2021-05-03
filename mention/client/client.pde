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

  /* 自分の名前を登録 */
  ws.sendMessage("{Processing},{REGISTER}");
}

void draw() {
  /* データ送信。送信データはString型のみ。*/
  ws.sendMessage("{},{Broadcasting message}");
  delay(1000);

  ws.sendMessage("{browser},{" + counter + "}");
  counter++;
  delay(1000);
}

/* サーバからデータを受信したら呼ばれる関数 */
void webSocketEvent(String msg) {
  /* 受け取ったデータを送信者と送信データに分割 */
  String [] tokens = match(msg, "^\\{(.*?)\\},\\{(.*?)\\}$");

  if(tokens != null && tokens.length == 3){
    /* 「送信者: 受信データ」の形で出力 */
    println(tokens[1] + ": " + tokens[2]);
  } else {
    /* データ形式が正しくない */
    println("Illegal formant message: " + msg);
  }
}
