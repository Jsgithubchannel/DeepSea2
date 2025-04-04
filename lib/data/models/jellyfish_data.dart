import 'package:jellyfish_test/data/models/jellyfish_model.dart';

/// 해파리 초기 데이터
/// 도감에 표시될 기본 해파리 정보를 담고 있습니다.
/// labels.txt 순서 우선, 나머지는 후순위로 정렬 및 ID 재부여 (2025-04-04 기준)
class JellyfishData {
  /// 해파리 목록
  static final List<Jellyfish> jellyfishList = [
    Jellyfish(
      id: 'compass_jellyfish', // 1. compass_jellyfish
      name: '나침반해파리',
      scientificName: 'Chrysaora hysoscella',
      description:
          '대서양 연안과 지중해에서 발견되며, 우산에 나침반 같은 V자 무늬가 특징입니다. 쏘이면 통증이 있을 수 있습니다. 벨 모양의 우산은 노란색 또는 갈색을 띠며 16개의 V자 모양 갈색 무늬가 있습니다.',
      shortDescription: '나침반 무늬가 있는 아름다운 해파리',
      funFact: '이름은 우산 위의 방사형 갈색 선이 나침반의 눈금처럼 보이기 때문에 붙여졌습니다.',
      dangerLevel: DangerLevel.moderate,
      imageUrl: 'assets/images/jellyfish/compass/compass1.jpg',
      colors: ['노랑', '갈색', '주황'],
      habitats: ['대서양 연안', '지중해', '영국 해안', '아일랜드 해안'],
      size: '15-30cm',
      isDiscovered: false,
    ),
    Jellyfish(
      id: 'lions_mane_jellyfish', // 2. lions_mane_jellyfish
      name: '라이온스메인해파리',
      scientificName: 'Cyanea capillata',
      description:
          '라이온스메인해파리는 세계에서 가장 큰 해파리 종으로, 촉수 길이가 30m 이상 자랄 수 있습니다. '
          '북극해, 북대서양, 북태평양의 차가운 물에 서식합니다. '
          '독성이 있어 쏘이면 심한 통증과 물집이 발생할 수 있지만, 대부분 사망에 이르지는 않습니다.',
      shortDescription: '세계에서 가장 긴 촉수를 가진 해파리',
      funFact: '라이온스메인해파리의 외관은 사자의 갈기처럼 보이며, 이로 인해 이름이 붙여졌습니다.',
      dangerLevel: DangerLevel.severe,
      imageUrl: 'assets/images/jellyfish/lions/lions1.jpg',
      colors: ['빨강', '주황', '노랑'],
      habitats: ['북극해', '북대서양', '북태평양'],
      size: '최대 30m (촉수 포함)',
      isDiscovered: false,
    ),
    Jellyfish(
      id: 'blue_jellyfish', // 3. blue_jellyfish
      name: '푸른해파리',
      scientificName: 'Cyanea lamarckii',
      description:
          '영국과 아일랜드 해안에서 흔히 발견되는 푸른색 해파리입니다. 라이온스메인해파리와 같은 속에 속하지만 크기는 더 작습니다. 독성은 약하지만 쏘이면 통증과 발진을 유발할 수 있습니다.',
      shortDescription: '선명한 푸른색을 띤 해파리',
      funFact: '크기와 색깔은 수온과 먹이에 따라 다양하게 변할 수 있으며, 어린 개체는 노란색이나 갈색을 띠기도 합니다.',
      dangerLevel: DangerLevel.mild,
      imageUrl: 'assets/images/jellyfish/blue/blue1.jpg',
      colors: ['파랑', '보라'],
      habitats: ['북동 대서양', '북해', '영국 해안', '아일랜드 해안'],
      size: '10-30cm',
      isDiscovered: false,
    ),
    Jellyfish(
      id: 'Moon_jellyfish', // 4. Moon_jellyfish
      name: '문어해파리',
      scientificName: 'Aurelia aurita',
      description:
          '문어해파리는 전 세계 온대 및 열대 바다에서 발견되는 가장 흔한 해파리 중 하나입니다. '
          '반투명한 우산 모양의 몸체와 4개의 원형 생식선이 특징입니다. '
          '독성이 없거나 아주 약해 인간에게 거의 위험하지 않습니다. '
          '크기는 보통 25-40cm 정도이며, 수명은 약 6개월에서 2년입니다.',
      shortDescription: '전 세계 바다에서 가장 흔하게 볼 수 있는 해파리',
      funFact: '문어해파리는 심장이 없이도 살 수 있으며, 산소는 몸 표면을 통해 직접 흡수합니다.',
      dangerLevel: DangerLevel.safe,
      imageUrl: 'assets/images/jellyfish/moon/moon1.jpg',
      colors: ['투명', '흰색', '파랑'],
      habitats: ['온대 바다', '열대 바다', '연안'],
      size: '25-40cm',
      isDiscovered: true, // 발견 여부 및 날짜는 기존 데이터 유지
      discoveredAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Jellyfish(
      id: 'mauve_stinger_jellyfish', // 5. mauve_stinger_jellyfish
      name: '보라해파리',
      scientificName: 'Pelagia noctiluca',
      description:
          '지중해와 대서양에서 흔하며, 밤에 생물 발광을 하는 것으로 유명합니다. 쏘이면 매우 고통스럽고 상처가 오래갈 수 있습니다. 대량 발생하여 해변을 폐쇄시키기도 합니다.',
      shortDescription: '야광 능력이 있고 강한 독성의 해파리',
      funFact:
          "'noctiluca'는 라틴어로 '밤의 빛'을 의미하며, 이 해파리의 발광 능력을 나타냅니다. 위협을 느끼면 빛을 내뿜습니다.",
      dangerLevel: DangerLevel.severe,
      imageUrl: 'assets/images/jellyfish/mauve/mauve1.jpg', // 이미지 경로 확인 필요
      colors: ['보라', '분홍', '노랑'],
      habitats: ['지중해', '대서양', '홍해', '외해'],
      size: '3-12cm',
      isDiscovered: false,
    ),
    Jellyfish(
      id: 'barrel_jellyfish', // 6. barrel_jellyfish
      name: '통해파리',
      scientificName: 'Rhizostoma pulmo',
      description:
          '영국 해안을 포함한 북동 대서양과 지중해에서 발견되는 큰 해파리입니다. 몸통이 단단하고 고무 같은 질감을 가지며, 가장자리에 푸른색 또는 보라색 띠가 있습니다. 독성은 약해 거의 해롭지 않습니다.',
      shortDescription: '크고 단단한 몸통을 가진 해파리',
      funFact:
          '다른 해파리와 달리 주변부에 촉수가 없고, 대신 여러 개의 작은 구멍이 있는 8개의 두꺼운 팔을 사용하여 플랑크톤을 걸러 먹습니다.',
      dangerLevel: DangerLevel.mild,
      imageUrl: 'assets/images/jellyfish/barrel/barrel1.jpg', // 이미지 경로 확인 필요
      colors: ['흰색', '파랑', '보라', '노랑'],
      habitats: ['북동 대서양', '지중해', '흑해', '아조프해', '연안'],
      size: '최대 90cm',
      isDiscovered: false,
    ),

    // --- labels.txt 에 없는 해파리 (후순위) ---
    // Jellyfish(
    //   id: 'jf007', // 기존 jf002
    //   name: '노무라입깃해파리',
    //   scientificName: 'Nemopilema nomurai',
    //   description:
    //       '노무라입깃해파리는 세계에서 가장 큰 해파리 중 하나로, 지름이 2m, 무게가 200kg까지 자랄 수 있습니다. '
    //       '동아시아 해역, 특히 한국, 중국, 일본 주변 바다에서 대규모로 발생하며 어업에 큰 피해를 줍니다. '
    //       '독성이 있어 접촉 시 화상과 통증을 유발할 수 있습니다.',
    //   shortDescription: '동아시아에서 발견되는 거대한 해파리',
    //   funFact: '노무라입깃해파리는 한 번에 수십억 개의 알을 낳을 수 있으며, 이는 바다 생태계에 큰 영향을 미칩니다.',
    //   dangerLevel: DangerLevel.moderate,
    //   imageUrl: 'assets/images/jellyfish/nomuras_jellyfish.jpg',
    //   colors: ['갈색', '노란색'],
    //   habitats: ['동아시아 해역', '한국 연안', '일본 연안'],
    //   size: '최대 2m',
    //   isDiscovered: false,
    // ),
    // Jellyfish(
    //   id: 'jf008', // 기존 jf003
    //   name: '상자해파리',
    //   scientificName: 'Chironex fleckeri',
    //   description:
    //       '상자해파리는 세계에서 가장 독성이 강한 해양 생물 중 하나로 알려져 있습니다. '
    //       '호주 북부 해안과 인도-태평양 지역에 서식하며, 특히 여름철에 많이 발견됩니다. '
    //       '독성 촉수에 쏘이면 극심한 통증, 심장마비, 심지어 사망까지 초래할 수 있어 매우 위험합니다.',
    //   shortDescription: '세계에서 가장 독성이 강한 해파리',
    //   funFact: '상자해파리는 24개의 눈을 가지고 있으며, 장애물을 피해 헤엄칠 수 있는 놀라운 시각 능력을 가지고 있습니다.',
    //   dangerLevel: DangerLevel.deadly,
    //   imageUrl: 'assets/images/jellyfish/box_jellyfish.jpg',
    //   colors: ['투명', '파랑'],
    //   habitats: ['호주 북부', '인도-태평양', '열대 바다'],
    //   size: '15-25cm',
    //   isDiscovered: false,
    // ),
    // Jellyfish(
    //   id: 'jf009', // 기존 jf005
    //   name: '푸른단추해파리',
    //   scientificName: 'Porpita porpita',
    //   description:
    //       '푸른단추해파리는 원형의 푸른 부유생물로, 실제로는 해파리가 아닌 히드라충류의 군체입니다. '
    //       '열대 및 아열대 바다의 표면에 떠다니며 살아갑니다. '
    //       '독성은 약해 인간에게 거의 해롭지 않지만, 약간의 자극을 줄 수 있습니다.',
    //   shortDescription: '아름다운 푸른색의 부유생물',
    //   funFact: '푸른단추해파리는 실제로 단일 생물이 아니라 여러 개체가 모여 사는 군체입니다.',
    //   dangerLevel: DangerLevel.mild,
    //   imageUrl: 'assets/images/jellyfish/blue_button.jpg',
    //   colors: ['파랑', '노랑'],
    //   habitats: ['열대 바다', '아열대 바다', '표층'],
    //   size: '1-3cm',
    //   isDiscovered: true, // 발견 여부 및 날짜는 기존 데이터 유지
    //   discoveredAt: DateTime.now().subtract(const Duration(days: 10)),
    // ),
    // Jellyfish(
    //   id: 'jf010', // 기존 jf006
    //   name: '커튼원양해파리',
    //   scientificName: 'Chrysaora melanaster',
    //   description:
    //       '커튼원양해파리는 북태평양에 서식하는 대형 해파리로, 우산 지름이 60cm까지 자랄 수 있습니다. '
    //       '독특한 줄무늬 패턴과 길고 풍성한 촉수가 특징입니다. '
    //       '독성이 있어 쏘이면 통증과 발진을 유발할 수 있지만, 생명을 위협하지는 않습니다.',
    //   shortDescription: '북태평양의 아름다운 줄무늬 해파리',
    //   funFact: '이 해파리는 먹이를 찾을 때 물을 펄싱하여 먹이를 촉수 쪽으로 밀어넣는 능동적인 사냥 방식을 사용합니다.',
    //   dangerLevel: DangerLevel.moderate,
    //   imageUrl: 'assets/images/jellyfish/sea_nettle.jpg',
    //   colors: ['갈색', '노랑', '빨강'],
    //   habitats: ['북태평양', '연안', '외해'],
    //   size: '45-60cm',
    //   isDiscovered: false,
    // ),
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
    int discoveredCount =
        jellyfishList.where((jellyfish) => jellyfish.isDiscovered).length;
    return (discoveredCount / jellyfishList.length) * 100;
  }
}
