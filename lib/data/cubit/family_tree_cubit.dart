// cubit/family_tree_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../models/family_member_model.dart'; // Adjust the import as necessary

class FamilyTreeCubit extends Cubit<List<FamilyMember>> {
  final Dio dio;
  final String token;

  FamilyTreeCubit(this.dio, this.token) : super([]);

  Future<void> fetchRootMember() async {
    try {
      final rootResponse = await dio.get(
        '/getTree/0',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (rootResponse.data['result']) {
        List<FamilyMember> rootMembers = (rootResponse.data['data'] as List)
            .map((item) => FamilyMember.fromJson(item))
            .toList();

        FamilyMember rootMember = rootMembers.first;

        final childrenResponse = await dio.get(
          '/getTree/5',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        if (childrenResponse.data['result']) {
          List<FamilyMember> childrenMembers =
              (childrenResponse.data['data'] as List)
                  .map((item) => FamilyMember.fromJson(item))
                  .toList();

          rootMember.children = childrenMembers;
          emit([rootMember]);
        }
      }
    } catch (e) {
      print('Error fetching root member: $e');
    }
  }

  Future<void> fetchChildren(int id) async {
    try {
      final response = await dio.get(
        '/getTree/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data['result']) {
        List<FamilyMember> children = (response.data['data'] as List)
            .map((item) => FamilyMember.fromJson(item))
            .toList();

        final currentState = state;
        for (var member in currentState) {
          if (member.id == id) {
            member.children.addAll(children);
            break;
          }
        }
        emit([...currentState]);
      }
    } catch (e) {
      print('Error fetching children: $e');
    }
  }
}
