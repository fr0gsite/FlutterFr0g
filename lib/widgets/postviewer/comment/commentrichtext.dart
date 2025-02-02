import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget commentRichText(String text) {
    final RegExp linkRegex = RegExp(
      r'(https?:\/\/[^\s]+)', // Matches URLs starting with http:// or https://
      caseSensitive: false,
    );

    final List<InlineSpan> spans = [];
    int currentIndex = 0;

    // Parse text and identify links
    for (final match in linkRegex.allMatches(text)) {
      final String linkText = match.group(0)!;
      final int start = match.start;

      // Add text before the link
      if (start > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, start),
          style: const TextStyle(color: Colors.white), // Default text style
        ));
      }

      // Add the link text with special styling
      spans.add(
        TextSpan(
          text: linkText,
          style: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
            decorationColor: Colors.blue
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              if (await canLaunchUrl(Uri.parse(linkText))) {
                await launchUrl(Uri.parse(linkText));
              } else {
                debugPrint('Could not launch $linkText');
              }
            },
        ),
      );

      currentIndex = match.end;
    }

    // Add remaining text after the last link
    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: const TextStyle(color: Colors.white),
      ));
    }

    return AutoSizeText.rich(
      TextSpan(
        children: spans,
      ),
      minFontSize: 12,
      maxFontSize: 14,
    );
  }