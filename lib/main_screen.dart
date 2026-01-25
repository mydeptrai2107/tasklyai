import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/presentation/area/provider/area_provider.dart';
import 'package:tasklyai/presentation/folder/folder_screen.dart';
import 'package:tasklyai/presentation/home/home_screen.dart';
import 'package:tasklyai/presentation/profile/profile_screen.dart';
import 'package:tasklyai/presentation/project/project_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;

  final keys = List.generate(4, (_) => GlobalKey<NavigatorState>());
  final tabVersions = List.filled(4, 0);

  @override
  Widget build(BuildContext context) {
    context.read<AreaProvider>().fetchArea();

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: List.generate(4, (i) {
          return KeyedSubtree(
            key: ValueKey('tab-$i-${tabVersions[i]}'),
            child: Navigator(
              key: keys[i],
              onGenerateRoute: (settings) {
                return MaterialPageRoute(builder: (_) => _rootScreen(i));
              },
            ),
          );
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.black54,
        onTap: (i) {
          setState(() {
            index = i;
            tabVersions[i] += 1;
            keys[i] = GlobalKey<NavigatorState>();
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Folder'),
          BottomNavigationBarItem(
            icon: Icon(Icons.workspaces),
            label: 'Project',
          ),
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
        return const FolderScreen();
      case 2:
        return const ProjectScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const SizedBox();
    }
  }
}
