import 'package:todo/Model/Todo.dart';

class User{

  late String userName;
  late String photoUrl;
  late String emailId;
  late List<Todo> todoDataList;

  User({required this.userName,required this.todoDataList,required this.emailId,required this.photoUrl});

  User.fromMap(Map<String,dynamic> user):
  userName = user["userName"],
        photoUrl = user["photoUrl"],
        emailId = user["emailId"],
        todoDataList = user["todoDataList"]
  ;

  toMap()=>{
    "userName":userName,
    "photoUrl":photoUrl,
    "emailId":emailId,
    "todoDataList":todoDataList,
  };
}