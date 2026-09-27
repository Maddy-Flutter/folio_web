import 'package:follio/core/constants/app_strings.dart';

final class ProfileDraft {
  const ProfileDraft({
    required this.name,
    required this.greeting,
    required this.role,
    required this.bioPara1,
    required this.bioPara2,
    required this.tools,
    this.extractedProjectSummaries = const <String>[],
    this.avatarUrl,
  });

  final String name;
  final String greeting;
  final String role;
  final String bioPara1;
  final String bioPara2;
  final List<String> tools;
  final List<String> extractedProjectSummaries;
  final String? avatarUrl;

  ProfileDraft copyWith({
    String? name,
    String? greeting,
    String? role,
    String? bioPara1,
    String? bioPara2,
    List<String>? tools,
    List<String>? extractedProjectSummaries,
    String? avatarUrl,
  }) {
    return ProfileDraft(
      name: name ?? this.name,
      greeting: greeting ?? this.greeting,
      role: role ?? this.role,
      bioPara1: bioPara1 ?? this.bioPara1,
      bioPara2: bioPara2 ?? this.bioPara2,
      tools: tools ?? this.tools,
      extractedProjectSummaries:
          extractedProjectSummaries ?? this.extractedProjectSummaries,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'greeting': greeting,
      'role': role,
      'bioPara1': bioPara1,
      'bioPara2': bioPara2,
      'tools': tools,
      'extractedProjectSummaries': extractedProjectSummaries,
      'avatarUrl': avatarUrl,
    };
  }

  factory ProfileDraft.fromJson(Map<String, dynamic> json) {
    return ProfileDraft(
      name: json['name'] as String? ?? 'Eliott',
      greeting: json['greeting'] as String? ?? "Hi, I'm ",
      role: json['role'] as String? ?? 'Freelance UI/UX Designer & Frontend Developer',
      bioPara1: json['bioPara1'] as String? ?? '',
      bioPara2: json['bioPara2'] as String? ?? '',
      tools: (json['tools'] as List<dynamic>?)?.map((dynamic e) => e.toString()).toList() ??
          <String>[],
      extractedProjectSummaries:
          (json['extractedProjectSummaries'] as List<dynamic>?)
                  ?.map((dynamic e) => e.toString())
                  .toList() ??
              <String>[],
      avatarUrl: json['avatarUrl'] as String? ?? defaultAvatarUrl,
    );
  }

  static const String defaultAvatarUrl =
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&q=80';

  static const ProfileDraft initialDefault = ProfileDraft(
    name: AppStrings.heroName,
    greeting: AppStrings.heroGreeting,
    role: 'Freelance UI/UX Designer & Frontend Developer',
    bioPara1: AppStrings.aboutPara1,
    bioPara2: AppStrings.aboutPara2,
    tools: AppStrings.aboutTools,
    extractedProjectSummaries: <String>[
      'Novu — Enterprise SaaS design system and multi-role dashboard',
      'Finlo — Mobile banking & investment application',
      'Onyx Studio — Creative production agency portfolio & CMS',
    ],
    avatarUrl: defaultAvatarUrl,
  );
}

final class ProfileVersion {
  const ProfileVersion({
    required this.versionId,
    required this.publishedAt,
    required this.draft,
  });

  final String versionId;
  final DateTime publishedAt;
  final ProfileDraft draft;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'versionId': versionId,
      'publishedAt': publishedAt.toIso8601String(),
      'draft': draft.toJson(),
    };
  }

  factory ProfileVersion.fromJson(Map<String, dynamic> json) {
    return ProfileVersion(
      versionId: json['versionId'] as String? ?? '',
      publishedAt: DateTime.tryParse(json['publishedAt'] as String? ?? '') ?? DateTime.now(),
      draft: ProfileDraft.fromJson(json['draft'] as Map<String, dynamic>? ?? <String, dynamic>{}),
    );
  }
}
