import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/presentation/area/provider/area_provider.dart';
import 'package:tasklyai/presentation/home/home_screen.dart';
import 'package:tasklyai/presentation/profile/profile_screen.dart';
import 'package:tasklyai/presentation/task_project/task_project_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;

  final keys = List.generate(5, (_) => GlobalKey<NavigatorState>());

  @override
  Widget build(BuildContext context) {
    context.read<AreaProvider>().fetchArea();

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: List.generate(5, (i) {
          return Navigator(
            key: keys[i],
            onGenerateRoute: (settings) {
              return MaterialPageRoute(builder: (_) => _rootScreen(i));
            },
          );
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.black54,
        onTap: (i) {
          if (i == index) {
            keys[i].currentState?.popUntil((r) => r.isFirst);
          } else {
            setState(() => index = i);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notes'),
          BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _rootScreen(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const SizedBox();
      case 2:
        return const TaskProjectScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const SizedBox();
    }
  }
}
