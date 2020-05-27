
import 'package:hive/hive.dart';
part 'todomodel.g.dart';

@HiveType()
class TodoModel{
  @HiveField(0)
  final String title;
   @HiveField(1)
  final String detail;
   @HiveField(2)
  final bool isCompleted;

  TodoModel({this.title, this.detail, this.isCompleted});
}