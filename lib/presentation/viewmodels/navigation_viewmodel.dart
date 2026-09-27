import 'package:flutter/material.dart';
import 'package:follio/core/utils/scroll_controller_registry.dart';

final class NavigationViewModel extends ChangeNotifier {
  String _activeSection = 'hero';
  bool _isScrolled = false;
  bool _isMobileMenuOpen = false;
  bool _isDisposed = false;

  String get activeSection => _activeSection;
  bool get isScrolled => _isScrolled;
  bool get isMobileMenuOpen => _isMobileMenuOpen;

  void setActiveSection(String sectionId) {
    if (_activeSection == sectionId) return;
    _activeSection = sectionId;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void setScrolled(bool scrolled) {
    if (_isScrolled == scrolled) return;
    _isScrolled = scrolled;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void toggleMobileMenu() {
    _isMobileMenuOpen = !_isMobileMenuOpen;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void closeMobileMenu() {
    if (!_isMobileMenuOpen) return;
    _isMobileMenuOpen = false;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void navigateToSection(String sectionId) {
    closeMobileMenu();
    setActiveSection(sectionId);
    ScrollSectionRegistry.instance.scrollToSection(sectionId);
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
