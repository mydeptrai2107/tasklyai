import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/extention.dart';

class ProjectAppbar extends StatelessWidget {
  const ProjectAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      title: Text('Project Detail', style: context.theme.textTheme.titleSmall),
      centerTitle: true,
    );
  }
}
