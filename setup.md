# 環境構築

* [Node.js](https://nodejs.org/ja/)のインストール（サーバプログラムを動かすために必要）[↓](#Node.jsのインストール)
* Node.jsのwsモジュールのインストール（サーバプログラムを動かすために必要）[↓](#Node.jsのwsモジュールのインストール)
* Processing用のWebSocketライブラリのインストール[↓](#Processing用のWebSocketライブラリのインストール)

## Node.jsのインストール

Node.jsは、本来はブラウザ等からのみ実行可能であったJavaScriptを、コマンドラインから実行するためのツール。
ブラウザから起動しないサーバプログラムを動かすために必須。

### Windowsの場合

[Node.jsの公式サイト](https://nodejs.org/ja/)から安定版をダウンロードしてインストール。
特にオプションの変更はなく、「次へ」の連打で良い。

### Macの場合

TODO: HomebrewからスタートしてNode.jsのインストールまで書く。

## Node.jsのwsモジュールのインストール

今回はWebSocketという仕組みを使って通信するので、これをJavaScriptで簡単に書くためのモジュールを
インストール。

Windowsならばコマンドプロンプトで、Macならばターミナルで、WebSocketExampleディレクトリ
（今読んでいる[setup.md](./setup.md)が置いてあるディレクトリ）に移動して、以下のコマンドを実行する。

```sh
% npm install ws
```

## Processing用のWebSocketライブラリのインストール

今回はWebSocketという仕組みを使って通信するので、これをProcessingで簡単に書くためのモジュールを
インストール。

サーバプログラムを開いた状態で「Tools」メニューから「Add Tool...」を選ぶ。
新しく開いた窓で「Libraries」タブを選択し、検索窓で「WebSockets」を検索。
Lasse Steenbock Vestergaard氏が作ったWebsocketsというライブラリが見つかるので、これを選んで
インストールする。
