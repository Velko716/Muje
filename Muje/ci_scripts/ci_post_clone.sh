#!/bin/bash

echo "CI 스크립트 시작"

# 환경변수 확인
if [ -z "$GOOGLE_SERVICE_INFO" ]; then
    echo "환경변수 없음"
    exit 1
fi

echo "환경변수 확인됨"

# 프로젝트 루트로 이동
cd ..

# 디렉토리 생성
mkdir -p Muje/Service

# base64 디코딩 (macOS 호환)
echo "$GOOGLE_SERVICE_INFO" | base64 -D > Muje/Service/GoogleService-Info.plist

# 파일 검증
if [ -f "Muje/Service/GoogleService-Info.plist" ]; then
    echo "파일 생성 성공"
    echo "크기: $(wc -c < Muje/Service/GoogleService-Info.plist) bytes"
else
    echo "파일 생성 실패"
    exit 1
fi

echo "완료"
