import 'package:flutter/material.dart';

enum FolderFilterType { all, notes, projects }

class FolderDetailProvider extends ChangeNotifier {
  FolderFilterType _filter = FolderFilterType.all;

  FolderFilterType get filter => _filter;

  void setFilter(FolderFilterType value) {
    _filter = value;
    notifyListeners();
  }
}
