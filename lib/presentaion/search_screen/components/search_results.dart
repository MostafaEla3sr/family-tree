import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sulala/data/providers/animal_controller.dart';
import 'package:sulala/presentaion/search_screen/components/item_search.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({super.key, required this.callBack});

  final Function callBack;

  @override
  Widget build(BuildContext context) {
    return Consumer<AnimalController>(
      builder: (context, provider, child) {
        final searchText = provider.searchText;
        final items = provider.state.sortedAnimalList;
        final filteredItems = items
            .where((item) =>
                item.name.toLowerCase().contains(searchText.toLowerCase()))
            .toList();

        if (filteredItems.isEmpty) {
          return const Center(
            child: Text('No results found'),
          );
        }

        return ListView.builder(
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  provider.chooseAnimal(filteredItems[index]);
                  callBack();
                  Navigator.of(context).pop();
                },
                child: ItemSearch(animalModel: filteredItems[index]),
              ),
            );
          },
        );
      },
    );
  }
}
