import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:todoapp/services/notification_service.dart';
import 'package:todoapp/utils/snackbar_helpers.dart';

class AddTodo extends StatefulWidget {
final Map? todo;
  const AddTodo({
   super.key,
    this.todo,
  });

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit =false;
//by typing init you will get below code
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   final todo= widget.todo;
    if(todo !=null){
      isEdit=true;
     print(todo);
     final message=todo['message'];
     descriptionController.text=message;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
         isEdit? 'Edit Todo':'Add Todo'),
      ),
      body: ListView(
        //List view no overflow and scrolable
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: isEdit? updateData: submitData,
            //here u want padding for text then click on text then click on yellow symbl to wrap with paddig
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                isEdit ? 'Update':'Submit'),
            ),
          )
        ],
      ),
    );
  }

  Future<void> submitData() async {
    //get the data from the form

   
  
    final isSuccess =await notificationService.addTodo(body);
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
    showSuccessMessage_global(context,message: 'created successfully');
    } else {
      showErrorMessage_global(context,message: 'failed');
    }
  }
  Future<void> updateData() async {
    final todo=widget.todo;
    if(todo == null){
      return;
    }
    //get the data from the form
    final id=todo['notificationId'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "notificationId": 0,
      "memberId": 11024,
      "senderId": 11024,
      "message": description,
      "isRead": false,
    };

    //http
    final url = 'http://localhost:9152/api/Notifications/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    //submit data to ther server
    //show success of fail message based on status
    print(response);
    if (response.statusCode == 200) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage_global(context,message:'Uptaed successfully');
    } else {
      showErrorMessage_global(context,message:'failed');
    }
  }

//use body for both create and update
//imp
Map get body{
     final title = titleController.text;
    final description = descriptionController.text;
    return  {
      "notificationId": 0,
      "memberId": 11024,
      "senderId": 11024,
      "message": description,
      "isRead": false,
    };

}
}