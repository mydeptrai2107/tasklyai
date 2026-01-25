class AiFolderSuggestion {
  final bool success;
  final bool found;
  final SuggestedFolder? suggestedFolder;
  final double confidence;
  final String reasoning;
  final List<FolderScore> allScores;

  AiFolderSuggestion({
    required this.success,
    required this.found,
    required this.suggestedFolder,
    required this.confidence,
    required this.reasoning,
    required this.allScores,
  });

  factory AiFolderSuggestion.fromJson(Map<String, dynamic> json) {
    final suggestedRaw = json['suggestedFolder'];
    final scoresRaw = json['allScores'] as List<dynamic>? ?? [];
    return AiFolderSuggestion(
      success: json['success'] ?? false,
      found: json['found'] ?? false,
      suggestedFolder: suggestedRaw is Map<String, dynamic>
          ? SuggestedFolder.fromJson(suggestedRaw)
          : null,
      confidence: (json['confidence'] ?? 0).toDouble(),
      reasoning: json['reasoning'] ?? '',
      allScores:
          scoresRaw.map((e) => FolderScore.fromJson(e)).toList(),
    );
  }
}

class SuggestedFolder {
  final String id;
  final String name;
  final int color;
  final int icon;
  final String areaId;

  SuggestedFolder({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.areaId,
  });

  factory SuggestedFolder.fromJson(Map<String, dynamic> json) {
    return SuggestedFolder(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      color: json['color'] ?? 0,
      icon: json['icon'] ?? 0,
      areaId: json['areaId'] ?? '',
    );
  }
}

class FolderScore {
  final String folderName;
  final double score;
  final String reason;

  FolderScore({
    required this.folderName,
    required this.score,
    required this.reason,
  });

  factory FolderScore.fromJson(Map<String, dynamic> json) {
    return FolderScore(
      folderName: json['folder_name'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
      reason: json['reason'] ?? '',
    );
  }
}
