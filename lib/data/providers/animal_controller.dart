import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sulala/data/models/animal_model.dart';
import 'package:sulala/data/providers/animal_states.dart';

class AnimalController with ChangeNotifier {
  final state = AnimalStates();

  notifyState() {
    notifyListeners();
  }

  String _searchText = '';
  TextEditingController searchController = TextEditingController();

  String get searchText => _searchText;

  void updateSearchText(String newText) {
    _searchText = newText;
    notifyListeners();
  }

  void chooseAnimal(AnimalNode animal) {
    state.selectedAnimalNode = animal;
    notifyListeners();
  }

  void updateCurrentAnimalNode(AnimalNode current) {
    state.currentAnimalNode = current;
    notifyListeners();
  }
}
