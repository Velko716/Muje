#!/bin/bash

set -e  # 에러 시 즉시 종료

echo "CI 스크립트 시작"
echo "현재 시간: $(date)"
echo "작업 디렉토리: $(pwd)"

# SRCROOT 확인 및 설정
if [ -z "${SRCROOT}" ]; then
    SRCROOT=$(pwd)
fi
echo "SRCROOT: ${SRCROOT}"

# 환경변수 존재 확인
if [ -z "$GOOGLE_SERVICE_INFO" ]; then
    echo "오류: GOOGLE_SERVICE_INFO 환경변수가 설정되지 않았습니다"
    echo "Xcode Cloud Settings에서 환경변수를 확인하세요"
    exit 1
fi

echo "환경변수 확인됨 (길이: ${#GOOGLE_SERVICE_INFO} 문자)"

# 타겟 디렉토리 및 파일 경로
TARGET_DIR="${SRCROOT}/Muje/Service"
TARGET_FILE="${TARGET_DIR}/GoogleService-Info.plist"

echo "타겟 경로: ${TARGET_FILE}"

# 디렉토리 생성
mkdir -p "${TARGET_DIR}"

# base64 디코딩
echo "Firebase 설정 파일 생성 중..."
if echo "$GOOGLE_SERVICE_INFO" | base64 --decode > "${TARGET_FILE}" 2>/dev/null; then
    echo "디코딩 성공"
elif echo "$GOOGLE_SERVICE_INFO" | base64 -d > "${TARGET_FILE}" 2>/dev/null; then
    echo "대안 방식으로 디코딩 성공"
else
    echo "오류: base64 디코딩 실패"
    exit 1
fi

# 파일 검증
if [ ! -f "${TARGET_FILE}" ]; then
    echo "오류: 파일이 생성되지 않았습니다"
    exit 1
fi

FILE_SIZE=$(wc -c < "${TARGET_FILE}")
echo "파일 생성 완료 (크기: ${FILE_SIZE} bytes)"

# 내용 검증
if grep -q "<?xml" "${TARGET_FILE}" && grep -q "PROJECT_ID" "${TARGET_FILE}"; then
    echo "Firebase 설정 파일 검증 완료"
else
    echo "경고: 파일 형식이 올바르지 않을 수 있습니다"
    head -3 "${TARGET_FILE}"
    exit 1
fi

echo "CI 스크립트 완료"
