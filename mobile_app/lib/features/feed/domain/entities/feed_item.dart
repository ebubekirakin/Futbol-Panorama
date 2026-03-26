enum AnalysisType {
  preMatch,
  postMatch,
  player,
}

extension AnalysisTypeExtension on AnalysisType {
  String get displayName {
    switch (this) {
      case AnalysisType.preMatch:
        return 'Maç Öncesi';
      case AnalysisType.postMatch:
        return 'Maç Sonu';
      case AnalysisType.player:
        return 'Oyuncu İncelemesi';
    }
  }
}

class FeedItem {
  final String id;
  final String authorName;
  final String title;
  final double trustScore;
  final List<String> badges;
  final AnalysisType type;

  FeedItem({
    required this.id,
    required this.authorName,
    required this.title,
    required this.trustScore,
    required this.badges,
    required this.type,
  });
}
