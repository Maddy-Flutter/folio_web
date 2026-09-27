import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:follio/core/constants/app_constants.dart';
import 'package:follio/core/errors/failures.dart';
import 'package:follio/data/models/contact_submission_dto.dart';
import 'package:http/http.dart' as http;

abstract interface class ContactRemoteDataSource {
  Future<void> sendInquiry(ContactSubmissionDto submission);
}

final class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  ContactRemoteDataSourceImpl({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<void> sendInquiry(ContactSubmissionDto submission) async {
    const String serviceId = AppConstants.emailJsServiceId;
    const String templateId = AppConstants.emailJsTemplateId;
    const String publicKey = AppConstants.emailJsPublicKey;
    const String autoReplyTemplateId = AppConstants.emailJsAutoReplyTemplateId;

    // In local development or demo without keys, simulate successful delivery
    if (serviceId.isEmpty || templateId.isEmpty || publicKey.isEmpty) {
      if (kDebugMode) {
        debugPrint(
          'EmailJS keys missing in environment. Simulating send for: ${submission.email}',
        );
      }
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      return;
    }

    // Attempt sending primary notification
    await _sendWithRetry(
      serviceId: serviceId,
      templateId: templateId,
      publicKey: publicKey,
      templateParams: submission.toEmailJsParams(),
    );

    // If an auto-reply template ID is provided, send acknowledgement
    if (autoReplyTemplateId.isNotEmpty) {
      try {
        await _sendWithRetry(
          serviceId: serviceId,
          templateId: autoReplyTemplateId,
          publicKey: publicKey,
          templateParams: submission.toEmailJsParams(),
        );
      } catch (e) {
        // Auto-reply failure should not fail the primary contact inquiry
        if (kDebugMode) {
          debugPrint('Auto-reply acknowledgement failed: $e');
        }
      }
    }
  }

  Future<void> _sendWithRetry({
    required String serviceId,
    required String templateId,
    required String publicKey,
    required Map<String, dynamic> templateParams,
  }) async {
    int attempts = 0;
    const int maxAttempts = 2; // initial + 1 retry

    while (attempts < maxAttempts) {
      attempts++;
      try {
        final http.Response response = await _client
            .post(
              Uri.parse(AppConstants.emailJsEndpoint),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'origin': 'http://localhost',
              },
              body: jsonEncode(<String, dynamic>{
                'service_id': serviceId,
                'template_id': templateId,
                'user_id': publicKey,
                'template_params': templateParams,
              }),
            )
            .timeout(AppConstants.contactTimeout);

        if (response.statusCode >= 200 && response.statusCode < 300) {
          return;
        } else {
          throw ServerFailure('EmailJS returned status ${response.statusCode}: ${response.body}');
        }
      } on TimeoutException {
        if (attempts >= maxAttempts) {
          throw const TimeoutFailure();
        }
      } on ServerFailure {
        rethrow;
      } catch (e) {
        if (attempts >= maxAttempts) {
          throw NetworkFailure(e.toString());
        }
      }
      // Brief backoff before retry
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
  }
}
