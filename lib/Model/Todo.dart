class Todo{
  late String taskId;
  late String task;
  late String desc;
  late String date;
  late String progress;

  Todo({required this.taskId,required this.task, required this.desc, required this.date,required this.progress});

  toMap() => {"taskId":taskId,"task": task, "desc": desc, "date": date,"progress":progress};

  Todo.fromMap(Map<String,dynamic> todo):taskId=todo["taskId"],task=todo["task"],desc=todo["desc"],date=todo["date"],progress=todo["progress"];
}
