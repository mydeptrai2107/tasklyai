import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tasklyai/models/card_model.dart';
import 'package:tasklyai/presentation/calendar/widgets/card_calender_widget.dart';
import 'package:tasklyai/presentation/notes/provider/note_provider.dart';

class CalendarTaskScreen extends StatefulWidget {
  const CalendarTaskScreen({super.key});

  @override
  State<CalendarTaskScreen> createState() => _CalendarTaskScreenState();
}

class _CalendarTaskScreenState extends State<CalendarTaskScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteProvider>().fetchAllCard();
    });
  }

  /// 🔁 Group task theo ngày (YYYY-MM-DD)
  Map<DateTime, List<CardModel>> _groupTasksByDate(List<CardModel> tasks) {
    final Map<DateTime, List<CardModel>> map = {};

    for (final task in tasks) {
      if (task.dueDate == null) continue;

      final key = DateTime(
        task.dueDate!.year,
        task.dueDate!.month,
        task.dueDate!.day,
      );

      map.putIfAbsent(key, () => []);
      map[key]!.add(task);
    }

    return map;
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.watch<NoteProvider>();
    final allTasks = noteProvider.allCard;

    final tasksByDate = _groupTasksByDate(allTasks);

    List<CardModel> getTasksForDay(DateTime day) {
      final key = DateTime(day.year, day.month, day.day);
      return tasksByDate[key] ?? [];
    }

    final tasksToday = getTasksForDay(_selectedDay);

    return Scaffold(
      appBar: buildCalendarAppBar(context),
      body: Column(
        children: [
          /// 📅 CALENDAR
          TableCalendar<CardModel>(
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2035),
            focusedDay: _focusedDay,

            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),

            eventLoader: getTasksForDay,

            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },

            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue.withAlpha(32),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),

            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return null;

                return Positioned(
                  bottom: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      events.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: tasksToday.isEmpty
                ? const Center(
                    child: Text(
                      'No tasks for this day',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: tasksToday.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 8),
                    itemBuilder: (_, index) {
                      final task = tasksToday[index];

                      return CardCalenderWidget(task);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget buildCalendarAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(96),
      child: Container(
        padding: const EdgeInsets.only(
          top: 48,
          left: 16,
          right: 16,
          bottom: 16,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4F8DFD), Color(0xFF6CA8FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Calendar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Your tasks overview',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),

            const Spacer(),

            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(33),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.today_rounded, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
