import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/models/profile_model.dart';

class UserInfor extends StatelessWidget {
  const UserInfor(this.profile, {super.key});

  final ProfileModel? profile;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Row(
      spacing: 10,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(40),
            shape: BoxShape.circle,
            border: Border.all(width: 1, color: Colors.white),
          ),
          child: Icon(
            Icons.person_outline_rounded,
            size: 50,
            color: Colors.white,
          ),
        ),

        Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profile?.name ?? '',
              style: textTheme.titleMedium?.copyWith(color: Colors.white),
            ),

            Text(
              profile?.email ?? '',
              style: textTheme.bodySmall?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
