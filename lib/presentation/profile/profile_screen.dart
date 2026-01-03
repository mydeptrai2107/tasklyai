import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/constant.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/configs/local_storage.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/presentation/auth/auth_screen.dart';
import 'package:tasklyai/presentation/notes/provider/note_provider.dart';
import 'package:tasklyai/presentation/profile/provider/profile_provider.dart';
import 'package:tasklyai/presentation/profile/widgets/task_note_infor.dart';
import 'package:tasklyai/presentation/profile/widgets/user_infor.dart';
import 'package:tasklyai/presentation/task_project/provider/task_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Scaffold(
      body: Consumer3<ProfileProvider, TaskProvider, NoteProvider>(
        builder: (context, profileProvider, taskProvider, noteProvider, child) {
          final profile = profileProvider.profile;
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                decoration: BoxDecoration(color: primaryColor),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    border: Border.all(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      UserInfor(profile),
                      Divider(color: Colors.white, height: 30),
                      TaskNoteInfor(
                        notes: noteProvider.notes,
                        tasks: taskProvider.allTask,
                      ),
                    ],
                  ),
                ),
              ),

              OutlinedButton.icon(
                onPressed: () {
                  LocalStorage.remove(kToken);
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const AuthScreen()),
                    (route) => false,
                  );
                },
                label: Text('Đăng xuất'),
                icon: Icon(Icons.logout),
              ),
            ],
          );
        },
      ),
    );
  }
}
