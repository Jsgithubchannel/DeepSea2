import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'jellyfish_model.g.dart';

/// 해파리 위험도
@HiveType(typeId: 1)
enum DangerLevel {
  /// 안전
  @HiveField(0)
  safe,
  
  /// 경미
  @HiveField(1)
  mild,
  
  /// 보통
  @HiveField(2)
  moderate,
  
  /// 심각
  @HiveField(3)
  severe,
  
  /// 치명적
  @HiveField(4)
  deadly
}

/// 해파리 모델
@HiveType(typeId: 0)
class Jellyfish {
  /// 고유 ID
  @HiveField(0)
  final String id;
  
  /// 해파리 이름
  @HiveField(1)
  final String name;
  
  /// 해파리 학명
  @HiveField(2)
  final String scientificName;
  
  /// 해파리 설명
  @HiveField(3)
  final String description;
  
  /// 짧은 설명
  @HiveField(4)
  final String shortDescription;
  
  /// 재미있는 사실
  @HiveField(5)
  final String funFact;
  
  /// 위험도
  @HiveField(6)
  final DangerLevel dangerLevel;
  
  /// 이미지 URL
  @HiveField(7)
  final String imageUrl;
  
  /// 해파리 색상 목록
  @HiveField(8)
  final List<String> colors;
  
  /// 서식지 목록
  @HiveField(9)
  final List<String> habitats;
  
  /// 크기 (텍스트 표현)
  @HiveField(10)
  final String size;
  
  /// 발견 여부
  @HiveField(11)
  bool isDiscovered;
  
  /// 발견 시간
  @HiveField(12)
  DateTime? discoveredAt;
  
  Jellyfish({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.description,
    required this.shortDescription,
    required this.funFact,
    required this.dangerLevel,
    required this.imageUrl,
    required this.colors,
    required this.habitats,
    required this.size,
    this.isDiscovered = false,
    this.discoveredAt,
  });
  
  /// 위험도에 따른 색상 반환
  Color get dangerColor {
    switch (dangerLevel) {
      case DangerLevel.safe:
        return Colors.green;
      case DangerLevel.mild:
        return Colors.yellow;
      case DangerLevel.moderate:
        return Colors.orange;
      case DangerLevel.severe:
        return Colors.red;
      case DangerLevel.deadly:
        return Colors.purple;
    }
  }
  
  /// 해파리 발견 처리
  void discover() {
    isDiscovered = true;
    discoveredAt = DateTime.now();
  }
  
  /// JSON 데이터로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scientificName': scientificName,
      'description': description,
      'shortDescription': shortDescription,
      'funFact': funFact,
      'dangerLevel': dangerLevel.index,
      'imageUrl': imageUrl,
      'colors': colors,
      'habitats': habitats,
      'size': size,
      'isDiscovered': isDiscovered,
      'discoveredAt': discoveredAt?.toIso8601String(),
    };
  }
  
  /// JSON 데이터로부터 객체 생성
  factory Jellyfish.fromJson(Map<String, dynamic> json) {
    return Jellyfish(
      id: json['id'] as String,
      name: json['name'] as String,
      scientificName: json['scientificName'] as String,
      description: json['description'] as String,
      shortDescription: json['shortDescription'] as String,
      funFact: json['funFact'] as String,
      dangerLevel: DangerLevel.values[json['dangerLevel'] as int],
      imageUrl: json['imageUrl'] as String,
      colors: List<String>.from(json['colors'] as List),
      habitats: List<String>.from(json['habitats'] as List),
      size: json['size'] as String,
      isDiscovered: json['isDiscovered'] as bool,
      discoveredAt: json['discoveredAt'] != null
          ? DateTime.parse(json['discoveredAt'] as String)
          : null,
    );
  }
} 