#!/bin/bash

echo "🚀🚀🚀 CI 스크립트 실행 시작! 🚀🚀🚀"
echo "현재 시간: $(date)"
echo "현재 위치: $(pwd)"
echo "사용자: $(whoami)"

# 현재 폴더 내용 확인
echo "📁 현재 폴더 내용:"
ls -la

echo "🔍 환경변수 길이 확인:"
if [ -z "$GOOGLE_SERVICE_INFO" ]; then
    echo "❌ GOOGLE_SERVICE_INFO 환경변수가 없습니다!"
    echo "🔍 사용 가능한 환경변수들:"
    env | grep -i google || echo "Google 관련 환경변수 없음"
    exit 1
else
    echo "✅ GOOGLE_SERVICE_INFO 환경변수 존재"
    echo "📏 길이: ${#GOOGLE_SERVICE_INFO} 문자"
    echo "🔤 첫 10글자: ${GOOGLE_SERVICE_INFO:0:10}..."
    echo "🔤 끝 10글자: ...${GOOGLE_SERVICE_INFO: -10}"
fi

echo "🚀 Firebase 설정 파일 복원 시작..."

# base64 디코딩 시도
echo "🔓 base64 디코딩 중..."
if echo "$GOOGLE_SERVICE_INFO" | base64 --decode > GoogleService-Info.plist 2>/dev/null; then
    echo "✅ base64 디코딩 성공!"
else
    echo "❌ base64 디코딩 실패!"
    echo "🔄 다른 방법 시도 중..."
    
    # macOS와 Linux base64 차이 때문에 다른 옵션 시도
    if echo "$GOOGLE_SERVICE_INFO" | base64 -d > GoogleService-Info.plist 2>/dev/null; then
        echo "✅ base64 -d 옵션으로 성공!"
    else
        echo "❌ 모든 디코딩 방법 실패"
        exit 1
    fi
fi

# 생성된 파일 확인
if [ -f "GoogleService-Info.plist" ]; then
    echo "✅ GoogleService-Info.plist 생성 완료!"
    echo "📏 파일 크기: $(wc -c < GoogleService-Info.plist) bytes"
    echo "📋 파일 첫 줄:"
    head -1 GoogleService-Info.plist
    
    # plist 파일이 유효한지 간단 체크
    if grep -q "<?xml" GoogleService-Info.plist; then
        echo "✅ 유효한 XML 파일 형식"
    else
        echo "⚠️  XML 형식이 아닐 수 있음"
    fi
    
    if grep -q "PROJECT_ID" GoogleService-Info.plist; then
        echo "✅ Firebase 설정 파일로 보임"
    else
        echo "⚠️  Firebase 설정 파일이 아닐 수 있음"
    fi
else
    echo "❌ GoogleService-Info.plist 파일 생성 실패"
    exit 1
fi

echo "📁 최종 파일 목록:"
ls -la *.plist 2>/dev/null || echo "plist 파일이 없습니다"

echo "🎯 CI 스크립트 완료!"
echo "🚀🚀🚀 CI 스크립트 실행 종료! 🚀🚀🚀"
