import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:todo_amplify/models/Todo.dart';
import 'package:todo_amplify/screens/add_todo_screen.dart';
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
                    Text(
                      "Hello ${_authUser.username}!",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
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
                                  trailing: IconButton(
                                    icon: Icon(
                                      todo.done
                                          ? Icons.check_rounded
                                          : Icons.close_rounded,
                                      color:
                                          todo.done ? Colors.green : Colors.red,
                                    ),
                                    onPressed: () {},
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
