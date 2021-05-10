import java.util.Base64;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;

import processing.video.*;

/* デコード後のデータ用 */
PImage received = new PImage();

/* カメラキャプチャ用 */
Capture cam;

void setup() {
  /* 利用可能なカメラ一覧を表示 */
  String[] cameras = Capture.list();
  for (int i=0; i<cameras.length; i++) {
    println(i + ": " + cameras[i]);
  }

  /* ここでは2番のカメラを使う。環境によって変更すること。 */
  cam = new Capture(this, cameras[2]);
  cam.start();
}

void draw() {
  /* 画像をBase64でエンコードした文字列を保存するための変数 */
  String str = new String();

  if (cam.available()) {
    /* カメラが利用可能ならば1枚キャプチャ */
    cam.read();
    try {
      /* エンコード */
      str = encode(cam);
      println(str);
    }
    catch(IOException e) {
      e.printStackTrace();
    }
  }

   if (str.length() > 0) {
     /* 画像がエンコードされた気配があればデコードして表示する */
    try {
      /* デコード */
      received = decode(str);

      /* デコード画像に合わせてウィンドウサイズを変更 */
      surface.setSize(
        received.width + frame.getInsets().left + frame.getInsets().right,
        received.height + frame.getInsets().top + frame.getInsets().bottom);

      /* Processingのウィンドウに描画 */
      image(received, 0, 0);
    }
    catch(IOException e) {
      e.printStackTrace();
    }
  }
}

/* 画像ファイルをBase64で文字列に変換する */
/* CaptureはPImageを継承しているので大丈夫なはず */
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
