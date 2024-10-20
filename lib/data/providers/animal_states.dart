import 'package:flutter/material.dart';
import 'package:sulala/data/models/animal_model.dart';
import 'package:sulala/utils/app_assets.dart';
import 'package:sulala/utils/enums.dart';

class AnimalStates {
  TextEditingController searchController = TextEditingController();
  SearchController animalSearchController = SearchController();
  List<AnimalNode> animalTreeList = [];
  List<AnimalNode> sortedAnimalList = [
    AnimalNode(
        id: '000123',
        name: 'Makood',
        status: AnimalStatus.borrowed,
        image: AppAssets.defaultAnimal,
        gender: AnimalGender.femail,
        age: 12,
        children: []),
    AnimalNode(
        id: '123456',
        name: 'Hokeya',
        status: AnimalStatus.sold,
        image: AppAssets.defaultAnimal1,
        gender: AnimalGender.mail,
        age: 20,
        children: []),
    AnimalNode(
        id: '654321',
        name: 'Tauknkd',
        status: AnimalStatus.borrowed,
        image: AppAssets.defaultAnimal2,
        gender: AnimalGender.femail,
        age: 8,
        children: []),
    AnimalNode(
        id: '854545',
        name: 'Kakoo',
        status: AnimalStatus.dead,
        image: AppAssets.defaultAnimal3,
        gender: AnimalGender.mail,
        age: 10,
        children: []),
    AnimalNode(
        id: '8929283',
        name: 'Kakbbo',
        status: AnimalStatus.borrowed,
        image: AppAssets.defaultAnimal3,
        gender: AnimalGender.femail,
        age: 11,
        children: []),
    AnimalNode(
        id: '899545',
        name: 'Manoo',
        status: AnimalStatus.sold,
        image: AppAssets.defaultAnimal2,
        gender: AnimalGender.mail,
        age: 19,
        children: []),
    AnimalNode(
        id: '09289',
        name: 'koky',
        status: AnimalStatus.sold,
        image: AppAssets.defaultAnimal1,
        gender: AnimalGender.mail,
        age: 10,
        children: []),
  ];
  AnimalNode? selectedAnimalNode;
  AnimalNode? currentAnimalNode;
}
