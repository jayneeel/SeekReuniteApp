import "dart:io";

import "package:flutter/material.dart";

class PictureItem extends StatelessWidget {
  const PictureItem({super.key, required this.file, required this.onCancelled});

  final File file;
  final VoidCallback onCancelled;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Container(
        height: 84,
        width: 84,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.only(right: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(file.path),
            height: 84,
            width: 84,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Positioned(
        top: 4,
        right: 20,
        child: InkWell(
          onTap: onCancelled,
          child: const Icon(
            Icons.cancel,
            color: Color(0xFFB6B6B6),
            size: 24,
          ),
        ),
      )
    ],
  );
}
