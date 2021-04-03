import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:todo_amplify/models/Todo.dart';
import 'package:todo_amplify/screens/add_todo_screen.dart';
import 'package:todo_amplify/screens/login_screen.dart';
import 'package:todo_amplify/services/auth_service.dart';
import 'package:todo_amplify/services/data_store_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final DataStoreService _dataStoreService = DataStoreService();

  AuthUser _authUser;
  List<Todo> _todoList;

  @override
  void initState() {
    super.initState();

    _authService.getCurrentUser().then((AuthUser authUser) {
      setState(() {
        _authUser = authUser;
      });

      getTodos();
    });
  }

  Future<void> getTodos() async {
    final List<Todo> todoListTemp = await _dataStoreService.getTodos();

    setState(() {
      _todoList = todoListTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _authUser != null
            ? Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Hello ${_authUser.username}!",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.exit_to_app_rounded,
                            color: Colors.red,
                            size: 25,
                          ),
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Are you sure?",
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Are you sure you want to sign out?",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Cancel",
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                await _authService.signOut();
                                                await _dataStoreService
                                                    .clearLocalDataStore();
                                                await Navigator
                                                    .pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        LoginScreen(),
                                                  ),
                                                  (route) => false,
                                                );
                                              },
                                              child: Text(
                                                "I am sure!",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Todos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    Expanded(
                      child: _todoList != null
                          ? ListView.builder(
                              itemCount: _todoList.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                final Todo todo = _todoList[index];
                                return ListTile(
                                  title: Text(todo.name),
                                  subtitle: Text(todo.description.length > 30
                                      ? todo.description.substring(0, 30) +
                                          '...'
                                      : todo.description),
                                  trailing: Checkbox(
                                    value: todo.done,
                                    onChanged: (bool newValue) async {
                                      await _dataStoreService.updateTodo(
                                        id: todo.id,
                                        name: todo.name,
                                        description: todo.description,
                                        done: newValue,
                                      );

                                      await getTodos();
                                    },
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Text(
                                "No Todos!",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await getTodos();
                      },
                      child: Text("Refresh"),
                    ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTodoScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
