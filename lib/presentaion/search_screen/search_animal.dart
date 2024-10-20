import 'package:flutter/material.dart';
import 'package:sulala/presentaion/search_screen/components/search_field.dart';

import 'components/search_results.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key, required this.callBack});

  final Function callBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: SearchField(),
            ),
            Expanded(
              child: SearchResults(callBack: () {
                callBack();
              }),
            ),
          ],
        ),
      ),
    );
  }
}
