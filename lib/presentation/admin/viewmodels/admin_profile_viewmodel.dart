import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/data/models/profile_content_model.dart';
import 'package:follio/domain/repositories/profile_content_repository.dart';
import 'package:follio/presentation/viewmodels/view_state.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

final class AdminProfileViewModel extends ChangeNotifier {
  AdminProfileViewModel({
    required ProfileContentRepository profileRepository,
  }) : _profileRepository = profileRepository {
    loadProfileAndHistory();
  }

  final ProfileContentRepository _profileRepository;

  ViewState _viewState = ViewState.idle;
  String _errorMessage = '';
  String _successMessage = '';

  ProfileDraft _draft = ProfileDraft.initialDefault;
  List<ProfileVersion> _versions = <ProfileVersion>[];

  String? _uploadedFileName;
  int? _uploadedFileSizeBytes;
  double _uploadProgress = 0.0;
  bool _isParsing = false;
  bool _isPublishing = false;
  bool _isUploadingAvatar = false;
  bool _isDisposed = false;

  ViewState get viewState => _viewState;
  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;

  ProfileDraft get draft => _draft;
  List<ProfileVersion> get versions => _versions;

  String? get uploadedFileName => _uploadedFileName;
  int? get uploadedFileSizeBytes => _uploadedFileSizeBytes;
  double get uploadProgress => _uploadProgress;
  bool get isParsing => _isParsing;
  bool get isPublishing => _isPublishing;
  bool get isUploadingAvatar => _isUploadingAvatar;
  bool get hasCustomAvatar =>
      _draft.avatarUrl != null &&
      _draft.avatarUrl!.isNotEmpty &&
      _draft.avatarUrl != ProfileDraft.defaultAvatarUrl;

  Future<void> loadProfileAndHistory() async {
    _viewState = ViewState.loading;
    _notify();

    final Result<ProfileDraft> profileResult = await _profileRepository.getActiveProfile();
    final Result<List<ProfileVersion>> historyResult =
        await _profileRepository.getVersionHistory();

    if (profileResult.isSuccess) {
      _draft = profileResult.valueOrNull ?? ProfileDraft.initialDefault;
    }
    if (historyResult.isSuccess) {
      _versions = historyResult.valueOrNull ?? <ProfileVersion>[];
    }

    _viewState = ViewState.success;
    _notify();
  }

  void updateDraft({
    String? name,
    String? greeting,
    String? role,
    String? bioPara1,
    String? bioPara2,
    List<String>? tools,
    List<String>? extractedProjectSummaries,
    String? avatarUrl,
  }) {
    _draft = _draft.copyWith(
      name: name != null ? sanitizeText(name) : null,
      greeting: greeting != null ? sanitizeText(greeting) : null,
      role: role != null ? sanitizeText(role) : null,
      bioPara1: bioPara1 != null ? sanitizeText(bioPara1) : null,
      bioPara2: bioPara2 != null ? sanitizeText(bioPara2) : null,
      tools: tools?.map(sanitizeText).toList(),
      extractedProjectSummaries:
          extractedProjectSummaries?.map(sanitizeText).toList(),
      avatarUrl: avatarUrl != null ? sanitizeText(avatarUrl) : null,
    );
    _successMessage = '';
    _notify();
  }

  void updateAvatarUrl(String url) {
    _draft = _draft.copyWith(avatarUrl: sanitizeText(url));
    _successMessage = '';
    _notify();
  }

  void resetAvatar() {
    _draft = _draft.copyWith(avatarUrl: ProfileDraft.defaultAvatarUrl);
    _successMessage = 'Profile photo reset to default portrait.';
    _notify();
  }

  Future<bool> pickAndUploadAvatar() async {
    try {
      _errorMessage = '';
      _successMessage = '';

      final List<PlatformFile> files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: <String>['png', 'jpg', 'jpeg', 'webp', 'gif'],
      );

      if (files.isEmpty) {
        return false;
      }

      final PlatformFile file = files.first;
      final int size = file.lengthSync() ?? (await file.length()) ?? 0;

      // 1. Validate file size (max 5MB = 5 * 1024 * 1024 bytes)
      if (size > 5 * 1024 * 1024) {
        _errorMessage = 'Image size exceeds 5MB limit. Please choose a smaller image.';
        _notify();
        return false;
      }

      // 2. Validate file extension
      final String extension = (file.extension ?? '').toLowerCase();
      if (!<String>['png', 'jpg', 'jpeg', 'webp', 'gif'].contains(extension)) {
        _errorMessage = 'Unsupported image format. Please select PNG, JPG, JPEG, WEBP, or GIF.';
        _notify();
        return false;
      }

      _isUploadingAvatar = true;
      _notify();

      final Uint8List bytes = await file.readAsBytes();
      if (bytes.isEmpty) {
        _errorMessage = 'Unable to read selected image file.';
        _isUploadingAvatar = false;
        _notify();
        return false;
      }

      final String mimeExt = (extension == 'jpg') ? 'jpeg' : extension;
      final String base64Data = base64Encode(bytes);
      final String dataUri = 'data:image/$mimeExt;base64,$base64Data';

      _draft = _draft.copyWith(avatarUrl: dataUri);
      _isUploadingAvatar = false;
      _successMessage = 'Profile image updated! Click "Publish to Live Site" to apply changes.';
      _notify();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to load image: ${e.toString()}';
      _isUploadingAvatar = false;
      _notify();
      return false;
    }
  }

  Future<bool> pickAndParseFile() async {
    try {
      _errorMessage = '';
      _successMessage = '';

      final List<PlatformFile> files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: <String>['pdf', 'doc', 'docx'],
      );

      if (files.isEmpty) {
        return false;
      }

      final PlatformFile file = files.first;
      final int size = file.lengthSync() ?? (await file.length()) ?? 0;

      // 1. Validate file size (max 10MB = 10 * 1024 * 1024 bytes)
      if (size > 10 * 1024 * 1024) {
        _errorMessage = 'File size exceeds 10MB limit. Please upload a smaller resume.';
        _notify();
        return false;
      }

      // 2. Validate file extension
      final String extension = (file.extension ?? '').toLowerCase();
      if (!<String>['pdf', 'doc', 'docx'].contains(extension)) {
        _errorMessage = 'Unsupported file format. Please upload a PDF, DOC, or DOCX document.';
        _notify();
        return false;
      }

      _uploadedFileName = file.name;
      _uploadedFileSizeBytes = size;
      _uploadProgress = 0.5;
      _isParsing = true;
      _notify();

      final Uint8List bytes = await file.readAsBytes();
      if (bytes.isEmpty) {
        _errorMessage = 'Unable to read file contents.';
        _isParsing = false;
        _notify();
        return false;
      }

      // 3. Extract text
      String extractedText = '';
      if (extension == 'pdf') {
        extractedText = extractTextFromPdf(bytes);
      } else {
        extractedText = extractTextFromWordOrText(bytes);
      }

      _uploadProgress = 0.85;
      _notify();

      // 4. Parse structured profile fields from extracted text
      final ProfileDraft parsedDraft = parseResumeTextToDraft(extractedText);
      _draft = parsedDraft;
      _uploadProgress = 1.0;
      _isParsing = false;
      _successMessage = 'Resume parsed successfully! Review and edit the draft below before publishing.';
      _notify();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to parse resume: ${e.toString()}';
      _isParsing = false;
      _notify();
      return false;
    }
  }

  String extractTextFromPdf(Uint8List bytes) {
    try {
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      final String text = PdfTextExtractor(document).extractText();
      document.dispose();
      return text;
    } catch (_) {
      return '';
    }
  }

  String extractTextFromWordOrText(Uint8List bytes) {
    try {
      final String raw = String.fromCharCodes(bytes);
      // Strip common XML / word packaging tags
      return raw.replaceAll(RegExp(r'<[^>]*>'), ' ');
    } catch (_) {
      return '';
    }
  }

  ProfileDraft parseResumeTextToDraft(String rawText) {
    final String cleanText = sanitizeText(rawText);
    final List<String> lines = cleanText
        .split('\n')
        .map((String l) => l.trim())
        .where((String l) => l.isNotEmpty)
        .toList();

    String name = _draft.name;
    String role = _draft.role;
    String bio1 = _draft.bioPara1;
    String bio2 = _draft.bioPara2;
    List<String> tools = List<String>.from(_draft.tools);
    List<String> projects = List<String>.from(_draft.extractedProjectSummaries);

    if (lines.isNotEmpty) {
      // First line typically holds candidate name
      final String candidateName = lines.first;
      if (candidateName.length <= 40 && !candidateName.contains('@')) {
        name = candidateName;
      }
    }

    // Role detection
    for (final String line in lines.take(6)) {
      if (line.toLowerCase().contains('designer') ||
          line.toLowerCase().contains('developer') ||
          line.toLowerCase().contains('engineer') ||
          line.toLowerCase().contains('architect')) {
        role = line;
        break;
      }
    }

    // Skills detection
    final List<String> commonSkills = <String>[
      'Figma',
      'Flutter',
      'Dart',
      'Tailwind CSS',
      'TypeScript',
      'JavaScript',
      'Next.js',
      'React',
      'Vue',
      'CSS',
      'HTML',
      'Git',
      'Node.js',
      'Firebase',
      'UI/UX',
    ];

    final Set<String> detectedSkills = <String>{};
    for (final String skill in commonSkills) {
      if (cleanText.toLowerCase().contains(skill.toLowerCase())) {
        detectedSkills.add(skill);
      }
    }
    if (detectedSkills.isNotEmpty) {
      tools = detectedSkills.toList();
    }

    // Summary / Bio extraction
    int summaryIndex = -1;
    for (int i = 0; i < lines.length; i++) {
      final String l = lines[i].toLowerCase();
      if (l == 'summary' || l == 'about' || l == 'about me' || l == 'profile') {
        summaryIndex = i;
        break;
      }
    }

    if (summaryIndex != -1 && (summaryIndex + 1) < lines.length) {
      bio1 = lines[summaryIndex + 1];
      if ((summaryIndex + 2) < lines.length &&
          !lines[summaryIndex + 2].toLowerCase().startsWith('skill') &&
          !lines[summaryIndex + 2].toLowerCase().startsWith('experience')) {
        bio2 = lines[summaryIndex + 2];
      }
    }

    return ProfileDraft(
      name: name,
      greeting: "Hi, I'm ",
      role: role,
      bioPara1: bio1,
      bioPara2: bio2,
      tools: tools,
      extractedProjectSummaries: projects,
      avatarUrl: _draft.avatarUrl,
    );
  }

  /// Sanitizes text input to prevent XSS and raw HTML injection.
  static String sanitizeText(String input) {
    return input
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll(RegExp(r'<script[\s\S]*?<\/script>', caseSensitive: false), '')
        .replaceAll(RegExp(r'<style[\s\S]*?<\/style>', caseSensitive: false), '')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'javascript:', caseSensitive: false), '')
        .trim();
  }

  Future<bool> publish() async {
    _isPublishing = true;
    _errorMessage = '';
    _successMessage = '';
    _notify();

    final Result<void> result = await _profileRepository.publishProfile(_draft);

    _isPublishing = false;
    return result.when(
      success: (_) async {
        _successMessage = 'Profile updated and published successfully! Changes are live.';
        // Refresh version history
        final Result<List<ProfileVersion>> history =
            await _profileRepository.getVersionHistory();
        if (history.isSuccess) {
          _versions = history.valueOrNull ?? <ProfileVersion>[];
        }
        _notify();
        return true;
      },
      failure: (failure) {
        _errorMessage = failure.message;
        _notify();
        return false;
      },
    );
  }

  Future<bool> revertToVersion(String versionId) async {
    _isPublishing = true;
    _errorMessage = '';
    _successMessage = '';
    _notify();

    final Result<ProfileDraft> result =
        await _profileRepository.revertToVersion(versionId);

    _isPublishing = false;
    return result.when(
      success: (ProfileDraft revertedDraft) {
        _draft = revertedDraft;
        _successMessage = 'Reverted successfully to version $versionId!';
        _notify();
        return true;
      },
      failure: (failure) {
        _errorMessage = failure.message;
        _notify();
        return false;
      },
    );
  }

  void _notify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
