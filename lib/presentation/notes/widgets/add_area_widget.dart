import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/presentation/area/provider/area_provider.dart';

class AddAreaWidget extends StatefulWidget {
  const AddAreaWidget({super.key});

  @override
  State<AddAreaWidget> createState() => _AddAreaWidgetState();
}

class _AddAreaWidgetState extends State<AddAreaWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 5,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add Tags & Area', style: textTheme.bodyLarge),
          SizedBox(height: 12),
          Text('Area (select one)', style: textTheme.bodyMedium),
          SizedBox(height: 5),
          Consumer<AreaProvider>(
            builder: (context, value, child) {
              return Wrap(
                children: [
                  for (final area in value.areas)
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                      ),
                      child: Text(area.name, style: textTheme.bodySmall),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
