import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/models/project_model.dart';
import 'package:tasklyai/models/project_share_model.dart';
import 'package:tasklyai/presentation/project/provider/project_provider.dart';

class ProjectShareScreen extends StatefulWidget {
  const ProjectShareScreen({super.key, required this.project});

  final ProjectModel project;

  @override
  State<ProjectShareScreen> createState() => _ProjectShareScreenState();
}

class _ProjectShareScreenState extends State<ProjectShareScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProvider>().fetchSharedUsers(widget.project.id);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(widget.project.color);
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          _topHeader(color),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _shareCard(color),
                  const SizedBox(height: 16),
                  Expanded(child: _sharedList()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topHeader(Color color) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16,
        right: 12,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          const BackButton(color: Colors.white),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              'Share Project',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shareCard(Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  IconData(widget.project.icon, fontFamily: 'MaterialIcons'),
                  color: color,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.project.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Enter email to share',
              prefixIcon: const Icon(Icons.email_outlined),
              filled: true,
              fillColor: const Color(0xFFF2F3F7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _share,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Share'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sharedList() {
    return Consumer<ProjectProvider>(
      builder: (context, provider, _) {
        if (provider.shareLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        final summary = provider.shareSummary;
        if (summary == null || summary.shares.isEmpty) {
          return const Center(
            child: Text('No shared users yet.'),
          );
        }
        return ListView.separated(
          itemCount: summary.shares.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final share = summary.shares[index];
            return _shareTile(share);
          },
        );
      },
    );
  }

  Widget _shareTile(SharedUser share) {
    final user = share.user;
    final initials =
        user.name.isNotEmpty ? user.name.trim().substring(0, 1) : 'U';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 6)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: primaryColor.withAlpha(20),
            child: Text(
              initials,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  user.email,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: primaryColor.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              share.permission,
              style: const TextStyle(
                color: primaryColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.redAccent),
            onPressed: () => _unshare(user.id),
          ),
        ],
      ),
    );
  }

  Future<void> _share() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      DialogService.error(context, message: 'Email is required');
      return;
    }
    setState(() => _isSubmitting = true);
    await context.read<ProjectProvider>().shareProject(
          context,
          widget.project.id,
          email,
        );
    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
      _emailController.clear();
    });
  }

  void _unshare(String userId) {
    DialogService.confirm(
      context,
      message: 'Remove access for this user?',
      onConfirm: () {
        context.read<ProjectProvider>().unshareProject(
              context,
              widget.project.id,
              userId,
            );
      },
    );
  }
}
