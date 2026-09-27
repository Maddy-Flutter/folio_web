import 'package:flutter/foundation.dart';
import 'package:follio/core/auth/auth_session.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/domain/repositories/auth_repository.dart';
import 'package:follio/presentation/viewmodels/view_state.dart';

final class AdminAuthViewModel extends ChangeNotifier {
  AdminAuthViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository {
    checkCurrentSession();
  }

  final AuthRepository _authRepository;

  ViewState _viewState = ViewState.idle;
  String _errorMessage = '';
  AuthSession? _currentSession;

  String _username = '';
  String _password = '';
  String? _usernameError;
  String? _passwordError;
  bool _obscurePassword = true;
  bool _isDisposed = false;

  ViewState get viewState => _viewState;
  String get errorMessage => _errorMessage;
  AuthSession? get currentSession => _currentSession;
  bool get isAuthenticated => _currentSession != null && _currentSession!.isValid;

  String get username => _username;
  String get password => _password;
  String? get usernameError => _usernameError;
  String? get passwordError => _passwordError;
  bool get obscurePassword => _obscurePassword;

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    _notify();
  }

  void setUsername(String value) {
    _username = value;
    if (_usernameError != null) {
      _usernameError = null;
      _notify();
    }
  }

  void setPassword(String value) {
    _password = value;
    if (_passwordError != null) {
      _passwordError = null;
      _notify();
    }
  }

  bool _validateInputs() {
    bool valid = true;
    if (_username.trim().isEmpty) {
      _usernameError = 'Please enter your admin username.';
      valid = false;
    } else {
      _usernameError = null;
    }

    if (_password.trim().isEmpty) {
      _passwordError = 'Please enter your password.';
      valid = false;
    } else {
      _passwordError = null;
    }

    _notify();
    return valid;
  }

  Future<void> checkCurrentSession() async {
    final AuthSession? session = await _authRepository.getCurrentSession();
    if (session != null && session.isValid) {
      _currentSession = session;
      _notify();
    } else if (_currentSession != null) {
      _currentSession = null;
      _notify();
    }
  }

  Future<bool> login() async {
    if (!_validateInputs()) {
      return false;
    }

    _viewState = ViewState.loading;
    _errorMessage = '';
    _notify();

    final Result<AuthSession> result = await _authRepository.login(
      username: _username,
      password: _password,
    );

    return result.when(
      success: (AuthSession session) {
        _currentSession = session;
        _viewState = ViewState.success;
        _errorMessage = '';
        _password = '';
        _notify();
        return true;
      },
      failure: (failure) {
        _viewState = ViewState.error;
        _errorMessage = failure.message;
        _notify();
        return false;
      },
    );
  }

  Future<void> logout() async {
    _viewState = ViewState.loading;
    _notify();

    await _authRepository.logout();
    _currentSession = null;
    _viewState = ViewState.idle;
    _errorMessage = '';
    _username = '';
    _password = '';
    _notify();
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
