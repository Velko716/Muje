TARGET_PLIST_PATH="Muje/Service/GoogleService-Info.plist"

mkdir -p "$(dirname "$TARGET_PLIST_PATH")"  # 폴더 없으면 생성

if echo "$GOOGLE_SERVICE_INFO" | base64 --decode > "$TARGET_PLIST_PATH"; then
    echo "✅ Firebase Info.plist 생성 완료: $TARGET_PLIST_PATH"
else
    echo "❌ Firebase Info.plist 생성 실패"
    exit 1
fi
