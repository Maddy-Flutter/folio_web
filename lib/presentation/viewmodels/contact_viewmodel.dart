import 'package:flutter/material.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/core/errors/failures.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/data/models/contact_submission_dto.dart';
import 'package:follio/domain/repositories/contact_repository.dart';
import 'package:follio/presentation/viewmodels/view_state.dart';

final class ContactViewModel extends ChangeNotifier {
  ContactViewModel({required ContactRepository contactRepository})
      : _contactRepository = contactRepository;

  final ContactRepository _contactRepository;

  ViewState _submitState = ViewState.idle;
  String _errorMessage = '';
  bool _isDisposed = false;

  // Form field values
  String _name = '';
  String _email = '';
  String _subject = '';
  String _message = '';
  String _honeypot = '';

  // Validation feedback
  bool _hasInteractedWithForm = false;
  String? _nameError;
  String? _emailError;
  String? _subjectError;
  String? _messageError;

  ViewState get submitState => _submitState;
  String get errorMessage => _errorMessage;

  String get name => _name;
  String get email => _email;
  String get subject => _subject;
  String get message => _message;
  String get honeypot => _honeypot;

  String? get nameError => _nameError;
  String? get emailError => _emailError;
  String? get subjectError => _subjectError;
  String? get messageError => _messageError;

  bool get isSubmitting => _submitState == ViewState.loading;
  bool get isSuccess => _submitState == ViewState.success;
  bool get hasError => _submitState == ViewState.error;

  void setName(String val) {
    _name = val;
    if (_hasInteractedWithForm) {
      _nameError = _validateName(val);
    }
    _safeNotify();
  }

  void onNameBlur() {
    _hasInteractedWithForm = true;
    _nameError = _validateName(_name);
    _safeNotify();
  }

  void setEmail(String val) {
    _email = val;
    if (_hasInteractedWithForm) {
      _emailError = _validateEmail(val);
    }
    _safeNotify();
  }

  void onEmailBlur() {
    _hasInteractedWithForm = true;
    _emailError = _validateEmail(_email);
    _safeNotify();
  }

  void setSubject(String val) {
    _subject = val;
    if (_hasInteractedWithForm) {
      _subjectError = _validateSubject(val);
    }
    _safeNotify();
  }

  void onSubjectBlur() {
    _hasInteractedWithForm = true;
    _subjectError = _validateSubject(_subject);
    _safeNotify();
  }

  void setMessage(String val) {
    _message = val;
    if (_hasInteractedWithForm) {
      _messageError = _validateMessage(val);
    }
    _safeNotify();
  }

  void onMessageBlur() {
    _hasInteractedWithForm = true;
    _messageError = _validateMessage(_message);
    _safeNotify();
  }

  void setHoneypot(String val) {
    _honeypot = val;
  }

  String? _validateName(String val) {
    final String trimmed = val.trim();
    if (trimmed.length < 2 || trimmed.length > 60) {
      return AppStrings.valNameRequired;
    }
    return null;
  }

  String? _validateEmail(String val) {
    final String trimmed = val.trim();
    final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    if (trimmed.isEmpty || !emailRegExp.hasMatch(trimmed)) {
      return AppStrings.valEmailInvalid;
    }
    return null;
  }

  String? _validateSubject(String val) {
    final String trimmed = val.trim();
    if (trimmed.length > 120) {
      return AppStrings.valSubjectTooLong;
    }
    return null;
  }

  String? _validateMessage(String val) {
    final String trimmed = val.trim();
    if (trimmed.length < 10 || trimmed.length > 2000) {
      return AppStrings.valMessageRequired;
    }
    return null;
  }

  bool validateAll() {
    _hasInteractedWithForm = true;
    _nameError = _validateName(_name);
    _emailError = _validateEmail(_email);
    _subjectError = _validateSubject(_subject);
    _messageError = _validateMessage(_message);
    _safeNotify();

    return _nameError == null &&
        _emailError == null &&
        _subjectError == null &&
        _messageError == null;
  }

  Future<bool> submit() async {
    if (!validateAll()) {
      return false;
    }

    _submitState = ViewState.loading;
    _errorMessage = '';
    _safeNotify();

    final ContactSubmissionDto submission = ContactSubmissionDto(
      name: _name,
      email: _email,
      subject: _subject,
      message: _message,
      honeypot: _honeypot,
    );

    final Result<void> result = await _contactRepository.submitContactForm(submission);

    switch (result) {
      case Success():
        _submitState = ViewState.success;
        _errorMessage = '';
        _safeNotify();
        return true;
      case FailureResult(:final failure):
        _submitState = ViewState.error;
        _errorMessage = switch (failure) {
          RateLimitFailure() => AppStrings.rateLimitError,
          NetworkFailure() => AppStrings.networkError,
          TimeoutFailure() => AppStrings.timeoutError,
          ValidationFailure(:final message) => message,
          _ => AppStrings.genericError,
        };
        _safeNotify();
        return false;
    }
  }

  void resetForm() {
    _submitState = ViewState.idle;
    _errorMessage = '';
    _name = '';
    _email = '';
    _subject = '';
    _message = '';
    _honeypot = '';
    _hasInteractedWithForm = false;
    _nameError = null;
    _emailError = null;
    _subjectError = null;
    _messageError = null;
    _safeNotify();
  }

  void _safeNotify() {
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
