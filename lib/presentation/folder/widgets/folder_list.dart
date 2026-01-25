import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/widgets/dashed_outline_button.dart';
import 'package:tasklyai/core/widgets/folder_empty.dart';
import 'package:tasklyai/models/area_model.dart';
import 'package:tasklyai/models/folder_model.dart';
import 'package:tasklyai/presentation/folder/create_folder_screen.dart';
import 'package:tasklyai/presentation/folder/provider/folder_provider.dart';
import 'package:tasklyai/presentation/folder/widgets/folder_card.dart';

class FolderList extends StatelessWidget {
  const FolderList({super.key, this.areaModel});

  final AreaModel? areaModel;

  @override
  Widget build(BuildContext context) {
    return Selector<FolderProvider, List<FolderModel>>(
      builder: (context, value, child) {
        if (value.isEmpty) {
          return FolderEmpty(areaModel: areaModel);
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return FolderCard(item: value[index], areaModel: areaModel);
                },
              ),
            ),
            DashedOutlineButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateFolderScreen(areaModel: areaModel),
                  ),
                );
              },
              child: Text(
                'Add New Folder',
                style: context.theme.textTheme.titleSmall,
              ),
            ),
          ],
        );
      },
      selector: (context, p) => p.folders,
    );
  }
}
