import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/extention.dart';

class AddLinkWidget extends StatefulWidget {
  const AddLinkWidget({super.key, required this.onChange, this.initValue});

  final void Function(String value) onChange;
  final String? initValue;

  @override
  State<AddLinkWidget> createState() => _AddLinkWidgetState();
}

class _AddLinkWidgetState extends State<AddLinkWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            children: [
              Icon(Icons.link_outlined),
              Text('Link', style: textTheme.bodyLarge),
              Spacer(),
              Icon(Icons.delete_forever_outlined, color: Colors.red),
            ],
          ),
          SizedBox(height: 12),
          TextFormField(
            initialValue: widget.initValue,
            onChanged: widget.onChange,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(width: 1, color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(width: 1, color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(width: 1, color: Colors.grey),
              ),
              hintText: 'https://...',
            ),
          ),
        ],
      ),
    );
  }
}
