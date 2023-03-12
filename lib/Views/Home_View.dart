import 'package:todo/Constant/ImportFile.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State createState() => _HomeViewState();
}

class _HomeViewState extends State {
  final ScrollController _controller = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Authentication _authentication = Authentication();
  final FirebaseDataStore _dataStore = FirebaseDataStore();
  final itemSize = 100.0;
  var size = 0.0;
  var totalSize = 0.0;

  late Map<String, dynamic> userData;
  updateCount() async {
    Provider.of<StateHelper>(context, listen: false)
        .setCompletedCount(await _dataStore.completedCount(userData["userId"]));
  }

  @override
  void initState() {
    userData = _authentication.userDetails();
    _controller.addListener(() {
      try {
        totalSize = _controller.position.maxScrollExtent;
        size = _controller.offset;
        var temp = size / totalSize;
        var temp2 = temp.toString().length > 4
            ? temp.toString().substring(0, 4)
            : temp.toString();
        Provider.of<StateHelper>(context, listen: false)
            .updatingProgressIndicator(double.parse(temp2));
      } catch (e) {
        throw "$e facing issue";
      }
    });
    updateCount();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        bool? dialogBox = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
                  icon: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 50,
                  ),
                  title: Text(
                    "Do you want to exit?",
                    style: GoogleFonts.montserrat(),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text(
                          "YES",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: Text(
                          "NO",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ));
        return dialogBox!;
      },
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          drawer: Drawer(
            child: Column(
              children: [
                SizedBox(
                  height: height * .05,
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: userData["photoUrl"] == null
                        ? Container()
                        : Image.network(userData["photoUrl"]),
                  ),
                  title: Text(
                    userData["userName"] ?? "fetching..",
                    style: GoogleFonts.nunito(),
                  ),
                  subtitle: Text(userData["emailId"] ?? "fetching..",
                      style: GoogleFonts.nunito()),
                  style: ListTileStyle.drawer,
                ),
                const Spacer(),
                IconButton(
                  tooltip: "Log out",
                  icon: const Icon(
                    Icons.logout_outlined,
                    color: Colors.red,
                    size: 35,
                  ),
                  onPressed: () {
                    _authentication.signOut();
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 8,
            enableFeedback: true,
            child: const Icon(Icons.add),
            onPressed: () {
              Provider.of<StateHelper>(context,listen: false).updateTaskDate("Task Date");
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      AddTaskView(
                      userData: userData, whichTask: WhichTask.addTask)));
            },
          ),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(bottom: 5),
                    width: width,
                    height: height * .3,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/backgroundImage.jpg"))),
                    child: _upperSection(width)),
                Consumer<StateHelper>(
                  builder: (context, model, child) => LinearProgressIndicator(
                    backgroundColor: whiteColor,
                    value: model.progress,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        homePageProgressIndicatorColor),
                  ),
                ),
                _listViewSection(),
                _completedSection(height),
              ],
            ),
          )),
    );
  }

  Widget _upperSection(width) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                child: IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState!.isDrawerOpen
                        ? _scaffoldKey.currentState!.closeDrawer()
                        : _scaffoldKey.currentState!.openDrawer();
                  },
                  icon: const Icon(Icons.menu),
                  iconSize: 40,
                  color: whiteColor,
                ),
              ),
              StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                initialData: DateTime.now(),
                builder: (context, snap) => Text(
                  DateTime.now().toString().substring(11, 16),
                  style:
                      GoogleFonts.montserrat(fontSize: 50, color: whiteColor),
                ),
              ),
              SizedBox(
                width: width * .2,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Todo",
                style: GoogleFonts.montserrat(fontSize: 40, color: whiteColor),
              )
            ],
          )
        ],
      );
  Widget _listViewSection() {
    return Expanded(
        child: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("userData")
          .doc(userData["userId"])
          .collection("Todo")
          .snapshots(),
      builder: (context, todoData) {
        return todoData.connectionState != ConnectionState.waiting
            ? todoData.data!.docs.isEmpty
                ? Container(
                    margin: const EdgeInsets.all(20),
                    child: Text(
                      "No Task Available",
                      style: GoogleFonts.nunito(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  )
                : ListView.builder(
                    controller: _controller,
                    itemCount: todoData.data!.docs.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemExtent: 100.0,
                    itemBuilder: (context, index) {
                      var data = todoData.data?.docs[index];
                      Todo taskData = Todo.fromMap(data!.data());
                      return Dismissible(
                          key: Key(taskData.taskId),
                          background: Container(),
                          dismissThresholds: const {
                            DismissDirection.startToEnd: 100.0
                          },
                          secondaryBackground: Container(
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Delete Task",
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                              ],
                            ),
                          ),
                          onDismissed: (direction) async {
                            if (direction == DismissDirection.endToStart) {
                              _dataStore.deleteTask(
                                  userData["userId"], data.id);
                              await updateCount();
                            }
                          },
                          direction: DismissDirection.horizontal,
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => AddTaskView(
                                              userData: userData,
                                              whichTask: WhichTask.editTask,
                                              docId: data.id,
                                              todoData: taskData,
                                            ))),
                                //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditTaskView(userData,taskData,data.id))),
                                trailing: taskData.progress == "completed"
                                    ? IconButton(
                                        tooltip: "Mark as Completed",
                                        icon:
                                            const Icon(Icons.done_all_outlined,color: Colors.green,),
                                        onPressed: () async {
                                          await _dataStore.unCompleteTask(
                                              userData["userId"], data.id);
                                          await updateCount();
                                        },
                                      )
                                    : IconButton(
                                        tooltip: "Unmarked as Completed",
                                        icon: const Icon(Icons.remove_done,color: Colors.red,),
                                        onPressed: () async {
                                          await _dataStore.completeTask(
                                              userData["userId"], data.id);
                                          await updateCount();
                                        },
                                      ),
                                leading: CircleAvatar(
                                  radius: 50,
                                  child: Icon(icons[index >= icons.length
                                      ? icons.length - 5
                                      : index]),
                                ),
                                title: Text(taskData.task),
                                subtitle:
                                    Text("${taskData.desc}\n${taskData.date}"),
                                isThreeLine: true,
                                iconColor: Colors.blue,
                              ),
                              const Divider(
                                indent: 40,
                                endIndent: 40,
                                height: 1,
                                color: homePageGreyTextColor,
                              )
                            ],
                          ));
                    })
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    ));
  }

  Widget _completedSection(height) => Container(
      margin: const EdgeInsets.only(left: 20),
      height: height * .07,
      child: Row(
        children: [
          Text(
            "COMPLETED",
            style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: homePageGreyTextColor),
          ),
          const SizedBox(
            width: 10,
          ),
          CircleAvatar(
            radius: 12,
            backgroundColor: homePageGreyTextColor,
            child: Consumer<StateHelper>(
              builder: (context, model, _) => Text(
                "${model.completedCount}",
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold, color: whiteColor),
              ),
            ),
          )
        ],
      ));
}
