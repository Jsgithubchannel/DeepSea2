import 'package:hive/hive.dart';
import 'package:jellyfish_test/data/models/exp_constants.dart';

part 'user_model.g.dart';

/// 유저 모델
@HiveType(typeId: 2)
class User {
  /// 고유 ID
  @HiveField(0) // 기존 id 필드의 인덱스 재사용 또는 새 인덱스 할당 (여기서는 0 재사용)
  final String? uid;

  /// 이름
  @HiveField(1)
  final String name;

  /// 경험치
  @HiveField(2)
  final int exp;

  /// 레벨
  @HiveField(3)
  final int level;

  /// 발견한 해파리 수
  @HiveField(4)
  final int discoveredJellyfishCount;

  /// 획득한 배지 수
  @HiveField(5)
  final int badgeCount;

  /// 완료한 퀴즈 ID 목록
  @HiveField(6)
  final List<int> completedQuizIds;

  /// 마지막 로그인 날짜
  @HiveField(7)
  final DateTime? lastLoginDate;

  /// 생성일
  @HiveField(8)
  final DateTime createdAt;

  /// 제보한 해파리 수
  @HiveField(9)
  final int reportedJellyfishCount;

  /// 이메일 (추가)
  @HiveField(10) // 새 인덱스 할당
  final String? email;

  User({
    this.uid,
    required this.name,
    this.email,
    required this.exp,
    required this.level,
    required this.discoveredJellyfishCount,
    this.reportedJellyfishCount = 0,
    required this.badgeCount,
    required this.completedQuizIds,
    this.lastLoginDate,
    required this.createdAt,
  });

  /// 레벨업에 필요한 경험치
  int get expToNextLevel => ExpConstants.requiredExpForLevel(level);

  /// 다음 레벨까지 남은 경험치
  int get remainingExp => expToNextLevel - (exp % expToNextLevel);

  /// 현재 레벨 진행도 (0.0 ~ 1.0)
  double get levelProgress {
    return (exp % expToNextLevel) / expToNextLevel;
  }

  /// 사용자 레벨에 해당하는 칭호 반환
  String get title {
    return ExpConstants.LEVEL_TITLES[level] ?? ExpConstants.LEVEL_TITLES[1]!;
  }

  /// 경험치 추가 및 레벨업 처리
  User addExp(int amount) {
    int newExp = exp + amount;
    int newLevel = level;

    // 현재 레벨에 필요한 경험치
    int requiredExp = ExpConstants.requiredExpForLevel(newLevel);

    // 레벨업 계산 - 새 로직
    while (newExp >= requiredExp) {
      // 현재 레벨업에 필요한 경험치를 소비
      newExp -= requiredExp;

      // 레벨 증가
      newLevel++;

      // 다음 레벨에 필요한 경험치 업데이트
      requiredExp = ExpConstants.requiredExpForLevel(newLevel);
    }

    return copyWith(exp: newExp, level: newLevel);
  }

  /// 객체 복제
  User copyWith({
    String? uid,
    String? name,
    String? email,
    int? exp,
    int? level,
    int? discoveredJellyfishCount,
    int? reportedJellyfishCount,
    int? badgeCount,
    List<int>? completedQuizIds,
    DateTime? lastLoginDate,
    DateTime? createdAt,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      exp: exp ?? this.exp,
      level: level ?? this.level,
      discoveredJellyfishCount:
          discoveredJellyfishCount ?? this.discoveredJellyfishCount,
      reportedJellyfishCount:
          reportedJellyfishCount ?? this.reportedJellyfishCount,
      badgeCount: badgeCount ?? this.badgeCount,
      completedQuizIds: completedQuizIds ?? this.completedQuizIds,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// 기본 유저 생성
  factory User.defaultUser() {
    return User(
      uid: null,
      name: '탐험가',
      email: null,
      exp: 0,
      level: 1,
      discoveredJellyfishCount: 0,
      reportedJellyfishCount: 0,
      badgeCount: 0,
      completedQuizIds: [],
      lastLoginDate: DateTime.now(),
      createdAt: DateTime.now(),
    );
  }

  /// JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'exp': exp,
      'level': level,
      'discoveredJellyfishCount': discoveredJellyfishCount,
      'reportedJellyfishCount': reportedJellyfishCount,
      'badgeCount': badgeCount,
      'completedQuizIds': completedQuizIds,
      'lastLoginDate': lastLoginDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// JSON으로부터 객체 생성
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] as String,
      name: json['name'] as String ?? '탐험가',
      email: json['email'] as String?,
      exp: json['exp'] as int ?? 0,
      level: json['level'] as int? ?? 1,
      discoveredJellyfishCount: json['discoveredJellyfishCount'] as int ?? 0,
      reportedJellyfishCount: json['reportedJellyfishCount'] as int? ?? 0,
      badgeCount: json['badgeCount'] as int? ?? 0,
      completedQuizIds:
          json['completedQuizIds'] != null
              ? List<int>.from(json['completedQuizIds'] as List)
              : [], // null 체크 추가
      lastLoginDate:
          json['lastLoginDate'] != null
              ? DateTime.tryParse(
                json['lastLoginDate'] as String,
              ) // tryParse 사용
              : null,
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(), // null일 경우 현재 시간
    );
  }
}
