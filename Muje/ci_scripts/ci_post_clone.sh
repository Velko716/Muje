#!/bin/bash

echo "🚀 Firebase 설정 파일 복원 시작..."

# Environment Variable에서 base64 디코딩
echo "$GOOGLE_SERVICE_INFO" | base64 --decode > GoogleService-Info.plist

# 성공했는지 확인
if [ -f "GoogleService-Info.plist" ]; then
    echo "✅ GoogleService-Info.plist 생성 완료!"
else
    echo "❌ 파일 생성 실패"
    exit 1
fi

echo "🎯 완료!"
