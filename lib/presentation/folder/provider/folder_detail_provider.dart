import 'package:flutter/material.dart';

enum FolderFilterType { all, notes, projects }

class FolderDetailProvider extends ChangeNotifier {
  FolderFilterType _filter = FolderFilterType.all;

  FolderFilterType get filter => _filter;

  void setFilter(FolderFilterType value) {
    _filter = value;
    notifyListeners();
  }

  // fake data
  final List<String> notes = [
    'API Documentation',
    'Meeting Summary',
    'Backend Notes',
    'Backend Notes',
    'Backend Notes',
    'Backend Notes',
    'Backend Notes',
    'Backend Notes',
  ];

  final List<String> projects = ['Client Mobile App', 'Admin Dashboard'];

  bool get hasNotes => notes.isNotEmpty;
  bool get hasProjects => projects.isNotEmpty;
}
