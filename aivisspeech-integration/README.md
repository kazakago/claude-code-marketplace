# AivisSpeech Integration

ClaudeCodeの返答を[AivisSpeech Engine](https://github.com/Aivis-Project/AivisSpeech-Engine)経由で音声で喋らせるためのプラグインです。  
[femine-tone](https://github.com/kazakago/claude-code-marketplace/tree/main/feminine-tone)と一緒に使うと、っぽい感じになるかもしれません。  
動作確認はMacでしかしてません。  

## Getting Started

1. AivisSpeechをダウンロードして初回起動まで済ませておいてください。  
https://aivis-project.com/

2. ClaudeCode上で本Pluginをインストールして有効化します。  

```sh
/plugin marketplace add kazakago/claude-code-marketplace
/plugin install aivisspeech-integration
```

3. AivisSpeechを終了させたうえで、ClaudeCodeを再起動します。
  
4. 話しかければ喋ってくれるはず

## How it works

セッション開始時にHooksをトリガーにAivisSpeech Engineサーバーを起動させています。  
そのうえでadditionalContextとして返答をサーバーに投げて読み上げさせるコンテキストを一度だけ流し込んでいます。  
再生処理はバックグラウンドで行われるため音声終了を待たずに次の処理へ進みます。  

またAivisSpeechのAPIはVOICEVOX互換であるため、[VOICEBOX ENGINE](https://github.com/VOICEVOX/voicevox_engine)でも環境変数をチューニングすれば動きます。  

音声がうざったくなったらプラグインを無効化するかアンインストールしてください。

## Environmental Variables

#### `AIVIS_SPEECH__PATH`

デフォルト値: `/Applications/AivisSpeech.app/Contents/Resources/AivisSpeech-Engine/run`  

AivisSpeechEngineのパスを指定します。  
MacでAivisSpeechを `/Application` に普通にインストールしただけであれば変更する必要はありません。  

#### `AIVIS_SPEECH__API_BASE`

デフォルト値: `http://localhost:10101`  

AivisSpeechサーバーのURLを指定します。  
普通にAivisSpeechをインストールしただけであれば変更する必要はありません。  

#### `AIVIS_SPEECH__SPEAKER_ID`

デフォルト値: `888753760`  

AivisSpeechのスピーカーのスタイルIDを指定します。  
デフォルト値はAivisSpeechのデフォルトモデルのスタイルIDが入っています。  

## Notice

- 起動したAivisSpeechEngineサーバーは自動的には終了しません。
- Claudeの回答が立て続けに流し込まれても音声は同時に再生されないようにはなってますが、2つ以上詰まると順番は保証されません。
- 返答ごとにClaudeがBash実行するのでそのぶん多少なりともコンテキストを食います。
- AivisSpeechないしVOICEVOXはそれぞれの規約の範疇でご利用ください。
