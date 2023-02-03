import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todoapp/screens/add_page.dart';
import 'package:http/http.dart' as http;
import 'package:todoapp/services/notification_service.dart';

import '../utils/snackbar_helpers.dart';
import '../widgets/todo_cards.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List items = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()), //spinner loading
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          //wraplistview with widget to show no data msg
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
                child: Text(
              'No Todo Item',
              style: Theme.of(context).textTheme.headline3,
            )),
            child: ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.all(12), //for card style
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['notificationId'] as int;
                //wrapped listtile with card for design
                //this replaced with global card file.
                return Todocard(
                    index: index,
                    item: item,
                    navigateEdit: naviageteToEditPage,
                    deleteById: deleteById);
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: naviageteToAddPage, label: Text('Add Todo')),
    );
  }

  Future<void> naviageteToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodo(),
    );
    await Navigator.push(context, route); //imp
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  void naviageteToEditPage(Map item) {
    print('test');
    final route = MaterialPageRoute(
      builder: (context) => AddTodo(todo: item),
    );
    Navigator.push(context, route); //imp
    //refresh page after saved
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> fetchTodo() async {
    // ****without services*** //
    //     final url = 'http://localhost:9152/api/Notifications';
    //     final uri = Uri.parse(url);
    //     final response = await http.get(uri);
    //     // print(response.body);
    //     if (response.statusCode == 200) {
    //       final json = jsonDecode(response.body);
    //       final result = json as List;
    //       setState(() {
    //         // items = result;//normal list
    //         items = List.of(result.reversed); //list reverse.
    //       });
    //     } else {
    // //error
    //       showErrorMessage('Deletion failed');
    //     }
    //     setState(() {
    //       isLoading = false;
    //       //this setstate used refresh list once api bind
    //     });

    // ****without services*** //

    final response = await notificationService.fetchTodos();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      // showErrorMessage('failed to load');
      showErrorMessage_global(context, message: 'Something went wrong');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteById(int id) async {
    // ****without services*** //
    //delete the item
    // final url = 'http://localhost:9152/api/Notifications/$id';
    // final uri = Uri.parse(url);
    // final response =
    //     await http.delete(uri, headers: {'Content-Type': 'application/json'});
    // if (response.statusCode == 200) {
    //   final filtered =
    //       items.where((element) => element['notificationId'] != id).toList();
    //   setState(() {
    //     items = filtered;
    //   });
    // } else {}
    //remove item
    // ****without services*** //

    // ****with services*** //
    final isSuccess = await notificationService.deleteById(id);
    if (isSuccess) {
      final filtered =
          items.where((element) => element['notificationId'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      // showErrorMessage('failed');
      showErrorMessage_global(context, message: 'Something went wrong');
    }
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
