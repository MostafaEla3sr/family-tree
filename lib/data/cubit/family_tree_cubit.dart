import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../models/family_member_model.dart'; // Adjust the import as necessary

class FamilyTreeCubit extends Cubit<List<FamilyMember>> {
  final Dio dio;
  final String token; // Add a token field

  FamilyTreeCubit(this.dio, this.token) : super([]);

  Future<void> fetchRootMember() async {
    try {
      // Fetch the root member from /getTree/0
      final rootResponse = await dio.get(
        '/getTree/0',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('Root Member API Response: ${rootResponse.data}');

      if (rootResponse.data['result']) {
        // If the root response is a list
        List<FamilyMember> rootMembers = (rootResponse.data['data'] as List)
            .map((item) => FamilyMember.fromJson(item))
            .toList();

        // Assuming you want the first member as the root
        FamilyMember rootMember =
            rootMembers.first; // Get the first member from the list

        // Fetch children for the root member from /getTree/5
        final childrenResponse = await dio.get(
          '/getTree/5',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        print('Children API Response: ${childrenResponse.data}');

        if (childrenResponse.data['result']) {
          // Map the children response data to a list of FamilyMember objects
          List<FamilyMember> childrenMembers =
              (childrenResponse.data['data'] as List)
                  .map((item) => FamilyMember.fromJson(item))
                  .toList();

          // Add the children to the root member
          rootMember.children = childrenMembers;

          // Emit the root member with children
          emit([rootMember]); // Emitting a list containing the root member
          print('Emitted Root Member with Children: $rootMember');
        } else {
          print(
              'Error fetching children: ${childrenResponse.data['error_message']}');
        }
      } else {
        print(
            'Error fetching root member: ${rootResponse.data['error_message']}');
      }
    } on DioException catch (e) {
      print('Error fetching root member: ${e.message}');
      if (e.type == DioErrorType.connectionTimeout) {
        print('Connection timeout, please try again later.');
      }
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  Future<void> fetchChildren(int id) async {
    try {
      final response = await dio.get(
        '/getTree/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Add the token to headers
          },
        ),
      );

      if (response.data['result']) {
        List<FamilyMember> children = (response.data['data'] as List)
            .map((item) => FamilyMember.fromJson(item))
            .toList();

        // Add children to the correct parent in the current state
        final currentState =
            state.toList(); // Create a copy of the current state
        for (var member in currentState) {
          if (member.id == id) {
            member.children.addAll(children); // Add children to the parent
            print('Added children to member ${member.fullName}: $children');
            break;
          }
        }
        emit(currentState); // Emit the updated state
        print(
            'Updated State with Children: ${currentState}'); // Log updated state
      } else {
        print('Error fetching children: ${response.data['error_message']}');
      }
    } catch (e) {
      print('Error fetching children: $e');
    }
  }
}
