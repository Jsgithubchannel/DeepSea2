import 'package:jellyfish_test/data/models/jellyfish_model.dart';

/// 해파리 초기 데이터
/// 도감에 표시될 기본 해파리 정보를 담고 있습니다.
class JellyfishData {
  /// 해파리 목록
  static final List<Jellyfish> jellyfishList = [
    Jellyfish(
      id: 'jf001',
      name: '문어해파리',
      scientificName: 'Aurelia aurita',
      description: '문어해파리는 전 세계 온대 및 열대 바다에서 발견되는 가장 흔한 해파리 중 하나입니다. '
          '반투명한 우산 모양의 몸체와 4개의 원형 생식선이 특징입니다. '
          '독성이 없거나 아주 약해 인간에게 거의 위험하지 않습니다. '
          '크기는 보통 25-40cm 정도이며, 수명은 약 6개월에서 2년입니다.',
      shortDescription: '전 세계 바다에서 가장 흔하게 볼 수 있는 해파리',
      funFact: '문어해파리는 심장이 없이도 살 수 있으며, 산소는 몸 표면을 통해 직접 흡수합니다.',
      dangerLevel: DangerLevel.safe,
      imageUrl: 'assets/images/jellyfish/moon_jellyfish.png',
      colors: ['투명', '흰색', '파랑'],
      habitats: ['온대 바다', '열대 바다', '연안'],
      size: '25-40cm',
      isDiscovered: true,
      discoveredAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Jellyfish(
      id: 'jf002',
      name: '노무라입깃해파리',
      scientificName: 'Nemopilema nomurai',
      description: '노무라입깃해파리는 세계에서 가장 큰 해파리 중 하나로, 지름이 2m, 무게가 200kg까지 자랄 수 있습니다. '
          '동아시아 해역, 특히 한국, 중국, 일본 주변 바다에서 대규모로 발생하며 어업에 큰 피해를 줍니다. '
          '독성이 있어 접촉 시 화상과 통증을 유발할 수 있습니다.',
      shortDescription: '동아시아에서 발견되는 거대한 해파리',
      funFact: '노무라입깃해파리는 한 번에 수십억 개의 알을 낳을 수 있으며, 이는 바다 생태계에 큰 영향을 미칩니다.',
      dangerLevel: DangerLevel.moderate,
      imageUrl: 'assets/images/jellyfish/nomuras_jellyfish.png',
      colors: ['갈색', '노란색'],
      habitats: ['동아시아 해역', '한국 연안', '일본 연안'],
      size: '최대 2m',
      isDiscovered: false,
    ),
    Jellyfish(
      id: 'jf003',
      name: '상자해파리',
      scientificName: 'Chironex fleckeri',
      description: '상자해파리는 세계에서 가장 독성이 강한 해양 생물 중 하나로 알려져 있습니다. '
          '호주 북부 해안과 인도-태평양 지역에 서식하며, 특히 여름철에 많이 발견됩니다. '
          '독성 촉수에 쏘이면 극심한 통증, 심장마비, 심지어 사망까지 초래할 수 있어 매우 위험합니다.',
      shortDescription: '세계에서 가장 독성이 강한 해파리',
      funFact: '상자해파리는 24개의 눈을 가지고 있으며, 장애물을 피해 헤엄칠 수 있는 놀라운 시각 능력을 가지고 있습니다.',
      dangerLevel: DangerLevel.deadly,
      imageUrl: 'assets/images/jellyfish/box_jellyfish.png',
      colors: ['투명', '파랑'],
      habitats: ['호주 북부', '인도-태평양', '열대 바다'],
      size: '15-25cm',
      isDiscovered: false,
    ),
    Jellyfish(
      id: 'jf004',
      name: '라이온스메인해파리',
      scientificName: 'Cyanea capillata',
      description: '라이온스메인해파리는 세계에서 가장 큰 해파리 종으로, 촉수 길이가 30m 이상 자랄 수 있습니다. '
          '북극해, 북대서양, 북태평양의 차가운 물에 서식합니다. '
          '독성이 있어 쏘이면 심한 통증과 물집이 발생할 수 있지만, 대부분 사망에 이르지는 않습니다.',
      shortDescription: '세계에서 가장 긴 촉수를 가진 해파리',
      funFact: '라이온스메인해파리의 외관은 사자의 갈기처럼 보이며, 이로 인해 이름이 붙여졌습니다.',
      dangerLevel: DangerLevel.severe,
      imageUrl: 'assets/images/jellyfish/lions_mane_jellyfish.png',
      colors: ['빨강', '주황', '노랑'],
      habitats: ['북극해', '북대서양', '북태평양'],
      size: '최대 30m (촉수 포함)',
      isDiscovered: false,
    ),
    Jellyfish(
      id: 'jf005',
      name: '푸른단추해파리',
      scientificName: 'Porpita porpita',
      description: '푸른단추해파리는 원형의 푸른 부유생물로, 실제로는 해파리가 아닌 히드라충류의 군체입니다. '
          '열대 및 아열대 바다의 표면에 떠다니며 살아갑니다. '
          '독성은 약해 인간에게 거의 해롭지 않지만, 약간의 자극을 줄 수 있습니다.',
      shortDescription: '아름다운 푸른색의 부유생물',
      funFact: '푸른단추해파리는 실제로 단일 생물이 아니라 여러 개체가 모여 사는 군체입니다.',
      dangerLevel: DangerLevel.mild,
      imageUrl: 'assets/images/jellyfish/blue_button.png',
      colors: ['파랑', '노랑'],
      habitats: ['열대 바다', '아열대 바다', '표층'],
      size: '1-3cm',
      isDiscovered: true,
      discoveredAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Jellyfish(
      id: 'jf006',
      name: '커튼원양해파리',
      scientificName: 'Chrysaora melanaster',
      description: '커튼원양해파리는 북태평양에 서식하는 대형 해파리로, 우산 지름이 60cm까지 자랄 수 있습니다. '
          '독특한 줄무늬 패턴과 길고 풍성한 촉수가 특징입니다. '
          '독성이 있어 쏘이면 통증과 발진을 유발할 수 있지만, 생명을 위협하지는 않습니다.',
      shortDescription: '북태평양의 아름다운 줄무늬 해파리',
      funFact: '이 해파리는 먹이를 찾을 때 물을 펄싱하여 먹이를 촉수 쪽으로 밀어넣는 능동적인 사냥 방식을 사용합니다.',
      dangerLevel: DangerLevel.moderate,
      imageUrl: 'assets/images/jellyfish/sea_nettle.png',
      colors: ['갈색', '노랑', '빨강'],
      habitats: ['북태평양', '연안', '외해'],
      size: '45-60cm',
      isDiscovered: false,
    ),
  ];
  
  /// 모든 해파리 조회
  static List<Jellyfish> getAllJellyfish() {
    return jellyfishList;
  }
  
  /// 발견된 해파리 조회
  static List<Jellyfish> getDiscoveredJellyfish() {
    return jellyfishList.where((jellyfish) => jellyfish.isDiscovered).toList();
  }
  
  /// 발견되지 않은 해파리 조회
  static List<Jellyfish> getUndiscoveredJellyfish() {
    return jellyfishList.where((jellyfish) => !jellyfish.isDiscovered).toList();
  }
  
  /// ID로 해파리 조회
  static Jellyfish? getJellyfishById(String id) {
    try {
      return jellyfishList.firstWhere((jellyfish) => jellyfish.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// 발견율 계산
  static double getDiscoveryRate() {
    if (jellyfishList.isEmpty) return 0.0;
    int discoveredCount = jellyfishList.where((jellyfish) => jellyfish.isDiscovered).length;
    return (discoveredCount / jellyfishList.length) * 100;
  }
} 