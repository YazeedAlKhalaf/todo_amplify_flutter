import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_flutter/categories/amplify_categories.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_amplify/models/Todo.dart';
import 'package:todo_amplify/services/auth_service.dart';
import 'package:amplify_datastore_plugin_interface/src/types/query/query_field.dart';

class DataStoreService {
  final AuthService _authService = AuthService();
  final DataStoreCategory _amplifyDataStore = Amplify.DataStore;

  Future<List<Todo>> getTodos() async {
    try {
      final AuthUser _authUser = await _authService.getCurrentUser();
      List<Todo> todoList = await _amplifyDataStore.query(
        Todo.classType,
        where: QueryPredicateOperation(
          "ownerId",
          EqualQueryOperator(_authUser.userId),
        ),
      );

      return todoList;
    } on DataStoreException catch (e) {
      print('Query failed: $e');

      return null;
    }
  }

  Future<void> addTodo({
    @required String name,
    @required String description,
  }) async {
    try {
      final AuthUser _authUser = await _authService.getCurrentUser();
      await _amplifyDataStore.save(
        Todo(
          name: name,
          description: description,
          done: false,
          ownerId: _authUser.userId,
        ),
      );
    } on DataStoreException catch (e) {
      print('Query failed: $e');

      return null;
    }
  }
}
