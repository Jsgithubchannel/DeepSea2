import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jellyfish_test/data/models/jellyfish_model.dart';
import 'package:jellyfish_test/data/models/jellyfish_data.dart';

/// 해파리 데이터 관리를 위한 리포지토리 클래스
class JellyfishRepository extends GetxService {
  static const _jellyfishKey = 'jellyfish_data';
  
  late SharedPreferences _prefs;
  late RxList<Jellyfish> _jellyfishList;
  
  /// 해파리 리스트 Rx
  RxList<Jellyfish> get jellyfishList => _jellyfishList;
  
  /// 해파리 데이터 초기화
  Future<JellyfishRepository> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadJellyfish();
    return this;
  }
  
  /// 저장된 해파리 데이터를 불러옵니다.
  Future<void> _loadJellyfish() async {
    final jellyfishJson = _prefs.getString(_jellyfishKey);
    
    if (jellyfishJson != null) {
      try {
        final jellyfishData = jsonDecode(jellyfishJson) as List;
        final jellyfish = jellyfishData
            .map((item) => Jellyfish.fromJson(item as Map<String, dynamic>))
            .toList();
        _jellyfishList = jellyfish.obs;
      } catch (e) {
        // 오류 발생 시 기본 해파리 데이터로 초기화
        _jellyfishList = JellyfishData.getAllJellyfish().obs;
        await _saveJellyfish();
      }
    } else {
      // 저장된 데이터가 없으면 기본 해파리 데이터로 초기화
      _jellyfishList = JellyfishData.getAllJellyfish().obs;
      await _saveJellyfish();
    }
  }
  
  /// 해파리 데이터를 저장합니다.
  Future<void> _saveJellyfish() async {
    final jellyfishJson = jsonEncode(
      _jellyfishList.map((jellyfish) => jellyfish.toJson()).toList(),
    );
    await _prefs.setString(_jellyfishKey, jellyfishJson);
  }
  
  /// 해파리를 발견 처리합니다.
  Future<Jellyfish?> discoverJellyfish(String id) async {
    final index = _jellyfishList.indexWhere((jellyfish) => jellyfish.id == id);
    
    if (index != -1) {
      final jellyfish = _jellyfishList[index];
      
      if (!jellyfish.isDiscovered) {
        // 해파리를 발견 처리
        jellyfish.discover();
        // 레퍼런스가 변경되지 않으므로 리스트 업데이트를 위해 갱신합니다.
        _jellyfishList.refresh();
        await _saveJellyfish();
        return _jellyfishList[index];
      }
      
      return jellyfish;
    }
    
    return null;
  }
  
  /// 모든 해파리 정보를 반환합니다.
  List<Jellyfish> getAllJellyfish() {
    return _jellyfishList.toList();
  }
  
  /// 발견된 해파리만 반환합니다.
  List<Jellyfish> getDiscoveredJellyfish() {
    return _jellyfishList
        .where((jellyfish) => jellyfish.isDiscovered)
        .toList();
  }
  
  /// 미발견 해파리만 반환합니다.
  List<Jellyfish> getUndiscoveredJellyfish() {
    return _jellyfishList
        .where((jellyfish) => !jellyfish.isDiscovered)
        .toList();
  }
  
  /// ID로 해파리를 찾습니다.
  Jellyfish? getJellyfishById(String id) {
    try {
      return _jellyfishList.firstWhere((jellyfish) => jellyfish.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// 해파리 발견율을 계산합니다. (0.0 ~ 1.0)
  double getDiscoveryRate() {
    final discovered = getDiscoveredJellyfish().length;
    final total = _jellyfishList.length;
    
    return discovered / total;
  }
  
  /// 해파리 데이터를 초기화합니다. (개발용)
  Future<void> resetJellyfishData() async {
    _jellyfishList = JellyfishData.getAllJellyfish().obs;
    await _saveJellyfish();
  }
} 