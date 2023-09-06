# [オリジナル斬魄刀投稿サイト]

## サービス概要
BLEACHが好きな人を対象とした、自分の考えたオリジナル斬魄刀を投稿することができるサービスです。
また、他人の投稿を見て楽しんだり、その投稿にコメントを入れることができます。



## 斬魄刀(ざんぱくとう)とは？
漫画BLEACHに登場する死神達が持つ刀のことを斬魄刀といいます。各斬魄刀にはそれぞれ固有の能力
があります。ワンピースでいう悪魔の実、ヒロアカでいう個性みたいなものです。



## 想定されるユーザー層
10~30代前半でBLEACHが好きな人。BLEACHのアニメを見ている人。



## サービスコンセプト
最近BLEACHのアニメが放送されていて、その話題で盛り上がりたいBLEACHファンがいると思うので、
そのような人々に対して、自分の考えたオリジナル斬魄刀を投稿できるサービスを提供しようと考えています。
ユーザーの考えた面白い斬魄刀や、カッコいい、オサレな斬魄刀を共有することでBLEACHファン同士で盛り上がって
いければとても楽しいサービスになると思います。現状オリジナル斬魄刀を投稿することに特化したサービスがない
ので、カッコよくてオサレなデザインでサービスを作れば、すぐにユーザーに使ってもらえると思います。



## 実装を予定している機能
### MVP
* 会員登録
* ログイン
#### 未登録でできること
* 投稿一覧が見れる
* 投稿詳細が見れる
* 斬魄刀名やユーザーの名前で投稿を検索できる(マルチ検索、オートコンプリート機能付き検索フォーム)
* 投稿に対するコメントが見れる
#### 会員登録後にできること
* 投稿できる
* 投稿を編集できる
* 投稿を削除できる
* 他の投稿に対してコメントやいいね(霊圧)がつけられる
* 自分のプロフィールを確認したり編集ができる
* 下書き保存機能
* 投稿する前に確認画面を挟む
* 投稿にタグ付けができる。新規タグの作成、タグで検索ができる

### 本リリース時までに作っていたいもの
* マイページで自分が投稿した斬魄刀の一覧が見れる
* マイページで自分がいいね(霊圧)した投稿の一覧が見れる
* 投稿をTwitterで共有できる(OGP)
* パスワードリセット
* 英語対応(BLEACHは海外人気もあるから)

### 本リリース後に実装したい機能
* オリジナル斬魄刀を投稿するたびにトップページのデザインが変化する
* 他の投稿をブックマークできる。ブックマーク一覧が見れる
* 管理画面へのログイン機能、ユーザー、投稿のCRUD機能

### どうやって高度な機能を実装するか
#### マイページで自分が投稿した斬魄刀の一覧が見れる
→コントローラー側で @posts = current_user.posts.allとし、ビューでeach文を使って表示する。
#### 投稿をTwitterで共有できる(OGP)
→ https://qiita.com/o83184206/items/409736eebe2f92d36e86
#### パスワードリセット
→SorceryのReset Passwordモジュールとletter_opener_webの導入。
#### 下書き保存機能
→ https://qiita.com/mi-1109/items/4d81992fbae6f2067a82
#### オリジナル斬魄刀を投稿するたびにトップページのデザインが変化する
→ current_user.posts.countの値が0→1になった時、トップページがswiperで2枚
表示されて新しいデザインが増え、current_user.posts.countの値が2,3になるにつれて、swiperで表示される枚数が1ずつ
増えていく。4以降は増えないものとするが、MVP以降どんどん増やしていく。どのくらい増やすかは未定。
https://osamudaira.com/411/
#### 英語対応(BLEACHは海外人気もあるから)
→i18nのgemを使う。
#### 投稿する前に確認画面を挟む
→ https://qiita.com/ngron/items/d55aac6e81a9fb2fe81c
#### 斬魄刀名やユーザーの名前で投稿を検索できる(マルチ検索、オートコンプリート機能付き検索フォーム)
→ https://techblog.kyamanak.com/entry/2018/06/03/170603
https://woshidan.hatenadiary.jp/entry/2021/04/05/205301
#### 投稿にタグ付けができる。新規タグの作成、タグで検索ができる
→acts-as-taggable-onのgemを使用する
#### 他の投稿をブックマークできる。ブックマーク一覧が見れる
→ https://osamudaira.com/217/
#### 管理画面へのログイン機能、ユーザー、投稿のCRUD機能
→ https://osamudaira.com/257/

## 画面遷移図
https://www.figma.com/file/c5lOCP9ThpX4PymcfLGZkF/Untitled?type=design&node-id=0%3A1&mode=design&t=Qd7h8gmYp4W0o7hz-1

## ER図
https://drive.google.com/file/d/1FbzY5JhtYwA1lpO4bwWYBzto79CfI53_/view?usp=sharing