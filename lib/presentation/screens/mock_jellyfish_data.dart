import 'package:flutter/material.dart';
import 'package:jellyfish_test/data/models/jellyfish_model.dart';

/// 샘플 해파리 데이터
/// 실제 앱에서는 서버나 로컬 DB에서 가져오지만
/// 시뮬레이션을 위해 하드코딩된 데이터를 사용합니다
class MockJellyfishData {
  
  /// 샘플 해파리 목록 생성
  static List<Jellyfish> getMockJellyfishList() {
    return [
      Jellyfish(
        id: 'jf001',
        name: '노무라입깃해파리',
        scientificName: 'Nemopilema nomurai',
        dangerLevel: DangerLevel.moderate,
        description: '노무라입깃해파리는 동아시아 해역에서 발견되는 대형 해파리입니다. 우산 직경이 2m까지 자랄 수 있으며, 한국, 중국, 일본 연안에 주로 서식합니다. 노무라입깃해파리의 촉수는 통증을 유발할 수 있지만, 일반적으로 치명적이지는 않습니다.',
        shortDescription: '동아시아 해역에서 발견되는 대형 해파리로, 중간 정도의 독성을 가지고 있습니다.',
        size: '최대 2m 직경',
        colors: ['백색', '연한 갈색'],
        habitats: ['동해', '서해', '남해'],
        funFact: '노무라입깃해파리는 어업에 큰 영향을 미치며, 때로는 그물에 걸려 어업 활동을 방해합니다.',
        isDiscovered: false,
        imageUrl: 'assets/images/samples/nomura_jellyfish.jpg',
      ),
      Jellyfish(
        id: 'jf002',
        name: '작은부레관해파리',
        scientificName: 'Physalia physalis',
        dangerLevel: DangerLevel.severe,
        description: '작은부레관해파리는 강력한 독을 가진 위험한 해파리입니다. 실제로는 단일 생물이 아니라 군체를 이루고 있으며, 파란색을 띠는 부레로 수면 위에 떠다닙니다. 그 촉수는 10m 이상 길어질 수 있으며, 심각한 통증과 알레르기 반응을 유발할 수 있습니다.',
        shortDescription: '강력한 독을 가진 해파리로, 심각한 통증과, 발진, 호흡 곤란을 유발할 수 있습니다.',
        size: '부레 길이 15cm, 촉수 최대 10m',
        colors: ['푸른색', '보라색'],
        habitats: ['남해', '태평양'],
        funFact: '부레관해파리는 해파리가 아닌 히드라충류의 일종으로, 실제로는 수천 개의 작은 생물이 모여 형성된 군체입니다.',
        isDiscovered: false,
        imageUrl: 'assets/images/samples/portuguese_man_o_war.jpg',
      ),
      Jellyfish(
        id: 'jf003',
        name: '보름달물해파리',
        scientificName: 'Aurelia aurita',
        dangerLevel: DangerLevel.mild,
        description: '보름달물해파리는 전 세계 바다에서 가장 흔하게 볼 수 있는 해파리 중 하나입니다. 투명한 우산 모양의 몸체에 4개의 보라색 고리가 특징적입니다. 일반적으로 독성이 약하여 사람에게 심각한 위험을 초래하지 않습니다.',
        shortDescription: '전 세계적으로 분포하는 투명한 해파리로, 약한 독성을 가집니다.',
        size: '10-40cm 직경',
        colors: ['투명', '약간의 푸른색'],
        habitats: ['동해', '서해', '남해', '연안'],
        funFact: '보름달물해파리의 몸은 95%가 물로 이루어져 있어, 해변에 밀려오면 태양 아래 빠르게 증발합니다.',
        isDiscovered: false,
        imageUrl: 'assets/images/samples/moon_jellyfish.jpg',
      ),
      Jellyfish(
        id: 'jf004',
        name: '커튼원양해파리',
        scientificName: 'Drymonema dalmatinum',
        dangerLevel: DangerLevel.safe,
        description: '커튼원양해파리는 크기가 큰 해파리로, 직경이 1m 이상 될 수 있습니다. 튼튼한 촉수를 가지고 있지만 독성은 거의 없어 사람에게 안전합니다. 주로 온대 및 열대 해역에 서식합니다.',
        shortDescription: '직경이 큰 해파리로, 독성이 거의 없어 인체에 안전합니다.',
        size: '직경 1-1.5m',
        colors: ['연한 갈색', '투명'],
        habitats: ['동해', '태평양'],
        funFact: '커튼원양해파리는 다른 해파리들을 잡아먹는 특이한 식습관을 가지고 있습니다.',
        isDiscovered: false,
        imageUrl: 'assets/images/samples/curtain_jellyfish.jpg',
      ),
      Jellyfish(
        id: 'jf005',
        name: '상자해파리',
        scientificName: 'Chironex fleckeri',
        dangerLevel: DangerLevel.deadly,
        description: '상자해파리는 세계에서 가장 독성이 강한 해양 생물 중 하나로, 호주 북부 해안에 주로 서식합니다. 상자 모양의 투명한 몸체와 길고 가는 촉수가 특징입니다. 그 독은 극심한 통증을 유발하며, 심할 경우 사망에 이를 수 있습니다.',
        shortDescription: '세계에서 가장 위험한 해양 생물 중 하나로, 쏘였을 경우 즉시 응급 처치가 필요합니다.',
        size: '직경 15-25cm, 촉수 길이 3m',
        colors: ['투명', '약간의 청색'],
        habitats: ['열대 해역', '남태평양'],
        funFact: '상자해파리는 다른 해파리와 달리 눈이 있어 장애물을 피하고 먹이를 찾을 수 있습니다.',
        isDiscovered: false,
        imageUrl: 'assets/images/samples/box_jellyfish.jpg',
      ),
    ];
  }
  
  /// 샘플 이미지 경로 목록
  static List<String> getSampleImagePaths() {
    return [
      'assets/images/samples/nomura_jellyfish.jpg',
      'assets/images/samples/portuguese_man_o_war.jpg',
      'assets/images/samples/moon_jellyfish.jpg',
      'assets/images/samples/curtain_jellyfish.jpg',
      'assets/images/samples/box_jellyfish.jpg',
    ];
  }
} 