#!/bin/bash

API_BASE=$(echo ${AIVIS_SPEECH__API_BASE:-"http://localhost:10101"})
SPEAKER_ID=$(echo ${AIVIS_SPEECH__SPEAKER_ID:-"888753760"})  # デフォルトのスピーカーID

mkdir -p /tmp/claude-aivis-voiceover

LOCKDIR="/tmp/claude-aivis-voiceover/lock"

# 引数チェック
if [ $# -eq 0 ]; then
    echo "使用法: $0 <喋らせたいテキスト> [スピーカーID]"
    echo "例: $0 'こんにちは、世界' 0"
    exit 1
fi

TEXT="$1"
if [ $# -ge 2 ]; then
    SPEAKER_ID="$2"
fi

# 一時ファイル
TEMP_TEXT="/tmp/claude-aivis-voiceover/$$_text.txt"
TEMP_QUERY="/tmp/claude-aivis-voiceover/$$_query.json"
TEMP_AUDIO="/tmp/claude-aivis-voiceover/$$_audio.wav"

# クリーンアップ関数
cleanup() {
    rm -f "$TEMP_TEXT" "$TEMP_QUERY" "$TEMP_AUDIO"
    rmdir "$LOCKDIR" 2>/dev/null
}
trap cleanup EXIT

echo "$TEXT" > "$TEMP_TEXT"

# 1. 音声クエリを生成
echo "音声クエリを生成中..."
curl -s -X POST \
    "$API_BASE/audio_query?speaker=$SPEAKER_ID" \
    --get --data-urlencode text@"$TEMP_TEXT" > "$TEMP_QUERY"

if [ $? -ne 0 ]; then
    echo "エラー: 音声クエリの生成に失敗しました"
    exit 1
fi

# 2. 音声を合成
echo "音声を合成中..."
curl -s -X POST \
    "$API_BASE/synthesis?speaker=$SPEAKER_ID" \
    -H "Content-Type: application/json" \
    -d @"$TEMP_QUERY" > "$TEMP_AUDIO"

if [ $? -ne 0 ]; then
    echo "エラー: 音声の合成に失敗しました"
    exit 1
fi

# ロックディレクトリの作成を試みる
while ! mkdir "$LOCKDIR" 2>/dev/null; do
    echo "待機中..."
    sleep 1
done

# 3. 音声を再生
echo "音声を再生中..."
if command -v afplay &> /dev/null; then
    afplay "$TEMP_AUDIO"
elif command -v aplay &> /dev/null; then
    aplay -q "$TEMP_AUDIO"
elif command -v ffplay &> /dev/null; then
    ffplay -nodisp -autoexit -loglevel quiet "$TEMP_AUDIO"
elif command -v sox &> /dev/null; then
    play -q "$TEMP_AUDIO"
else
    echo "エラー: 音声再生コマンドが見つかりません (afplay, aplay, ffplay, sox)"
    exit 1
fi

exit 0