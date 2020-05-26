import 'package:cap/homepage.dart';
import 'package:cap/model/th.dart';
import 'package:cap/model/todomodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
const darkModeBox = 'darkModeTutorial';
List<Box> boxList =[];
Future<List<Box>> _openBox() async{
 var document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  var todoBox =await Hive.openBox<TodoModel>('todoBoxName');
 var themeBox = await Hive.openBox(darkModeBox);
  boxList.add(todoBox);
  boxList.add(themeBox);
  return boxList;

}

void main() async{
 WidgetsFlutterBinding.ensureInitialized();
 await _openBox();
 
  
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   bool isDark = false;
   @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: isDark ? Constants.darkPrimary : Constants.lightPrimary,
      statusBarIconBrightness: isDark?Brightness.light:Brightness.dark,
    ));
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      theme:  isDark ? Constants.darkTheme : Constants.lightTheme,
      home: MyHomePage(),
    );
  }
}

