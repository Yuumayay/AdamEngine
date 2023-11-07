# AdamEngine
アダムエンジンのダウンロード、ありがとうございます。
バグを見つけたらGitHubのIssueに報告してね！

動作に必要なバージョン：Godot4.2beta4

このエンジンは、さくしゃYuumayayが発狂して作った
FNFエンジンです。このエンジンでは以下のようなことができます

### 1. Psych & Leather 互換性
  メジャーなエンジンであるPsych Engineと
  Leather Engineとの互換性を持ち、
  modsファイルをそのまま入れても動くこともあります。
  おもろい。

### 2. 日本語の対応
  当エンジンは日本語に対応しています。
  日本語にすると、こんな感じに置き換わります。
  * Marvelous → スゲェ
  * Sick → イイネ
  * Good → フツー
  * Bad → ウーン
  * Shit → ダメダメ

  他にも、様々な箇所が翻訳されます。

### 3. キーカウントが無限に増やせる
   通常のキーカウントの他に、
   1～3Key、5～18Keyを使うことができます。
   19Key以上でも1000Keyでも一応動きます。
   ノーツが小さすぎてほぼ見えませんが・・・

### 4. Godot4で完全に0から作成
  私が発狂して作ったので、
  このエンジンは0から作られています。
  ハードコードだった部分がjsonになり、
  FNFのすっっげぇ変な仕様が改善されています。

### 5. 作りやすいModchart
   Miss制限、1行でできます。
   Ghost Tappingも、1行でできます。
   特定のキーを押して曲移動するのも、
   1行でできます。
   Modchartの作り方はGitHubに載せてあります。

### 6. チャートエディタ
  チャートエディタを搭載しています。
  以下のような機能がついています
  * MIDIからチャートをインポートできる！　C5-D#5: DAD,  C6-D#6: BF, C#7: mustHitSection
  * コピー&ペースト
  * ズーム機能
  * グリッド機能
  * 長押しはEキーで伸ばすのではなく、ドラッグで伸ばせるように
  * キャラクター個別のキーカウント変更

# TODOリスト

### 1. Luaの対応
  Godot4.2最新バージョンのLuaAPIがまだ出ていないので
  Godot4.2が正式リリースされたら実装します

### 2. 背景の読み込み
  TODO1番の理由により背景が読み込めないので
  jsonでstageを作ってください。
  書き方はAssetsのstage.jsonを見ればわかるはず
