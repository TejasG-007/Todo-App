import 'package:todo/Constant/ImportFile.dart';

class AddTaskView extends StatefulWidget {
  final Map<String,dynamic> userData;
  final Todo? todoData;
  final WhichTask whichTask;
  final String? docId;
  const AddTaskView({required this.userData,required this.whichTask,this.todoData,this.docId,Key?key}):super(key:key);
  @override
  State createState() => _AddTaskView();
}

class _AddTaskView extends State<AddTaskView> {
  final TextEditingController _taskName = TextEditingController();
  final TextEditingController _taskDesc = TextEditingController();
  final TextEditingController _taskDate = TextEditingController();
  final TextEditingController _taskProgress = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final FirebaseDataStore _dataStore = FirebaseDataStore();
@override
  void initState() {
    if(widget.whichTask==WhichTask.editTask&&widget.todoData!=null){
      _taskName.text = widget.todoData!.task;
      _taskDesc.text=widget.todoData!.desc;
      _taskDate.text = widget.todoData!.date;
    }
    super.initState();
  }

  @override
  void dispose() {
    _taskDesc.dispose();
    _taskName.dispose();
    _taskDate.dispose();
    _taskProgress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        bool? dialogBox = await showDialog<bool>(context: context, builder: (context)=>AlertDialog(
          icon: const Icon(Icons.warning_amber_rounded,color: Colors.orange,size: 50,),
          title: Text(widget.whichTask==WhichTask.addTask?"Task will not be added if you do not click on add task":"Task will not be Updated if you do not click on Update task",style: GoogleFonts.montserrat(

          ),),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context,true);
            }, child: Text("EXIT",style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),)),
            TextButton(onPressed: (){
              Navigator.pop(context,false);
            }, child: Text("OKAY",style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),)),
          ],
        ));
        return dialogBox!;
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: addTaskBackgroundColor,
            centerTitle: true,
            title: Text(widget.whichTask==WhichTask.addTask?
              "Add New Task":"Edit Task",
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: whiteColor),
            ),
          ),
          backgroundColor: addTaskBackgroundColor,
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                     Icon(widget.whichTask==WhichTask.addTask?Icons.task_alt_outlined:Icons.edit_calendar_rounded,size: 50,)
                  ],
                ),
                Container(
                  margin:const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _taskName,
                    validator: (name){
                      return name!.isEmpty? "Task Name should not be Empty.":null;
                    },
                    style: GoogleFonts.montserrat(
                      color: whiteColor,
                    ),
                    decoration:  InputDecoration(
                      hintText: "Task Name",
                      hintStyle: GoogleFonts.montserrat(
                          color: whiteColor
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide:  BorderSide(color: whiteColor),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: whiteColor),
                      ),
                    ),
                  ),

                ),
               const SizedBox(height: 30,),
                Container(
                  margin:const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _taskDesc,
                    validator: (desc){
                      return desc!.isEmpty? "Task Desc should not be Empty.":null;
                    },
                    style: GoogleFonts.montserrat(
                      color: whiteColor,
                    ),
                    decoration:  InputDecoration(
                      hintText: "Task Description",
                      hintStyle: GoogleFonts.montserrat(
                          color: whiteColor
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide:  BorderSide(color: whiteColor),
                      ),
                      focusedBorder:const UnderlineInputBorder(
                        borderSide: BorderSide(color: whiteColor),
                      ),
                    ),
                  ),

                ),
                const SizedBox(height: 30,),
               widget.whichTask==WhichTask.addTask? Consumer<StateHelper>(
                  builder:(context,model,child)=>
                      Container(
                    margin:const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      keyboardType:TextInputType.datetime,
                      onTap: ()async{
                        String tempDate = await datePicker();
                        model.updateTaskDate(tempDate);
                      },
                      controller: _taskDate,
                      validator: (name){
                        return Provider.of<StateHelper>(context,listen: false).date=="Task Date"? "Task Date should not be Empty.":null;
                      },
                      style: GoogleFonts.montserrat(
                        color: whiteColor,
                      ),
                      decoration:  InputDecoration(
                        hintText: model.date ?? "Task date",
                        hintStyle: GoogleFonts.montserrat(
                            color: whiteColor
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide:  BorderSide(color: whiteColor),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: whiteColor),
                        ),
                      ),
                    ),

                  ),
                ):
                Consumer<StateHelper>(
                  builder:(context,model,child)=>
                      Container(
                        margin:const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Row(children: [
                              IconButton(onPressed: ()async{
                                String tempDate = await datePicker();
                                model.updateTaskDate(tempDate);
                              }, icon: const Icon(Icons.calendar_month,color: whiteColor,)),
                            ],),
                            Text(model.date==""?"Date Should not be Empty":"Selected Date ${model.date}",style: GoogleFonts.nunito(
                              color: whiteColor
                            ),)
                          ],
                        ),

                      ),
                ),
                const SizedBox(height: 30,),

                Row(children: [
                  Expanded(child: Container(
                    margin:  const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: addTaskButtonColor
                      ),
                        onPressed: (){

                        if(_formKey.currentState!.validate()){
                          widget.whichTask==WhichTask.addTask?_dataStore.addTask((widget.userData["userId"]).toString(),Todo(taskId: DateTime.now().microsecondsSinceEpoch.toString(), task: _taskName.text, desc: _taskDesc.text, date:Provider.of<StateHelper>(context,listen: false).date, progress: "in-progress").toMap()):_dataStore.editTask((widget.userData["userId"]).toString(),
                              Todo(taskId: DateTime.now().microsecondsSinceEpoch.toString(), task: _taskName.text, desc: _taskDesc.text, date:Provider.of<StateHelper>(context,listen: false).date, progress: "in-progress").toMap(),widget.docId);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.whichTask==WhichTask.addTask?"Added Successfully":"Updated Successfully")));

                        }

                        }, child:Text(widget.whichTask==WhichTask.addTask?"ADD TASK":"UPDATE TASK",style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,color: whiteColor,
                    ))),
                  ))
                ],)
              ],
            ),
          )),
    );
  }
  datePicker()async{
    DateTime? date = await showDatePicker(context: context,firstDate: DateTime.now(),lastDate: DateTime(DateTime.now().year+2), initialDate: DateTime.now());
    return date.toString().substring(0,11);
  }
}
