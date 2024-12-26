import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_management/static_data/custom_appbar.dart';
import 'package:project_management/static_data/static_list.dart';
import 'package:intl/intl.dart';
import 'package:project_management/view_model/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../static_data/colors.dart';
import '../static_data/custom_drawer.dart';
import '../utils/utils.dart';


class AddProject extends StatefulWidget {
  const AddProject({super.key});

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  late double screenWidth;
  late double screenHeight;
  // final _horizontalScrollController = ScrollController();
  final _verticalScrollController = ScrollController();
  bool isHovered = false;
  bool isLoading = false;
  bool isNewClient = false;
  bool? isTmCheck1 = false;
  bool? isTmCheck2 = false;
  bool? isFfCheck1 = false;
  bool? isFfCheck2 = false;
  bool? isNbCheck1 = false;
  bool? isNbCheck2 = false;
  List displayUserList = [];
  Set<String> selectedUsers = {};
  String dropdownValue = "";
  String dropdownValueTM1 = "";
  String dropdownValueTM2 = "";
  String dropdownValueFF1 = "";
  String dropdownValueNB1 = "";

  FocusNode startDateNode = FocusNode();
  FocusNode endDateNode = FocusNode();

  late TabController _tabController;

  final TextEditingController newClientController = TextEditingController();
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController projectCodeController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final TextEditingController tmHourController = TextEditingController();
  final TextEditingController tmPerController = TextEditingController();
  final TextEditingController ffHourController = TextEditingController();
  final TextEditingController ffProFeeController = TextEditingController();
  final TextEditingController ffPerController = TextEditingController();
  final TextEditingController nbHourController = TextEditingController();
  final TextEditingController nbPerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    getInitialData();
    fetchUsers();
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  String userUid = "";
  getInitialData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userUid = prefs.getString("userUid")!;
    });
  }
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  Future<void> fetchUsers() async{
    isLoading = true;
    try{
      QuerySnapshot snapshot = await fireStore.collection("users").get();
      List users = snapshot.docs.map((doc){
        return{
          "id": doc.id,
          "userName" : doc["userName"],
          "email" : doc["email"],
          "phone" : doc["phone"],
        };
      }).toList();
      setState(() {
        isLoading = false;
        displayUserList = users;
      });
    }catch(e){
      throw("Error fetching users: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    super.build(context);
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),
      ),
      body: Row(
        children: [
          const CustomDrawer(190, 1),
          const VerticalDivider(width: 1,thickness: 1),
          Expanded(child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black),
              actions: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: MaterialButton(
                        height: 40,
                        color: imageColor,
                        onPressed: () async{
                          Map newProject = {
                            "clientName": dropdownValue.isNotEmpty ? dropdownValue : "",
                            "projectName": projectNameController.text.trim(),
                            "projectCode": projectCodeController.text.trim(),
                            "startingDate": startDateController.text,
                            "endingDate": endDateController.text,
                            "notes": notesController.text.trim(),
                            "billableRates": dropdownValueTM1.isNotEmpty ? dropdownValueTM1 : "",
                            "tmBudget": dropdownValueTM2.isNotEmpty ? dropdownValueTM2 : "",
                            "tmBudgetHours": int.tryParse(tmHourController.text) ?? 0,
                            "tmBudgetResets": isTmCheck1 ?? false,
                            "tmEmailAlerts": isTmCheck2 ?? false,
                            "tmPercentage": int.tryParse(tmPerController.text) ?? 0,
                            "projectFees": int.tryParse(ffProFeeController.text) ?? 0,
                            "ffBudget": dropdownValueFF1.isNotEmpty ? dropdownValueFF1 : "",
                            "ffBudgetHours": int.tryParse(ffHourController.text) ?? 0,
                            "ffBudgetResets": isFfCheck1 ?? false,
                            "ffEmailAlerts": isFfCheck2 ?? false,
                            "ffPercentage": int.tryParse(ffPerController.text) ?? 0,
                            "nbBudget": dropdownValueNB1.isNotEmpty ? dropdownValueNB1 : "",
                            "nbBudgetHours": int.tryParse(nbHourController.text) ?? 0,
                            "nbBudgetResets": isNbCheck1 ?? false,
                            "nbEmailAlerts": isNbCheck2 ?? false,
                            "nbPercentage": int.tryParse(nbPerController.text) ?? 0,
                            // "selectedUser" : selectedUsers
                          };
                          if(dropdownValue.isNotEmpty){
                            authViewModel.createProject(newProject, context).then((value){
                              authViewModel.setLoading(isLoading);
                            });
                          }
                        },
                        child: const Text("Save",style: TextStyle(color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ],
            ),
            body: isLoading ? const Center(child: CircularProgressIndicator(),) :AdaptiveScrollbar(
              underColor: Colors.blueGrey.withOpacity(0.3),
              sliderDefaultColor: Colors.grey.withOpacity(0.7),
              sliderActiveColor: Colors.grey,
              controller: _verticalScrollController,
              child: SingleChildScrollView(
                controller: _verticalScrollController,
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      // height: 300,
                      width: screenWidth,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 10, right: 20, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: screenWidth,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text("New Project",style: TextStyle(fontWeight: FontWeight.bold, color: imageColor),),
                                              const SizedBox(height: 10,),
                                              Container(
                                                height: 1,
                                                width: screenWidth,
                                                decoration: const BoxDecoration(
                                                  color: imageColor1,
                                                ),
                                              ),
                                              const SizedBox(height: 15,),
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                      width: 200,
                                                      child: Text("Client", style: TextStyle(fontWeight: FontWeight.bold, color: imageColor1),)
                                                  ),
                                                  Container(
                                                    height: 30,
                                                    width: 200,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: mTextFieldBorder,
                                                        width: 1,
                                                      ),
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: DropdownButton<String>(
                                                      padding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
                                                      isExpanded: true,
                                                      underline: Container(),
                                                      style: const TextStyle(fontSize: 11),
                                                      value: dropdownValue.isEmpty ? null : dropdownValue,
                                                      hint: const Text("Select Client", style: TextStyle(color: imageColor1),),
                                                      items: clientList.map((String items) {
                                                        return DropdownMenuItem(
                                                          value: items,
                                                          child: Text(items),
                                                        );
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          dropdownValue = value!;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(width: 30,),
                                                  if(isNewClient)
                                                    SizedBox(
                                                      width: 200,
                                                      child: TextFormField(
                                                        style: const TextStyle(fontSize: 11),
                                                        controller: newClientController,
                                                        decoration: Utils.customerFieldDecoration(hintText: 'Enter Client Name',controller: newClientController),
                                                        onChanged: (value){

                                                        },
                                                      ),
                                                    ),
                                                  const SizedBox(width: 20,),
                                                  MouseRegion(
                                                    onEnter: (_) {
                                                      setState(() {
                                                        isHovered = true;
                                                      });
                                                    },
                                                    onExit: (_) {
                                                      setState(() {
                                                        isHovered = false;
                                                      });
                                                    },
                                                    child: MaterialButton(
                                                      color: isHovered ? Colors.white : imageColor,
                                                      onPressed: () {
                                                        setState(() {
                                                          if (isNewClient) {
                                                            if (newClientController.text.isNotEmpty &&
                                                                !clientList.contains(newClientController.text)) {
                                                              clientList.add(newClientController.text);
                                                              dropdownValue = newClientController.text;
                                                            }
                                                            newClientController.clear();
                                                            isNewClient = false;
                                                          } else {
                                                            isNewClient = true;
                                                          }
                                                        });
                                                      },
                                                      child: Text(
                                                        isNewClient ? "Add Client" : "+ New Client",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: isHovered ? imageColor : Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10,),
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                      width: 200,
                                                      child: Text("Project Name",style: TextStyle(fontWeight: FontWeight.bold, color: imageColor1),)
                                                  ),
                                                  SizedBox(
                                                    width: 200,
                                                    child: TextFormField(
                                                      style: const TextStyle(fontSize: 11),
                                                      controller: projectNameController,
                                                      decoration: Utils.customerFieldDecoration(hintText: 'Enter Project Name',controller: projectNameController),
                                                      onChanged: (value){

                                                      },
                                                    ),
                                                  ),
                                                  Flexible(
                                                      flex: 10,
                                                      child: Container()
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10,),
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                      width: 200,
                                                      child: Text("Project Code",style: TextStyle(fontWeight: FontWeight.bold, color: imageColor1),)
                                                  ),
                                                  SizedBox(
                                                    width: 200,
                                                    child: TextFormField(
                                                      style: const TextStyle(fontSize: 11),
                                                      controller: projectCodeController,
                                                      decoration: Utils.customerFieldDecoration(hintText: 'Enter Project Code',controller: projectCodeController),
                                                      onChanged: (value){

                                                      },
                                                    ),
                                                  ),
                                                  Flexible(
                                                      flex: 10,
                                                      child: Container()
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10,),
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                      width: 200,
                                                      child: Text("Dates",style: TextStyle(fontWeight: FontWeight.bold, color: imageColor1),)
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                    width: 200,
                                                    child: TextFormField(
                                                      controller: startDateController,
                                                      showCursor: false,
                                                      focusNode: startDateNode,
                                                      decoration: Utils.dateDecoration(hintText: "Starts On"),
                                                      onTap: () async{
                                                        DateTime? startDate = await showDatePicker(
                                                            context: context,
                                                            initialDate: DateTime.now(),
                                                            firstDate: DateTime(1990),
                                                            lastDate: DateTime(2100)
                                                        );
                                                        if(startDate != null){
                                                          String formattedDate = DateFormat('dd-MM-yyyy').format(startDate);
                                                          startDateController.text = formattedDate;

                                                          if(endDateController.text.isNotEmpty){
                                                            DateTime? selectedEndDate = DateFormat("dd-MM-yyyy").parse(endDateController.text);
                                                            if(selectedEndDate.isBefore(startDate)){
                                                              endDateController.clear();
                                                            }
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10,),
                                                  const Text("to"),
                                                  const SizedBox(width: 10,),
                                                  SizedBox(
                                                    height: 30,
                                                    width: 200,
                                                    child: TextFormField(
                                                      controller: endDateController,
                                                      showCursor: false,
                                                      focusNode: endDateNode,
                                                      decoration: Utils.dateDecoration(hintText: "Ends On"),
                                                      onTap: () async{
                                                        DateTime? initialStartDate = startDateController.text.isNotEmpty ?
                                                        DateFormat("dd-MM-yyyy").parse(startDateController.text) :
                                                        DateTime.now();
                                                        DateTime? endDate = await showDatePicker(
                                                            context: context,
                                                            initialDate: initialStartDate,
                                                            firstDate: initialStartDate,
                                                            lastDate: DateTime(2100)
                                                        );
                                                        if(endDate != null){
                                                          String formattedDate = DateFormat('dd-MM-yyyy').format(endDate);
                                                          endDateController.text = formattedDate;
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10,),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                      width: 200,
                                                      child: Text("Notes", style: TextStyle(fontWeight: FontWeight.bold, color: imageColor1),)
                                                  ),
                                                  SizedBox(
                                                    height: 100,
                                                    width: 500,
                                                    child: TextFormField(
                                                      maxLines: 5,
                                                      controller: notesController,
                                                      style: const TextStyle(fontSize: 11),
                                                      decoration:Utils.textFieldDecoration(hintText: '' ) ,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 15,),
                                              const Text("Project Type",style: TextStyle(fontWeight: FontWeight.bold, color: imageColor),),
                                              const SizedBox(height: 10,),
                                              Container(
                                                height: 1,
                                                width: screenWidth,
                                                decoration: const BoxDecoration(
                                                  color: imageColor1,
                                                ),
                                              ),
                                              const SizedBox(height: 15,),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10, right: 20, bottom: 10),
                      child: SizedBox(
                          height: 350,
                          child: Scaffold(
                            appBar: PreferredSize(
                              preferredSize: const Size.fromHeight(50.0),
                              child: AppBar(
                                backgroundColor: Colors.white,
                                automaticallyImplyLeading: false,
                                bottom: TabBar(
                                    controller: _tabController,
                                    tabs:  const [
                                      Tab(
                                        child: Column(
                                          children: [
                                            Flexible(
                                              flex: 2,
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text("Time & Material", style: TextStyle(color: imageColor1, fontWeight: FontWeight.bold)),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 3,
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 7),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text("Bill by the hour, with billable rates", style: TextStyle(fontSize: 10, color: imageColor1),textAlign: TextAlign.center),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Tab(
                                        child: Column(
                                          children: [
                                            Flexible(
                                              flex: 2,
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text("Fixed Fee", style: TextStyle(color: imageColor1, fontWeight: FontWeight.bold)),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 3,
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 7),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text("Bill a set price, regardless of time tracked", style: TextStyle(fontSize: 10, color: imageColor1),textAlign: TextAlign.center),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Tab(
                                        child: Column(
                                          children: [
                                            Flexible(
                                              flex: 2,
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text("Non-Billable", style: TextStyle(color: imageColor1, fontWeight: FontWeight.bold)),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 3,
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 7),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text("Not billed to a client", style: TextStyle(fontSize: 10, color: imageColor1),textAlign: TextAlign.center),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                            ),
                            body: TabBarView(
                                controller: _tabController,
                                children: [
                                  SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                                      child: buildTM(),
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                                      child: buildFF(),
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                                      child: buildNB(),
                                    ),
                                  ),
                                ]
                            ),
                          )
                      ),
                    ),
                    SizedBox(
                      // height: 300,
                      width: screenWidth,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 10, right: 20, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: screenWidth,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text("Teams",style: TextStyle(fontWeight: FontWeight.bold,color: imageColor1),),
                                              const SizedBox(height: 10,),
                                              Container(
                                                height: 1,
                                                width: screenWidth,
                                                decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 300,
                                                child: ListView.builder(
                                                  itemCount: displayUserList.length,
                                                  itemBuilder: (context, index) {
                                                    final user = displayUserList[index];
                                                    final isSelected = selectedUsers.contains(user["id"]);
                                                    return Row(
                                                     children: [
                                                       Checkbox(
                                                         value: isSelected,
                                                         onChanged: (value) {
                                                                 setState(() {
                                                                   if(isSelected){
                                                                     selectedUsers.remove(user["id"]);
                                                                   }else{
                                                                     selectedUsers.add(user["id"]);
                                                                   }
                                                                 });
                                                                 print('--- Selection Changed ---');
                                                                 print(selectedUsers);
                                                                 print(user);
                                                       },),
                                                       Text(user["userName"]),
                                                     ],
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),)

        ],
      )
    );
  }

Widget buildTM(){
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(
            color: mTextFieldBorder.withOpacity(0.8),
            width: 1
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Billable Rates", style: TextStyle(fontWeight: FontWeight.bold, color: imageColor1),),
            const SizedBox(height: 5,),
            const Text("We need billable rates to track your projects billable amount", style: TextStyle(color: imageColor1)),
            const SizedBox(height: 10,),
            SizedBox(
              width: 200,
              height: 30,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: mTextFieldBorder,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButton<String>(
                  padding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
                  isExpanded: true,
                  underline: Container(),
                  style: const TextStyle(fontSize: 11),
                  value: dropdownValueTM1.isEmpty ? null : dropdownValueTM1,
                  items: billableListTM.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      dropdownValueTM1 = value!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20,),
            const Text("Budget", style: TextStyle(fontWeight: FontWeight.bold, color: imageColor1),),
            const SizedBox(height: 5,),
            const Text("Set a budget to track project progress", style: TextStyle(color: imageColor1)),
            const SizedBox(height: 10,),
            Row(
              children: [
                SizedBox(
                  width: 200,
                  height: 30,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: mTextFieldBorder,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      padding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
                      isExpanded: true,
                      underline: Container(),
                      style: const TextStyle(fontSize: 11),
                      value: dropdownValueTM2.isEmpty ? null : dropdownValueTM2,
                      items: budgetListTM.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          dropdownValueTM2 = value!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 15,),
                SizedBox(
                  width: 100,
                  height: 30,
                  child: TextFormField(
                    style: const TextStyle(fontSize: 11),
                    // autofocus: true,
                    // readOnly: true,
                    controller: tmHourController,
                    decoration: Utils.customerFieldDecoration(hintText: 'Hours',controller: tmHourController),
                    onChanged: (value){

                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5,),
            Row(
              children: [
                Checkbox(
                    tristate: false,
                    value: isTmCheck1,
                    onChanged: (bool? newValue) {
                      setState(() {
                        isTmCheck1 = newValue;
                      });
                    },
                ),
                const Text("Budget resets every month", style: TextStyle(color: imageColor1))
              ],
            ),
            const SizedBox(height: 5,),
            Row(
              children: [
                Checkbox(
                    tristate: false,
                    value: isTmCheck2,
                    onChanged: (bool? newValue) {
                      setState(() {
                        isTmCheck2 = newValue;
                      });
                    },
                ),
                const Text("Send email alerts if project exceeds", style: TextStyle(color: imageColor1)),
                const SizedBox(width: 5,),
                SizedBox(
                  width: 100,
                  height: 30,
                  child: TextFormField(
                    style: const TextStyle(fontSize: 11),
                    // autofocus: true,
                    // readOnly: true,
                    controller: tmPerController,
                    decoration: Utils.customerFieldDecoration(hintText: '',controller: tmPerController),
                    onChanged: (value){

                    },
                  ),
                ),
                const SizedBox(width: 5,),
                const Text("% of budget", style: TextStyle(color: imageColor1)),
              ],
            ),

          ],
        ),
      ),

    );
}

  Widget buildFF(){
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(
            color: mTextFieldBorder.withOpacity(0.8),
            width: 1
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Project fees", style: TextStyle(fontWeight: FontWeight.bold,color: imageColor1),),
            const SizedBox(height: 5,),
            const Text("Enter the amount you plan to invoice", style: TextStyle(color: imageColor1)),
            const SizedBox(height: 10,),
            Row(
              children: [
                const Text('\$'),
                SizedBox(
                  width: 100,
                  height: 30,
                  child: TextFormField(
                    style: const TextStyle(fontSize: 11),
                    // autofocus: true,
                    // readOnly: true,
                    controller: ffProFeeController,
                    decoration: Utils.customerFieldDecoration(hintText: '',controller: ffProFeeController),
                    onChanged: (value){

                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            const Text("Budget", style: TextStyle(fontWeight: FontWeight.bold, color: imageColor1),),
            const SizedBox(height: 5,),
            const Text("Set a budget to track project progress", style: TextStyle(color: imageColor1)),
            const SizedBox(height: 10,),
            Row(
              children: [
                SizedBox(
                  width: 200,
                  height: 30,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: mTextFieldBorder,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      padding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
                      isExpanded: true,
                      underline: Container(),
                      style: const TextStyle(fontSize: 11),
                      value: dropdownValueFF1.isEmpty ? null : dropdownValueFF1,
                      items: budgetListFF.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          dropdownValueFF1 = value!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 15,),
                SizedBox(
                  width: 100,
                  height: 30,
                  child: TextFormField(
                    style: const TextStyle(fontSize: 11),
                    // autofocus: true,
                    // readOnly: true,
                    controller: ffHourController,
                    decoration: Utils.customerFieldDecoration(hintText: 'Hours',controller: ffHourController),
                    onChanged: (value){

                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5,),
            Row(
              children: [
                Checkbox(
                  tristate: false,
                  value: isFfCheck1,
                  onChanged: (bool? newValue) {
                    setState(() {
                      isFfCheck1 = newValue;
                    });
                  },
                ),
                const Text("Budget resets every month", style: TextStyle(color: imageColor1))
              ],
            ),
            const SizedBox(height: 5,),
            Row(
              children: [
                Checkbox(
                  tristate: false,
                  value: isFfCheck2,
                  onChanged: (bool? newValue) {
                    setState(() {
                      isFfCheck2 = newValue;
                    });
                  },
                ),
                const Text("Send email alerts if project exceeds", style: TextStyle(color: imageColor1)),
                const SizedBox(width: 5,),
                SizedBox(
                  width: 100,
                  height: 30,
                  child: TextFormField(
                    style: const TextStyle(fontSize: 11),
                    // autofocus: true,
                    // readOnly: true,
                    controller: ffPerController,
                    decoration: Utils.customerFieldDecoration(hintText: '',controller: ffPerController),
                    onChanged: (value){

                    },
                  ),
                ),
                const SizedBox(width: 5,),
                const Text("% of budget", style: TextStyle(color: imageColor1)),
              ],
            ),

          ],
        ),
      ),

    );
  }

  Widget buildNB(){
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(
            color: mTextFieldBorder.withOpacity(0.8),
            width: 1
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20,),
            const Text("Budget", style: TextStyle(fontWeight: FontWeight.bold, color: imageColor1),),
            const SizedBox(height: 5,),
            const Text("Set a budget to track project progress", style: TextStyle(color: imageColor1)),
            const SizedBox(height: 10,),
            Row(
              children: [
                SizedBox(
                  width: 200,
                  height: 30,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: mTextFieldBorder,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      padding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
                      isExpanded: true,
                      underline: Container(),
                      style: const TextStyle(fontSize: 11),
                      value: dropdownValueNB1.isEmpty ? null : dropdownValueNB1,
                      items: budgetListNB.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          dropdownValueNB1 = value!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 15,),
                SizedBox(
                  width: 100,
                  height: 30,
                  child: TextFormField(
                    style: const TextStyle(fontSize: 11),
                    // autofocus: true,
                    // readOnly: true,
                    controller: nbHourController,
                    decoration: Utils.customerFieldDecoration(hintText: 'Hours',controller: nbHourController),
                    onChanged: (value){

                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5,),
            Row(
              children: [
                Checkbox(
                  tristate: false,
                  value: isNbCheck1,
                  onChanged: (bool? newValue) {
                    setState(() {
                      isNbCheck1 = newValue;
                    });
                  },
                ),
                const Text("Budget resets every month", style: TextStyle(color: imageColor1))
              ],
            ),
            const SizedBox(height: 5,),
            Row(
              children: [
                Checkbox(
                  tristate: false,
                  value: isNbCheck2,
                  onChanged: (bool? newValue) {
                    setState(() {
                      isNbCheck2 = newValue;
                    });
                  },
                ),
                const Text("Send email alerts if project exceeds", style: TextStyle(color: imageColor1)),
                const SizedBox(width: 5,),
                SizedBox(
                  width: 100,
                  height: 30,
                  child: TextFormField(
                    style: const TextStyle(fontSize: 11),
                    // autofocus: true,
                    // readOnly: true,
                    controller: nbPerController,
                    decoration: Utils.customerFieldDecoration(hintText: '',controller: nbPerController),
                    onChanged: (value){

                    },
                  ),
                ),
                const SizedBox(width: 5,),
                const Text("% of budget", style: TextStyle(color: imageColor1)),
              ],
            ),

          ],
        ),
      ),

    );
  }

}
