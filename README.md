# 🪼 해파리 감식반 by DeepSea2

AI 해파리 분류와 실시간 해양 안전 알림을 지원하는 **게임형 시민과학 + 안전 정보 + 해양교육 앱**

---

## 📱 앱 소개

**해파리를 발견하고, 경험치를 쌓고, 바다를 지켜라!**  
해파리 감식반은 실시간 AI 분류, 안전 정보 제공, 업적 시스템과 리워드를 통해 해양 생물 보호와 시민 참여를 유도하는 모바일 애플리케이션입니다.

### 데모 영상
(2배속 시청 추천드립니다.)
https://youtu.be/SxcSi_jrWAU?feature=shared

<img width="1148" alt="스크린샷 2025-04-07 오후 5 28 16" src="https://github.com/user-attachments/assets/149a30dd-1cc4-48c6-9a39-1941b36547ba" />
<img width="1143" alt="스크린샷 2025-04-07 오후 5 28 28" src="https://github.com/user-attachments/assets/35c27757-a781-4da7-89ab-f94890e3d675" />


---

## 🔑 주요 기능

### 1. 🪼 해파리 AI 분류 + 신고 기능
- 카메라로 해파리 촬영 시 실시간 AI 분류 (6종: Moon, Barrel, Blue, Compass, Lion’s Mane, Mauve Stinger)
- 분류된 해파리의 **위험도 안내**
- "신고하기" 버튼 클릭 시, 위치/시간/사진 등 메타데이터 포함 자동 전송

### 2. 🧾 업적 시스템 ("해파리 업적도감")
- 해파리 발견 및 신고 시 다양한 칭호 획득  
  예: `초보 해파리 연구자`, `해파리 대책반 예비요원`, `실전 대책반` 등

### 3. 🎁 리워드 시스템
- 실물 굿즈: 무드등, 스티커, 도감북 등
- 디지털 아이템: 프로필 꾸미기, 뱃지, 배경음, 해파리 이모티콘 등

### 4. 🧠 해양 생물학 미니게임
- 퀴즈로 해파리 지식 테스트 & 레벨업

### 5. 🌍 실시간 해파리 지도
- 사용자 신고 기반 해파리 분포 시각화  
  “현재 이 해변엔 Compass Jellyfish가 출몰 중입니다. 주의하세요!”

---

## 🧠 AI 모델 소개

### ✅ MobileNet 기반 해파리 분류 모델
- 전이학습 기반 MobileNet 사용
- 평균 정확도 **98%**
- 모바일 최적화 (양자화 모델: 0.85MB)

## 🧩 아키텍처 구성

**Flutter 앱 구조 다이어그램**

- 사용자 → Flutter Pages → Widgets/Screens
- Presentation & Core Controller → 모델 업데이트 및 데이터 흐름 제어
- Firebase 인증, 식별 연동
- AI 모델 inference → 위험도 분석 → 신고 데이터 전송
  
![ChatGPT Image Apr 7, 2025, 12_43_23 PM](https://github.com/user-attachments/assets/b216d767-cc70-4b3c-bffe-8c759843c661)

---

## 📦 기술 스택

- **Frontend**: Flutter
- **Backend / AI 연동**: Firebase Auth, Firestore
- **AI 모델**: TensorFlow, MobileNetV2, EfficientNetB0
- **데이터 증강**: 회전, 색상 변화, 수중 환경 시뮬레이션
- **기타**: TFLite 양자화, K-fold cross-validation

---

## 📁 프로젝트 구조 요약

```
├── lib/
│   ├── pages/                # Flutter 페이지 구성
│   ├── widgets/              # 공통 위젯
│   ├── screens/              # UI 화면별 구성
│   ├── controllers/          # Presentation / Core 컨트롤러
│   └── services/             # Auth, Identification, Repository
├── assets/
│   └── images/               # 해파리 샘플 이미지
├── model/                    # TFLite 모델 파일
├── diagram.png               # 앱 아키텍처 다이어그램
└── README.md
```

---

## 🌱 향후 계획

- 사용자 신고 기반 위험도 예측 AI 고도화
- 해양기관 연계 실시간 대응 시스템

---

## 해파리 감식반 1.0 – 프로젝트 회고
목표: 해파리 이미지 분류 + 해양 안전·교육 앱 개발
성과: EfficientNetB0 기반 모델 정확도 97%+, Flutter 앱에 실시간 분류·신고·업적 시스템 구현
잘한 점: 빠른 역할 분배, 적극적 AI 도구 활용, 실시간 소통
아쉬운 점: 시간 부족으로 모델 다양성 부족
기술 도전: 모델 경량화, 실시간 처리 + UI 통합
배운 점: 프롬프트 설계 역량의 중요성, 직관적인 UX의 가치
다음 목표: 더 다양한 해양 생물 인식 확장, UX 개선, AI 지속 학습 설계

