import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/widgets/area_empty.dart';
import 'package:tasklyai/presentation/area/area_detail_screen.dart';
import 'package:tasklyai/presentation/area/provider/area_provider.dart';
import 'package:tasklyai/presentation/area/quick_area_screen.dart';
import 'package:tasklyai/presentation/area/widgets/area_card.dart';
import 'package:tasklyai/presentation/calendar/calendar_task_screen.dart';
import 'package:tasklyai/presentation/home/widgets/header_widget.dart';
import 'package:tasklyai/presentation/notes/create_note_ai_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AreaProvider>().fetchArea();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderWidget(),
            _aiNoteSection(context),
            _calendarSection(context),
            const SizedBox(height: 24),
            _workspaceSection(context),
          ],
        ),
      ),
    );
  }

  // ================= AI NOTE =================
  Widget _aiNoteSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return CreateNoteAIScreen();
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF6C5CE7), // Purple
                Color(0xFF00D2FF), // Cyan
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(40),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Create Note with AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Let AI analyze and create tasks for you',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= CALENDAR =================
  Widget _calendarSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return CalendarTaskScreen();
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(30),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Calendar & Schedule',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  // ================= WORKSPACE =================
  Widget _workspaceSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Your Workspaces",
                style: context.theme.textTheme.titleMedium,
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QuickAreaScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "+ New",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Consumer<AreaProvider>(
            builder: (context, value, _) {
              if (value.areas.isEmpty) {
                return const AreaEmpty();
              }
              return ListView.builder(
                itemCount: value.areas.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = value.areas[index];
                  return AreaCard(
                    area: item,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AreaDetailScreen(item),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
