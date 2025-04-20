import 'dart:typed_data';

import 'package:flutter/material.dart';

class QuizCard extends StatelessWidget {
  final String question;
  final List<String> answers;
  final void Function(int)? onAnswerSelected;

  // optinal Image as Uint8List
  final Uint8List? imageData;

  const QuizCard({
    super.key,
    required this.question,
    required this.answers,
    this.imageData,
    this.onAnswerSelected,
  })  : assert(answers.length == 4);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.black54,
            child: Text(
              question,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (imageData != null)
            Image.memory(
              imageData!,
              fit: BoxFit.cover,
              width: 300,
              height: 300,
            ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two elements per row
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3,
            ),
            itemCount: answers.length,
            itemBuilder: (context, index) {
              final letter = String.fromCharCode(65 + index);
              return GestureDetector(
                onTap: () => onAnswerSelected?.call(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '$letter:',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          answers[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      );
  }
}
