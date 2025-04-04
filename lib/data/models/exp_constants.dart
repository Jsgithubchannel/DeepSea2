/// 경험치 관련 상수
class ExpConstants {
  // 각 활동별 경험치
  static const int DAILY_QUIZ_CORRECT = 50;      // 일일 퀴즈 정답 경험치 (감소됨)
  static const int EMERGENCY_QUIZ_CORRECT = 120; // 돌발 퀴즈 정답 경험치 (약간 감소됨)
  static const int JELLYFISH_DISCOVER = 300;     // 해파리 발견 경험치 (증가됨)
  static const int JELLYFISH_REPORT = 200;       // 해파리 발견 후 제보 경험치 (증가됨)

  // 레벨별 칭호
  static const Map<int, String> LEVEL_TITLES = {
    1: '초보 감식반',
    2: '견습 감식반',
    3: '현장 감식반', 
    4: '선임 연구원',
    5: '해파리 박사',
    6: '해파리 명예박사',
    7: '해양생물학자',
    8: '국제 해파리 전문가',
  };

  // 레벨별 필요 경험치 (수정된 계산 방식)
  static int requiredExpForLevel(int level) {
    // 레벨이 올라갈수록 필요 경험치가 기하급수적으로 증가
    if (level <= 3) {
      return level * 200; // 저레벨은 비교적 쉽게 달성 가능
    } else if (level <= 5) {
      return level * 300; // 중간 레벨은 약간 어려워짐
    } else {
      return level * 500; // 고레벨은 상당히 많은 경험치 필요
    }
  }

  // 총 필요 경험치 (해당 레벨까지 필요한 총 경험치)
  static int totalRequiredExpForLevel(int level) {
    int total = 0;
    for (int i = 1; i < level; i++) {
      total += requiredExpForLevel(i);
    }
    return total;
  }
} 