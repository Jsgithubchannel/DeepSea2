import 'package:hive/hive.dart';

part 'user_model.g.dart';

/// 유저 모델
@HiveType(typeId: 2)
class User {
  /// 고유 ID
  @HiveField(0)
  final String id;
  
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
  
  User({
    required this.id,
    required this.name,
    required this.exp,
    required this.level,
    required this.discoveredJellyfishCount,
    required this.badgeCount,
    required this.completedQuizIds,
    this.lastLoginDate,
    required this.createdAt,
  });
  
  /// 레벨업에 필요한 경험치
  int get expToNextLevel => level * 100;
  
  /// 다음 레벨까지 남은 경험치
  int get remainingExp => expToNextLevel - (exp % expToNextLevel);
  
  /// 현재 레벨 진행도 (0.0 ~ 1.0)
  double get levelProgress {
    return (exp % expToNextLevel) / expToNextLevel;
  }
  
  /// 사용자 레벨에 해당하는 칭호 반환
  String get title {
    switch (level) {
      case 1:
        return '초보 감식반';
      case 2:
        return '견습 감식반';
      case 3:
        return '현장 감식반';
      case 4:
        return '선임 연구원';
      case 5:
        return '해파리 박사';
      default:
        return '초보 감식반';
    }
  }
  
  /// 경험치 추가 및 레벨업 처리
  User addExp(int amount) {
    int newExp = exp + amount;
    int newLevel = level;
    
    // 레벨업 계산
    while (newExp >= newLevel * 100) {
      newExp -= newLevel * 100;
      newLevel++;
    }
    
    return copyWith(
      exp: newExp,
      level: newLevel,
    );
  }
  
  /// 객체 복제
  User copyWith({
    String? id,
    String? name,
    int? exp,
    int? level,
    int? discoveredJellyfishCount,
    int? badgeCount,
    List<int>? completedQuizIds,
    DateTime? lastLoginDate,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      exp: exp ?? this.exp,
      level: level ?? this.level,
      discoveredJellyfishCount: discoveredJellyfishCount ?? this.discoveredJellyfishCount,
      badgeCount: badgeCount ?? this.badgeCount,
      completedQuizIds: completedQuizIds ?? this.completedQuizIds,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  /// 기본 유저 생성
  factory User.defaultUser() {
    return User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '탐험가',
      exp: 0,
      level: 1,
      discoveredJellyfishCount: 0,
      badgeCount: 0,
      completedQuizIds: [],
      lastLoginDate: DateTime.now(),
      createdAt: DateTime.now(),
    );
  }
  
  /// JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'exp': exp,
      'level': level,
      'discoveredJellyfishCount': discoveredJellyfishCount,
      'badgeCount': badgeCount,
      'completedQuizIds': completedQuizIds,
      'lastLoginDate': lastLoginDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  /// JSON으로부터 객체 생성
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      exp: json['exp'] as int,
      level: json['level'] as int,
      discoveredJellyfishCount: json['discoveredJellyfishCount'] as int,
      badgeCount: json['badgeCount'] as int,
      completedQuizIds: List<int>.from(json['completedQuizIds'] as List),
      lastLoginDate: json['lastLoginDate'] != null
          ? DateTime.parse(json['lastLoginDate'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
} 