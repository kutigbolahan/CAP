import 'package:cap/model/todomodel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum TodoFilter { ALL, COMPLETED, INCOMPLETED }

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  Box<TodoModel> todoBox;
  TodoFilter todoFilter = TodoFilter.ALL;

  @override
  void initState() {
    todoBox = Hive.box<TodoModel>('todoBoxName');
    super.initState();
  }
@override
  void dispose() {
   Hive.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CAP'),
        actions: <Widget>[
          PopupMenuButton<String>(onSelected: (value) {
            if (value.compareTo('All') == 0) {
              setState(() {
                todoFilter = TodoFilter.ALL;
              });
            } else if (value.compareTo('COMPLETED') == 0) {
              setState(() {
                todoFilter = TodoFilter.COMPLETED;
              });
            } else {
              setState(() {
                todoFilter = TodoFilter.INCOMPLETED;
              });
            }
          }, itemBuilder: (context) {
            return ['All', 'Completed', 'Incompleted'].map((option) {
              return PopupMenuItem(value: option, child: Text(option));
            }).toList();
          })
          //  Switch(value: null, onChanged: null),
          // IconButton(icon: Icon(Icons.more_vert), onPressed: () {})
        ],
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          children: <Widget>[
            ValueListenableBuilder(
              valueListenable: todoBox.listenable(),
              builder: (BuildContext context, Box<TodoModel> todos, _) {
                //to get list from the box

                List<int> keys;

                if (todoFilter == TodoFilter.ALL) {
                  keys = todos.keys.cast<int>().toList();
                } else if (todoFilter == TodoFilter.COMPLETED) {
                  keys = todos.keys
                      .cast<int>()
                      .where((key) => todos.get(key).isCompleted)
                      .toList();
                } else if (todoFilter == TodoFilter.INCOMPLETED){
                  keys = todos.keys
                      .cast<int>()
                      .where((key) => !todos.get(key).isCompleted)
                      .toList();
                }

                return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      final int key = keys[index];
                      final TodoModel todo = todos.get(key);
                      return ListTile(
                        trailing: todo.isCompleted
                            ? Icon(
                                Icons.star,
                                color: Colors.black,
                              )
                            : Icon(
                                Icons.star_border,
                              ),
                        title: Text(todo.title),
                        subtitle: Text(todo.detail),
                        leading: Text('$key'),
                        onTap: () {
                          showDialog(
                              context: context,
                              child: Dialog(
                                child: Container(
                                  padding:
                                      const EdgeInsets.only(top: 16, right: 16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text('Mark as Completed'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          FlatButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('No')),
                                          RaisedButton(
                                              color: Colors.black,
                                              textColor: Colors.white,
                                              onPressed: () {
                                                //to update the we rewtite or overwrite in the table
                                                TodoModel modifiedTodo =
                                                    TodoModel(
                                                        title: todo.title,
                                                        detail: todo.detail,
                                                        isCompleted: true);
                                                todoBox.put(key, modifiedTodo);
                                                Navigator.pop(context);
                                              },
                                              child: Text('Yes')),
                                        ],
                                      )

                                      //  Center(
                                      //    child: RaisedButton(
                                      //      color: Colors.black,
                                      //      textColor: Colors.white,
                                      //      onPressed: (){
                                      //       //to update the we rewtite or overwrite in the table
                                      //       TodoModel modifiedTodo = TodoModel(title:todo.title, detail: todo.detail, isCompleted: true);
                                      //       todoBox.put(key, modifiedTodo);
                                      //       Navigator.pop(context);
                                      //      },
                                      //    child: Text('Mark as Completed')
                                      //    ),
                                      //  )
                                    ],
                                  ),
                                ),
                              ));
                        },
                      );
                    },
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: keys.length);
              },
            ),
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
                        decoration: InputDecoration(hintText: 'Title'),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      TextField(
                        controller: detailsController,
                        decoration: InputDecoration(
                            //border: UnderlineInputBorder(),
                            hintText: 'Details'),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Center(
                        child: RaisedButton(
                            color: Colors.black,
                            textColor: Colors.white,
                            onPressed: () {
                              final String title = titleController.text;
                              final String detail = detailsController.text;

                              TodoModel todo = TodoModel(
                                  title: title,
                                  detail: detail,
                                  isCompleted: false);

                              todoBox.add(todo);
                              titleController.clear();
                              detailsController.clear();
                              Navigator.pop(context);
                            },
                            child: Text('Add Task')),
                      )
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
