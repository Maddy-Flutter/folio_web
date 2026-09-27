import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';

class PhotoFrame extends StatelessWidget {
  const PhotoFrame({
    super.key,
    required this.imageUrl,
    this.altText = '',
    this.borderRadius = DesignTokens.border2Xl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  final String imageUrl;
  final String altText;
  final BorderRadius borderRadius;
  final BoxFit fit;
  final double? width;
  final double? height;

  Uint8List? _tryDecodeBase64(String uri) {
    try {
      final int commaIndex = uri.indexOf(',');
      final String data = commaIndex != -1 ? uri.substring(commaIndex + 1) : uri;
      return base64Decode(data);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final PortfolioColors colors = context.portfolioColors;
    final bool isBase64 = imageUrl.startsWith('data:image') || imageUrl.contains(';base64,');

    Widget imageWidget;
    if (imageUrl.trim().isEmpty) {
      imageWidget = Center(
        child: Icon(
          Icons.image_outlined,
          size: 32.0,
          color: colors.textSubtle,
        ),
      );
    } else if (isBase64) {
      final Uint8List? bytes = _tryDecodeBase64(imageUrl);
      if (bytes != null) {
        imageWidget = Image.memory(
          bytes,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            return Center(
              child: Icon(
                Icons.broken_image_outlined,
                size: 32.0,
                color: colors.textSubtle,
              ),
            );
          },
        );
      } else {
        imageWidget = Center(
          child: Icon(
            Icons.broken_image_outlined,
            size: 32.0,
            color: colors.textSubtle,
          ),
        );
      }
    } else {
      imageWidget = Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (
          BuildContext context,
          Widget child,
          ImageChunkEvent? loadingProgress,
        ) {
          if (loadingProgress == null) return child;
          return Center(
            child: SizedBox(
              width: 24.0,
              height: 24.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
                valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
              ),
            ),
          );
        },
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          return Center(
            child: Icon(
              Icons.image_outlined,
              size: 32.0,
              color: colors.textSubtle,
            ),
          );
        },
      );
    }

    return Semantics(
      image: true,
      label: altText,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          width: width,
          height: height,
          color: colors.photoPlaceholder,
          child: imageWidget,
        ),
      ),
    );
  }
}
