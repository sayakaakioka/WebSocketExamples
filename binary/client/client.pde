import java.util.Base64;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import websockets.*;

/* サーバとの通信を管理するオブジェクト */
WebsocketClient ws;

/* 送信用データ */
PImage sendImg;

/* 受信画像保存用 */
PImage received = new PImage();

void setup() {
  /* サーバへの接続を設定・開始 */
  final String SRV_NAME = "localhost";
  final int SRV_PORT = 5001;
  ws = new WebsocketClient(this, "ws://" + SRV_NAME + ":" + SRV_PORT);

  /* 送信画像の読み込み */
  /* ファイルはこのコードがあるディレクトリの中のclientディレクトリに置くこと */
  sendImg = loadImage("sample.jpg");

  /* データ送信 */
  try {
    ws.sendMessage(encode(sendImg));
  }
  catch (Exception e) {
    e.printStackTrace();
  }
}

void draw() {
  /* 受け取った画像に合わせて窓の大きさを変更 */
  surface.setSize(
    received.width + frame.getInsets().left + frame.getInsets().right,
    received.height + frame.getInsets().top + frame.getInsets().bottom);

  /* 画像を描画 */
  image(received, 0, 0);
}

/* サーバからデータを受信したら呼ばれる関数 */
void webSocketEvent(String msg) {
  try {
    received = decode(msg);
  }
  catch(Exception e) {
    e.printStackTrace();
    return;
  }
}

/* 画像ファイルをBase64で文字列に変換する */
/* CaptureやGLCaptureはPImageを継承しているので大丈夫なはず */
String encode(PImage capture) throws IOException {
  ByteArrayOutputStream baos = new ByteArrayOutputStream();
  BufferedImage img = new BufferedImage(capture.width, capture.height, BufferedImage.TYPE_INT_RGB);
  img.setRGB(0, 0, capture.width, capture.height, capture.pixels, 0, capture.width);
  ImageIO.write(img, "jpg", baos);
  baos.flush();

  String ret = Base64.getEncoder().encodeToString(baos.toByteArray());
  baos.close();
  return ret;
}

/* Base64で受け取った文字列を画像に変換する */
PImage decode(String str) throws IOException {
  byte[] ret = Base64.getDecoder().decode(str);
  BufferedImage img = ImageIO.read(new ByteArrayInputStream(ret));
  BufferedImage fit  = new BufferedImage(img.getWidth(), img.getHeight(), BufferedImage.TYPE_INT_ARGB);
  fit.getGraphics().drawImage(img, 0, 0, null);
  return new PImage(fit);
}
