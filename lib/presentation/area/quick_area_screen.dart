import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/presentation/area/create_area_screen.dart';

class AreaTemplate {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  AreaTemplate({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

class QuickAreaScreen extends StatefulWidget {
  const QuickAreaScreen({super.key});

  @override
  State<QuickAreaScreen> createState() => _QuickAreaScreenState();
}

class _QuickAreaScreenState extends State<QuickAreaScreen> {
  final List<AreaTemplate> templates = [
    AreaTemplate(
      icon: Icons.work,
      title: 'Work',
      subtitle: 'Career, projects, and office tasks',
      color: Colors.brown,
    ),
    AreaTemplate(
      icon: Icons.home,
      title: 'Personal',
      subtitle: 'Daily life, habits, and personal goals',
      color: Colors.redAccent,
    ),
    AreaTemplate(
      icon: Icons.school,
      title: 'Learning',
      subtitle: 'Study, courses, and skill development',
      color: Colors.green,
    ),
    AreaTemplate(
      icon: Icons.favorite,
      title: 'Health',
      subtitle: 'Fitness, wellness, and self-care',
      color: Colors.orange,
    ),
    AreaTemplate(
      icon: Icons.attach_money,
      title: 'Finance',
      subtitle: 'Budgeting, expenses, and savings',
      color: Colors.amber,
    ),
    AreaTemplate(
      icon: Icons.palette,
      title: 'Creative',
      subtitle: 'Art, design, and creative ideas',
      color: Colors.pink,
    ),
    AreaTemplate(
      icon: Icons.people,
      title: 'Social',
      subtitle: 'Friends, family, and relationships',
      color: Colors.yellow,
    ),
    AreaTemplate(
      icon: Icons.flight_takeoff,
      title: 'Travel',
      subtitle: 'Trips, plans, and travel experiences',
      color: Colors.blue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Area',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F2FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick Start: Choose a Template',
                style: context.theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 16),

              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: templates.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.4,
                  ),
                  itemBuilder: (context, index) {
                    final item = templates[index];
                    return _TemplateItem(item: item);
                  },
                ),
              ),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateAreaScreen(),
                      ),
                    );
                  },
                  child: const Text('Create custom area instead'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TemplateItem extends StatelessWidget {
  final AreaTemplate item;

  const _TemplateItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateAreaScreen(areaTemplate: item),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(item.icon, color: item.color),
            const Spacer(),
            Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              item.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
