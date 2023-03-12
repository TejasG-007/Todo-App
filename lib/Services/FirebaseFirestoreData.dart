import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:todo/Constant/StateHelper.dart';

class FirebaseDataStore{

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;


  addTask(user,task)async{
    var result = await _firebaseFirestore.collection("userData").doc(user).collection("Todo").add(task);
  }
  deleteTask(user,taskId)async{
    await _firebaseFirestore.collection("userData").doc(user).collection("Todo").doc(taskId).delete();
  }
  completeTask(user,taskId)async{
    await _firebaseFirestore.collection("userData").doc(user).collection("Todo").doc(taskId).update({"progress":"completed"});
  }
  unCompleteTask(user,taskId)async{
    await _firebaseFirestore.collection("userData").doc(user).collection("Todo").doc(taskId).update({"progress":"in-progress"});
  }
  editTask(user,task,taskId)async{
    await _firebaseFirestore.collection("userData").doc(user).collection("Todo").doc(taskId).set(task);
  }

  completedCount(user)async{
     var count = await _firebaseFirestore.collection("userData").doc(user).collection("Todo").where("progress",isEqualTo: "completed").count().get();
     return count.count;
  }








}