import 'package:flutter/material.dart';
import 'package:tasklyai/core/theme/color_app.dart';

class AuthTab extends StatelessWidget {
  final bool isLogin;
  final Function(bool) onChanged;

  const AuthTab({super.key, required this.isLogin, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _tabItem(
            title: 'Đăng nhập',
            active: isLogin,
            onTap: () => onChanged(true),
          ),
          _tabItem(
            title: 'Đăng ký',
            active: !isLogin,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }

  Widget _tabItem({
    required String title,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: active ? Colors.white : Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
