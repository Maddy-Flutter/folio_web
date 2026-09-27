import 'package:flutter/material.dart';
import 'package:follio/core/tokens/design_tokens.dart';

final class ScrollSectionRegistry {
  ScrollSectionRegistry._();
  static final ScrollSectionRegistry instance = ScrollSectionRegistry._();

  final Map<String, GlobalKey> _sectionKeys = <String, GlobalKey>{
    'hero': GlobalKey(debugLabel: 'section_hero'),
    'services': GlobalKey(debugLabel: 'section_services'),
    'work': GlobalKey(debugLabel: 'section_work'),
    'about': GlobalKey(debugLabel: 'section_about'),
    'reviews': GlobalKey(debugLabel: 'section_reviews'),
    'blog': GlobalKey(debugLabel: 'section_blog'),
    'contact': GlobalKey(debugLabel: 'section_contact'),
  };

  GlobalKey? getKey(String sectionId) => _sectionKeys[sectionId];

  void registerKey(String sectionId, GlobalKey key) {
    _sectionKeys[sectionId] = key;
  }

  void scrollToSection(String sectionId) {
    final GlobalKey? key = _sectionKeys[sectionId];
    final BuildContext? context = key?.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: DesignTokens.durationReveal,
        curve: DesignTokens.curveStandard,
      );
    }
  }
}
