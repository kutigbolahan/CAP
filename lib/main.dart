import 'package:cap/homepage.dart';
import 'package:cap/model/todomodel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

List<Box> boxList =[];
Future<List<Box>> _openBox() async{
 var document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  var todoBox =await Hive.openBox<TodoModel>('todoBoxName');
 var themeBox = await Hive.openBox('darkModeBox');
  boxList.add(todoBox);
  boxList.add(themeBox);
  return boxList;

}

void main() async{
 WidgetsFlutterBinding.ensureInitialized();
 await _openBox();
 
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     
      theme: ThemeData(
       
      
       
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

