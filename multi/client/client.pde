import java.util.Base64;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import websockets.*;
import processing.video.*;

/* サーバとの通信を管理するオブジェクト */
WebsocketClient ws;

/* 送信用データ */
Capture cam;

/* 受信画像保存用 */
PImage received = new PImage();

/* それぞれのデータ形式について先頭に付加するデータを定義 */
final String TEXT_HEADER = "data:";
final String JPG_HEADER = "data:image/jpeg;base64";

void setup() {
  /* サーバへの接続を設定・開始 */
  final String SRV_NAME = "localhost";
  final int SRV_PORT = 5001;
  ws = new WebsocketClient(this, "ws://" + SRV_NAME + ":" + SRV_PORT);

  /* カメラの準備 */
  String[] cameras = Capture.list();
  for (int i=0; i<cameras.length; i++) {
    println(i + ": " + cameras[i]);
  }

  cam = new Capture(this, cameras[2]);
  cam.start();
}

void draw() {
  try {
    if (cam.available()) {
      /* カメラが利用可能ならば1枚キャプチャ */
      cam.read();
      String str = encode(cam);
      ws.sendMessage(str);
    }
  }
  catch(Exception e) {
    e.printStackTrace();
    return;
  }

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
    /* 受信文字列をカンマで区切って分けて配列に保存 */
    String[] tokens = split(msg, ",");

    if (tokens[0].equals(TEXT_HEADER)) {
      /* テキストを示すデータが先頭にある場合はデータのみプリント */
      println(tokens[1]);
    } else {
      /* 画像を示すデータが先頭にある場合は画像に変換 */
      received = decode(tokens[1]);
    }
  }
  catch(Exception e) {
    e.printStackTrace();
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
  return JPG_HEADER + "," + ret;
}

/* 文字列の先頭にテキストを示す情報を付加する */
String encode(String message) {
  return TEXT_HEADER + "," + message;
}

/* Base64で受け取った文字列を画像に変換する */
PImage decode(String str) throws IOException {
  byte[] ret = Base64.getDecoder().decode(str);
  BufferedImage img = ImageIO.read(new ByteArrayInputStream(ret));
  BufferedImage fit  = new BufferedImage(img.getWidth(), img.getHeight(), BufferedImage.TYPE_INT_ARGB);
  fit.getGraphics().drawImage(img, 0, 0, null);
  return new PImage(fit);
}
