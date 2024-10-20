import 'package:flutter/material.dart';
import 'package:sulala/data/models/animal_model.dart';
import 'package:sulala/utils/enums.dart';

class ItemSearch extends StatelessWidget {
  const ItemSearch({super.key, required this.animalModel});

  final AnimalNode animalModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey.shade200,
            child: Image.asset(animalModel.image),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              animalModel.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "${animalModel.gender == AnimalGender.mail ? "Mail" : "Femail"} , ${animalModel.age} Years",
            )
          ],
        )
      ],
    );
  }
}
