import 'package:flutter/material.dart';
import 'package:todo_amplify/screens/home_screen.dart';
import 'package:todo_amplify/services/data_store_service.dart';

class AddTodoScreen extends StatefulWidget {
  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final DataStoreService _dataStoreService = DataStoreService();

  final GlobalKey<FormState> _addTodoFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool autoValidate = false;
  bool showPassword = false;
  bool isBusy = false;
  void setIsBusy(bool newValue) {
    setState(() {
      isBusy = newValue;
    });
  }

  Future<void> addTodo() async {
    final String name = _nameController.text.trim();
    final String description = _descriptionController.text.trim();

    if (_addTodoFormKey.currentState.validate()) {
      setIsBusy(true);
      await _dataStoreService.addTodo(
        name: name,
        description: description,
      );
      setIsBusy(false);

      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Todo"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              isBusy ? LinearProgressIndicator() : SizedBox.shrink(),
              const SizedBox(height: 20),
              Text(
                "Add Todo",
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _addTodoFormKey,
                autovalidateMode: autoValidate
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                      ),
                      maxLength: 80,
                      validator: (String value) {
                        final String trimmedValue = value.trim();

                        if (trimmedValue == "") return "Name cannot be empty!";

                        if (trimmedValue.length < 5)
                          return "Name must be more than 5 characters!";

                        if (trimmedValue.length > 80)
                          return "Name must be less than 80 characters!";

                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                      ),
                      maxLength: 500,
                      validator: (String value) {
                        final String trimmedValue = value.trim();

                        if (trimmedValue == "")
                          return "Description cannot be empty!";

                        if (trimmedValue.length < 15)
                          return "Description must be more than 15 characters!";

                        if (trimmedValue.length > 500)
                          return "Description must be less than 500 characters!";

                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await addTodo();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                "Add Todo",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
