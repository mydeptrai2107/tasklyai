class ProjectShareSummary {
  final String ownerId;
  final String ownerPermission;
  final List<SharedUser> shares;
  final int totalShares;

  ProjectShareSummary({
    required this.ownerId,
    required this.ownerPermission,
    required this.shares,
    required this.totalShares,
  });

  factory ProjectShareSummary.fromJson(Map<String, dynamic> json) {
    final sharesRaw = json['shares'] as List<dynamic>? ?? [];
    final ownerRaw = json['owner'] as Map<String, dynamic>? ?? {};
    return ProjectShareSummary(
      ownerId: ownerRaw['_id'] ?? '',
      ownerPermission: ownerRaw['permission'] ?? 'owner',
      shares: sharesRaw.map((e) => SharedUser.fromJson(e)).toList(),
      totalShares: json['totalShares'] ?? sharesRaw.length,
    );
  }
}

class SharedUser {
  final SharedUserInfo user;
  final String permission;
  final SharedUserInfo? sharedBy;
  final DateTime? sharedAt;

  SharedUser({
    required this.user,
    required this.permission,
    required this.sharedBy,
    required this.sharedAt,
  });

  factory SharedUser.fromJson(Map<String, dynamic> json) {
    return SharedUser(
      user: SharedUserInfo.fromJson(json['user'] ?? {}),
      permission: json['permission'] ?? 'view',
      sharedBy: json['sharedBy'] != null
          ? SharedUserInfo.fromJson(json['sharedBy'])
          : null,
      sharedAt: json['sharedAt'] != null
          ? DateTime.tryParse(json['sharedAt'])
          : null,
    );
  }
}

class SharedUserInfo {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;

  SharedUserInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  factory SharedUserInfo.fromJson(Map<String, dynamic> json) {
    return SharedUserInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'],
    );
  }
}
