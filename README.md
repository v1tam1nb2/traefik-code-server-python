# traefik-code-server-python

Traefik(リバプロ)+code-server(Web IDE)+PythonによるFastAPI開発環境


# セットアップ

## 概要

Qiitaに記事を書いています。

- [【Docker】Traefik(リバプロ)+code-server(Web IDE)+PythonでFastAPI開発環境を作る](https://qiita.com/v1tam1n/items/034e8e32d3e350223dbf)

## ソースのインストール

```bash
git clone https://github.com/v1tam1nb2/traefik-code-server-python.git
```

## イメージビルド

```bash
docker build -t code-server-python .
```

## コンテナ構築

```bash
docker-compose up -d
```

# アクセス確認

|  URL  |  サービス  | 概要  |
| ---- | ---- | ---- |
|  http://localhost:18000  |  Traefik Dashboard  | Traefikのダッシュボードでリバプロ情報を確認できる  |
|  http://code.localhost  |  code-server  | WebIDEであるcode-serverにアクセス  |
|  http://sqlpad.localhost  |  SQLPad  | SQL クエリを記述して実行し、結果を視覚化するためのWebアプリにアクセス  |
|  http://fastapi.localhost  |  FastAPI  | FastAPIを実行している場合はこのURLにアクセスすると結果を確認できる  |