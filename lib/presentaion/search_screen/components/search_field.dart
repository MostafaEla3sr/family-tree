import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sulala/data/providers/animal_controller.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AnimalController>(
      builder: (context, searchProvider, child) {
        return Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (text) {
                  searchProvider.updateSearchText(text);
                },
                controller: searchProvider.searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(30)),
                child: IconButton(
                  onPressed: () {
                    searchProvider.searchController.clear();
                    searchProvider.updateSearchText('');
                  },
                  icon: const Icon(Icons.clear),
                ))
          ],
        );
      },
    );
  }
}
