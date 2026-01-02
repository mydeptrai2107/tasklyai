import 'package:flutter/material.dart';
import 'package:tasklyai/models/profile_model.dart';
import 'package:tasklyai/repository/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileModel? _profile;
  ProfileModel? get profile => _profile;

  final ProfileRepository _repository = ProfileRepository();

  Future<void> findMe() async {
    try {
      _profile = await _repository.findMe();
      notifyListeners();
    } catch (_) {}
  }
}
