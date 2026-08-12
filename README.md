# vim9-lsp-client

Vim9 Script用のLSPクライアントプラグイン。[vim9-lsp-server](https://github.com/ue555/vim9-lsp-server)を自動セットアップし、Vimエディタで以下の機能を提供します：

- 定義へのジャンプ (Go to Definition)
- ホバー情報 (Hover)
- コード補完 (Completion)
- ドキュメントフォーマット (Formatting)
- 診断情報 (Diagnostics)

## 特徴

- **自動セットアップ**: vim9-lsp-serverのクローン、ビルド、設定を自動化
- **柔軟なLSPクライアント対応**: Vim 9.1+組み込みLSP、vim-lspの両方をサポート
- **VPM対応**: [VPM](https://github.com/ue555/vpm)で簡単にインストール可能
- **Golang製セットアップツール**: 高速で信頼性の高いインストール処理

## 必要要件

- Vim 8.0+ または Vim 9.1+
- Node.js 18.0+
- Git
- Go 1.21+ (ビルド時のみ)

**LSPクライアント（いずれか）:**
- Vim 9.1+ (組み込みLSPサポート)
- [vim-lsp](https://github.com/prabirshrestha/vim-lsp) (Vim 8.0+で動作)

## インストール

### VPMを使用する場合

`~/.config/vpm/plugins.json` に以下を追加：

```json
{
  "plugins": [
    "prabirshrestha/vim-lsp",
    {
      "url": "https://github.com/ue555/vim9-lsp-client",
      "build": "make"
    }
  ]
}
```

その後、VPMでインストール：

```bash
vpm install
```

### 手動インストール

```bash
# プラグインディレクトリにクローン
cd ~/.vim/pack/plugins/start
git clone https://github.com/ue555/vim9-lsp-client

# セットアップツールをビルド
cd vim9-lsp-client
make build

# vim9-lsp-serverをインストール
make install
```

## 使い方

### 自動セットアップ

デフォルトでは、Vim起動時に自動的にLSPサーバーが設定されます。

### 手動セットアップ

自動セットアップを無効にする場合は、`.vimrc`に以下を追加：

```vim
let g:vim9_lsp_auto_setup = 0
```

手動でセットアップするには：

```vim
:Vim9LspSetup
```

### サーバーのインストール/更新

```vim
:Vim9LspInstall
```

### ステータス確認

```vim
:Vim9LspStatus
```

## 設定オプション

### サーバーのインストールパス

デフォルト: `~/.vim/pack/vpm/start/vim9-lsp-server`

```vim
let g:vim9_lsp_server_path = '~/path/to/vim9-lsp-server'
```

### 自動セットアップの無効化

```vim
let g:vim9_lsp_auto_setup = 0
```

### キーマッピングの無効化

```vim
let g:vim9_lsp_enable_mappings = 0
```

## デフォルトキーマッピング

Vimファイル（`.vim`）で以下のキーマッピングが有効になります：

| キー | 機能 |
|------|------|
| `gd` | 定義へジャンプ |
| `K` | ホバー情報表示 |
| `<leader>rn` | リネーム |
| `<leader>f` | フォーマット |
| `gr` | 参照箇所を表示 |

## 仕組み

```
┌─────────────────┐
│   Vimエディタ    │
│  (LSPクライアント) │
└────────┬────────┘
         │ LSP Protocol
         │
┌────────▼────────┐
│ vim9-lsp-server │
│  (Node.js)      │
└─────────────────┘
```

1. **プラグイン初期化** (`plugin/vim9-lsp.vim`)
   - VimEnter時にセットアップを自動実行

2. **サーバー検出** (`autoload/vim9lsp.vim`)
   - `~/.vim/pack/vpm/start/vim9-lsp-server/out/server.js` を検索
   - 見つからない場合は警告を表示

3. **LSPクライアント選択**
   - Vim 9.1+の組み込みLSPを優先的に使用
   - 利用不可の場合、vim-lspにフォールバック

4. **ファイルタイプ設定** (`after/ftplugin/vim.vim`)
   - `.vim`ファイルでLSP機能とキーマッピングを有効化

## トラブルシューティング

### サーバーが見つからない

```vim
:Vim9LspInstall
```

を実行してサーバーをインストールしてください。

### Node.jsが見つからない

Node.js 18.0以上がインストールされ、PATHに含まれていることを確認してください：

```bash
node --version
```

### LSPクライアントが見つからない

以下のいずれかをインストールしてください：

- Vim 9.1以上にアップグレード
- [vim-lsp](https://github.com/prabirshrestha/vim-lsp)をインストール

## 開発

### ビルド

```bash
make build
```

### テスト

```bash
make test
```

### クリーンアップ

```bash
make clean
```

## ライセンス

MIT License

## 関連プロジェクト

- [vim9-lsp-server](https://github.com/ue555/vim9-lsp-server) - Vim9 Script用LSPサーバー
- [vim-lsp](https://github.com/prabirshrestha/vim-lsp) - VimのLSPクライアント実装
- [VPM](https://github.com/ue555/vpm) - Vimプラグインマネージャー

## 貢献

Issue、Pull Requestを歓迎します！
