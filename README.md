# Salesforce DX Project: Devops-pipeline

## CI/CD パイプライン概要

このリポジトリはGitHub Actionsを使ったSalesforce CI/CDパイプラインを実装しています。

### PR検証ワークフロー

`main`ブランチへのプルリクエスト作成・更新時に、`sfdx-git-delta`を使って**差分メタデータのみ**を本番環境へチェックデプロイ(検証のみ・実反映なし)します。

```
feature/xxx ─────────────── PR ──→ main
               ↓
        sfdx-git-delta で差分を検出
               ↓
        本番環境へ Check-Only Deploy
               ↓
        結果をPRにコメント投稿
```

### 初期セットアップ手順

#### 1. JWT用の秘密鍵・証明書を生成

先に鍵を生成してから、後の手順でSalesforceへアップロードします。

```bash
# 秘密鍵と自己署名証明書を生成
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
  -keyout server.key \
  -out server.crt \
  -subj "/CN=salesforce-ci"

# server.crt → Salesforceの外部クライアントアプリケーションにアップロード
# server.key → GitHub Secrets に登録 (手順3)
```

#### 2. 本番組織に外部クライアントアプリケーションを作成

1. 本番組織の「**設定**」を開き、クイック検索で「**外部クライアントアプリケーション**」と入力して移動
2. 「**新規外部クライアントアプリケーション**」をクリック
3. 基本情報を入力:
   - **外部クライアントアプリケーション名**: `GitHub Actions CI` (任意)
   - **API参照名**: 自動入力でOK
   - **連絡先メール**: 管理者メールアドレス
4. 「**OAuth設定**」セクションで以下を設定:
   - **コールバックURL**: `http://localhost:1717/OauthRedirect`
     (JWTフローではリダイレクトは発生しないため、このダミー値でOK)
   - **OAuth フロー**: 「**JWTベアラーフロー**」を有効化
   - **デジタル署名を使用**: 手順1で生成した `server.crt` をアップロード
   - **選択されたOAuthスコープ**: 以下の **2つ** を追加
     - `APIを介してユーザーデータを管理 (api)`
     - `いつでも要求を実行 (refresh_token, offline_access)` ※JWTベアラーフローで必須
5. 保存後、「**コンシューマーキーとシークレット**」セクションから **コンシューマーキー** をコピーして控えておく

#### 2-1. 外部クライアントアプリケーションのポリシーを設定

1. 作成したアプリケーションの「**ポリシー**」タブを開く
2. **OAuthポリシー** で「**許可されているユーザー**」を「**管理者が承認したユーザーは事前承認済み**」に変更
3. 保存

#### 2-2. ユーザーにアクセスを付与

1. 「**設定 > ユーザー**」からCI/CDで使用するユーザーを開く
2. 「**外部クライアントアプリケーションのアクセス**」セクションで作成したアプリを追加
   - または 権限セットを使って付与する場合:「**設定 > 権限セット**」から対象権限セットを開き、「**外部クライアントアプリケーションのアクセス**」に追加

#### 3. GitHub Secrets を設定

リポジトリの `Settings > Secrets and variables > Actions` に以下を登録:

| Secret名 | 値 |
|---|---|
| `SALESFORCE_JWT_SECRET_KEY` | `server.key` の内容 (`-----BEGIN PRIVATE KEY-----` から全文) |
| `SALESFORCE_CONSUMER_KEY` | 手順2でコピーした **コンシューマーキー** |
| `SALESFORCE_USERNAME` | 本番組織のユーザー名 (例: `admin@example.com`) |
| `SALESFORCE_INSTANCE_URL` | 本番組織のURL (例: `https://login.salesforce.com`) |

#### 4. 動作確認

1. `feature/test`ブランチを作成
2. `force-app`配下のメタデータを変更してコミット
3. `main`へのPRを作成
4. Actions タブで `PR - 本番環境チェックデプロイ検証` ワークフローが実行されることを確認

---

## Salesforce DX Project: Next Steps

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
