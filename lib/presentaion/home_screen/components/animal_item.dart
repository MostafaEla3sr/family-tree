import 'package:flutter/material.dart';
import 'package:sulala/data/models/animal_model.dart';
import 'package:sulala/utils/enums.dart';

class AnimalItem extends StatelessWidget {
  const AnimalItem({super.key, required this.animalModel});

  final AnimalNode animalModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.grey.shade200,
              child: Image.asset(animalModel.image),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                animalModel.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                animalModel.gender == AnimalGender.mail
                    ? Icons.male
                    : Icons.female,
                color: Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'ID #${animalModel.id}',
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            animalModel.status.displayText,
            style: TextStyle(
              fontSize: 16,
              color: animalModel.status.displayText == 'Dead'
                  ? Colors.red
                  : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
