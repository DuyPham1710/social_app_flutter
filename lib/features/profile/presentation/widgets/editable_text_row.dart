import 'package:flutter/material.dart';

class EditableTextRow extends StatelessWidget {
  final String text;

  const EditableTextRow({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}
