import 'package:cap/model/todomodel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  Box<TodoModel> todoBox;

  @override
  void initState() {
  todoBox = Hive.box<TodoModel>('todoBoxName');
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CAP'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value){},
            itemBuilder: (context){
               return ['All', 'Completed', 'Incompleted'].map((option){
                 return PopupMenuItem(
                   value: option,
                   child: Text(option));
               }).toList();
            }
            )
        //  Switch(value: null, onChanged: null),
         // IconButton(icon: Icon(Icons.more_vert), onPressed: () {})
        ],
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          children: <Widget>[

          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            
            context: context,
            child: Dialog(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Title'
                      ),
                    ),
                    SizedBox(height: 7,),
                    TextField(
                      controller: detailsController,
                      decoration: InputDecoration(
                        //border: UnderlineInputBorder(),
                        hintText: 'Details'
                      ),
                    ),
                     SizedBox(height: 7,),
                     Center(
                       child: RaisedButton(
                         color: Colors.black,
                         textColor: Colors.white,
                         onPressed: (){
                           final String title = titleController.text;
                           final String detail = detailsController.text;
                        
                        TodoModel todo = TodoModel(title: title, detail:detail, isCompleted: false);
                        
                        todoBox.add(todo);
                        Navigator.pop(context);
                         }, 
                       child: Text('Add Task')
                       ),
                     )
                  ],
                ),
              ),
            )
            );
        },
      ),
    );
  }
}
