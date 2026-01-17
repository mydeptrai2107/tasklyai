import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/constant.dart';
import 'package:tasklyai/core/configs/local_storage.dart';
import 'package:tasklyai/presentation/auth/auth_screen.dart';
import 'package:tasklyai/presentation/profile/change_password_screen.dart';
import 'package:tasklyai/presentation/profile/edit_profile_bottom_sheet.dart';
import 'package:tasklyai/presentation/profile/provider/profile_provider.dart';
import 'package:tasklyai/presentation/profile/widgets/logout_button.dart';
import 'package:tasklyai/presentation/profile/widgets/profile_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProfileProvider>().findMe();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6FA1FF),
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () {
                if (profile != null) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => EditProfileBottomSheet(profile),
                  );
                }
              },
              child: Icon(Icons.edit_outlined, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ProfileHeader(),
            const SizedBox(height: 16),
            _ProgressCard(),
            const SizedBox(height: 24),
            _AccountSection(),
            Spacer(),
            LogoutButton(
              onLogout: () {
                LocalStorage.remove(kToken);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AuthScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'Your Progress',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Icon(Icons.trending_up, color: Colors.blue),
            ],
          ),
          const SizedBox(height: 16),
          _ProgressRow(
            title: 'Tasks Completed',
            valueText: '1/11',
            progress: 0.1,
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          _ProgressRow(
            title: 'Active Projects',
            valueText: '9',
            progress: 0.7,
            color: Colors.green,
          ),
          const SizedBox(height: 12),
          _ProgressRow(
            title: 'Notes Created',
            valueText: '5',
            progress: 0.4,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String title;
  final String valueText;
  final double progress;
  final Color color;

  const _ProgressRow({
    required this.title,
    required this.valueText,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Text(title), const Spacer(), Text(valueText)]),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: color.withAlpha(50),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

class _AccountSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _AccountItem(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ChangePasswordScreen();
                },
              ),
            );
          },
          icon: Icons.lock_outline,
          title: 'Change Password',
        ),
      ],
    );
  }
}

class _AccountItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final void Function()? onTap;

  const _AccountItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.blue),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
            if (trailing != null) trailing!,
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
