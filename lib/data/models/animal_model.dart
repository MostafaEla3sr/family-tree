import 'package:sulala/utils/enums.dart';

class AnimalNode {
  AnimalNode({
    required this.id,
    required this.name,
    required this.status,
    required this.image,
    required this.gender,
    this.age,
    required this.children,
  });

  final String name;
  final String id;
  final AnimalStatus status;
  final String image;
  final AnimalGender gender;
  int? age;
  List<AnimalNode> children = [];
}
