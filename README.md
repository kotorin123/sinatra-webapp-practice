# sinatra-webapp-practice
シンプルなメモ管理アプリです。

## ローカル起動手順

### 1. リポジトリをクローン
```

git clone https://github.com/kotorin123/sinatra-webapp-practice.git
cd sinatra-webapp-practice
```

### 2. BundlerでGemをインストール
```
bundle install
```
※ RuboCopの設定
https://github.com/fjordllc/rubocop-fjord

※ ERB Lintの設定
https://github.com/Shopify/erb_lint

### 3. アプリケーション起動
```

DB_NAME=memo_app DB_USER=<USERNAME> bundle exec ruby app.rb
``` 

### 4. ブラウザでアクセス
```

http://localhost:4567/memos
```
