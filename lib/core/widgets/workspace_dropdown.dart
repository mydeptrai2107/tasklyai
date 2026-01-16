import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/widgets/icon_int.dart';
import 'package:tasklyai/models/area_model.dart';
import 'package:tasklyai/presentation/area/provider/area_provider.dart';

class WorkspaceDropdown extends StatefulWidget {
  final ValueChanged<AreaModel> onChanged;
  final AreaModel? initValue;

  const WorkspaceDropdown({super.key, required this.onChanged, this.initValue});

  @override
  State<WorkspaceDropdown> createState() => _WorkspaceDropdownState();
}

class _WorkspaceDropdownState extends State<WorkspaceDropdown> {
  AreaModel? areaSelected;

  @override
  void initState() {
    areaSelected = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final workSpace = context.watch<AreaProvider>().areas;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _showBottomSheet(context, workSpace),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            if (areaSelected != null)
              IconInt(icon: areaSelected!.icon, color: areaSelected!.color),
            const SizedBox(width: 12),
            if (areaSelected != null)
              Expanded(
                child: Text(
                  areaSelected!.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            Spacer(),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, List<AreaModel> workspaces) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: workspaces.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, index) {
            final ws = workspaces[index];
            return ListTile(
              leading: IconInt(icon: ws.icon, color: ws.color),
              title: Text(
                ws.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                ws.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.pop(context);
                widget.onChanged(ws);
                areaSelected = ws;
                setState(() {});
              },
            );
          },
        );
      },
    );
  }
}
