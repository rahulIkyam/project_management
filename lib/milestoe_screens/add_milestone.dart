import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:project_management/milestone_provider/milestoneProvider.dart';
import 'package:project_management/static_data/custom_drawer.dart';
import 'package:project_management/view_model/auth_view_model.dart';
import 'package:provider/provider.dart';

import '../static_data/colors.dart';
import '../static_data/custom_appbar.dart';
import '../utils/utils.dart';
import '../widgets/outlined_buttons.dart';

class AddMilestone extends StatefulWidget {
  const AddMilestone({super.key});

  @override
  State<AddMilestone> createState() => _AddMilestoneState();
}

class _AddMilestoneState extends State<AddMilestone> {

  double screenWidth = 0.0;
  bool isLoading = false;
  final _verticalScrollController = ScrollController();
  final _horizontalScrollController = ScrollController();
  final _verticalScrollController1 = ScrollController();

  final milestoneNameController = TextEditingController();
  final taskNameController = TextEditingController();
  final taskAssignedToController = TextEditingController();
  final taskDescriptionController = TextEditingController();
  final taskDueDateController = TextEditingController();
  final taskPriorityController = TextEditingController();
  final taskTagController = TextEditingController();
  final taskHrsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MilestoneProvider>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),
      ),
      body: Row(
        children: [
          const CustomDrawer(190, 1.2),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Project Milestone", style: TextStyle(color: imageColor1)),
                centerTitle: true,
                backgroundColor: Colors.white,
                actions: [

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: MaterialButton(
                      height: 35,
                      color: imageColor,
                      onPressed: () {
                        if(provider.milestones.isNotEmpty){

                          final milestone = provider.milestones.first;

                          if(milestone['milestoneName'].toString().trim().isEmpty ||
                              (milestone["tasks"] as List).isEmpty){
                            Utils.snackBar("Milestone details are incomplete.", context);
                          } else{
                            authViewModel.createMilestone(milestone, context);
                          }
                        } else {
                          print('No milestones to save.');
                          Utils.snackBar("No milestones to save. Please add a milestone first.", context);
                        }
                      },
                      child: const Text("Save",style: TextStyle(color: Colors.white)),
                    )
                  ),
                ],
              ),
              body: isLoading ? const Center(child: CircularProgressIndicator(),) : AdaptiveScrollbar(
                underColor: Colors.blueGrey.withOpacity(0.3),
                sliderDefaultColor: Colors.grey.withOpacity(0.7),
                sliderActiveColor: Colors.grey,
                controller: _verticalScrollController,
                child: SingleChildScrollView(
                  controller: _verticalScrollController,
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Center(
                      child: SizedBox(
                        width: 500,
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: provider.milestones.length,
                              itemBuilder: (context, mileIndex) {
                                final detail = provider.milestones[mileIndex];
                                return SizedBox(
                                  width: 500,
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    // color: Colors.blueGrey,
                                    elevation: 5,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Milestone", style: TextStyle(fontWeight: FontWeight.bold, color: imageColor1),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                                          child: Container(color: imageColor1, height: 1, width: 500,),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            width: 200,
                                            child: TextFormField(
                                              style: const TextStyle(fontSize: 12),
                                              textInputAction: TextInputAction.done,
                                              onTapOutside: (_) {
                                                FocusManager.instance.primaryFocus?.unfocus();
                                              },
                                              decoration: Utils.dateDecoration(hintText: "Enter Milestone Name"),
                                              controller: milestoneNameController,
                                              onChanged: (value) {
                                                provider.updateMilestone(mileIndex, "milestoneName", value);
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                                          child: Container(color: imageColor1, height: 1, width: 500,),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Task", style: TextStyle(fontWeight: FontWeight.bold, color: imageColor1),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                                          child: Container(color: imageColor1, height: 1, width: 500,),
                                        ),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: (detail["tasks"] as List).length,
                                          itemBuilder: (context, taskIndex) {
                                            final task = detail["tasks"][taskIndex];
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width: 200,
                                                    child: TextFormField(
                                                      style: const TextStyle(fontSize: 12),
                                                      textInputAction: TextInputAction.done,
                                                      onTapOutside: (_) {
                                                        FocusManager.instance.primaryFocus?.unfocus();
                                                      },
                                                      decoration: Utils.dateDecoration(hintText: "Enter Task Name"),
                                                      controller: taskNameController,
                                                      onChanged: (value) {
                                                        task["taskName"] = value;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width: 200,
                                                    child: TextFormField(
                                                      style: const TextStyle(fontSize: 12),
                                                      textInputAction: TextInputAction.done,
                                                      onTapOutside: (_) {
                                                        FocusManager.instance.primaryFocus?.unfocus();
                                                      },
                                                      decoration: Utils.dateDecoration(hintText: "Enter Assigned to"),
                                                      controller: taskAssignedToController,
                                                      onChanged: (value) {
                                                        task["assignedTo"] = value;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width: 200,
                                                    child: TextFormField(
                                                      style: const TextStyle(fontSize: 12),
                                                      textInputAction: TextInputAction.done,
                                                      onTapOutside: (_) {
                                                        FocusManager.instance.primaryFocus?.unfocus();
                                                      },
                                                      decoration: Utils.dateDecoration(hintText: "Enter Description"),
                                                      controller: taskDescriptionController,
                                                      onChanged: (value) {
                                                        task["description"] = value;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width: 200,
                                                    child: TextFormField(
                                                      style: const TextStyle(fontSize: 12),
                                                      textInputAction: TextInputAction.done,
                                                      onTapOutside: (_) {
                                                        FocusManager.instance.primaryFocus?.unfocus();
                                                      },
                                                      decoration: Utils.dateDecoration(hintText: "Enter Due Date"),
                                                      controller: taskDueDateController,
                                                      onTap: () async{
                                                        DateTime? startDate = await showDatePicker(
                                                            context: context,
                                                            initialDate: DateTime.now(),
                                                            firstDate: DateTime(1990),
                                                            lastDate: DateTime(2100)
                                                        );
                                                        if(startDate != null){
                                                          String formattedDate = DateFormat('dd-MM-yyyy').format(startDate);
                                                          taskDueDateController.text = formattedDate;
                                                          task["dueDate"] = formattedDate;
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width: 200,
                                                    child: TextFormField(
                                                      style: const TextStyle(fontSize: 12),
                                                      textInputAction: TextInputAction.done,
                                                      onTapOutside: (_) {
                                                        FocusManager.instance.primaryFocus?.unfocus();
                                                      },
                                                      decoration: Utils.dateDecoration(hintText: "Enter Task Priority"),
                                                      controller: taskPriorityController,
                                                      onChanged: (value) {
                                                        task["priority"] = value;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width: 200,
                                                    child: TextFormField(
                                                      style: const TextStyle(fontSize: 12),
                                                      textInputAction: TextInputAction.done,
                                                      onTapOutside: (_) {
                                                        FocusManager.instance.primaryFocus?.unfocus();
                                                      },
                                                      decoration: Utils.dateDecoration(hintText: "Enter Task Tag"),
                                                      controller: taskTagController,
                                                      onChanged: (value) {
                                                        task["tag"] = value;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width: 200,
                                                    child: TextFormField(
                                                      style: const TextStyle(fontSize: 12),
                                                      textInputAction: TextInputAction.done,
                                                      onTapOutside: (_) {
                                                        FocusManager.instance.primaryFocus?.unfocus();
                                                      },
                                                      decoration: Utils.dateDecoration(hintText: "Hours Spent"),
                                                      controller: taskHrsController,
                                                      onChanged: (value) {
                                                        task["hrsSpend"] = value;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                  child: Container(color: imageColor1, height: 1, width: 500,),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const Text("Sub Tasks", style: TextStyle(fontWeight: FontWeight.bold, color: imageColor1),),
                                                      MaterialButton(
                                                          height: 35,
                                                          color: imageColor,
                                                          onPressed: () {
                                                            provider.addSubTaskToTask(mileIndex, taskIndex,
                                                                {
                                                                  "subTaskName": "",
                                                                  "subAssignedTo": "",
                                                                  "subDescription": "",
                                                                  "subDueDate": "",
                                                                  "subPriority": "",
                                                                  "subTag": "",
                                                                  "subHrsSpend": "",
                                                                }
                                                            );
                                                          },
                                                          child: const Text("Add Sub Task",style: TextStyle(color: Colors.white))
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                  child: Container(color: imageColor1, height: 1, width: 500,),
                                                ),
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: (task["subTasks"] as List).length,
                                                  itemBuilder: (context, subTaskIndex) {
                                                    TextEditingController taskNameController = TextEditingController();
                                                    TextEditingController taskAssController = TextEditingController();
                                                    TextEditingController taskDescController = TextEditingController();
                                                    TextEditingController taskPriorityController = TextEditingController();
                                                    TextEditingController taskTagController = TextEditingController();
                                                    TextEditingController taskHoursController = TextEditingController();
                                                    TextEditingController dateController = TextEditingController();
                                                    final subTask = task["subTasks"][subTaskIndex];
                                                    taskNameController.text = subTask["subTaskName"].toString();
                                                    taskAssController.text = subTask["subAssignedTo"].toString();
                                                    taskDescController.text = subTask["subDescription"].toString();
                                                    dateController.text = subTask["subDueDate"].toString();
                                                    taskPriorityController.text = subTask["subPriority"].toString();
                                                    taskTagController.text = subTask["subTag"].toString();
                                                    taskHoursController.text = subTask["subHrsSpend"].toString();
                                                    taskNameController.selection = TextSelection.fromPosition(TextPosition(offset: taskNameController.text.length));
                                                    taskAssController.selection = TextSelection.fromPosition(TextPosition(offset: taskAssController.text.length));
                                                    taskDescController.selection = TextSelection.fromPosition(TextPosition(offset: taskDescController.text.length));
                                                    taskPriorityController.selection = TextSelection.fromPosition(TextPosition(offset: taskPriorityController.text.length));
                                                    taskTagController.selection = TextSelection.fromPosition(TextPosition(offset: taskTagController.text.length));
                                                    taskHoursController.selection = TextSelection.fromPosition(TextPosition(offset: taskHoursController.text.length));
                                                    return SizedBox(
                                                      width: screenWidth*0.3,
                                                      child: Card(
                                                        margin: const EdgeInsets.symmetric(vertical: 8),
                                                        // color: Colors.grey,
                                                        child: Row(
                                                          key: ValueKey(subTaskIndex),
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: SizedBox(
                                                                    width: 200,
                                                                    child: TextFormField(
                                                                      style: const TextStyle(fontSize: 12),
                                                                      textInputAction: TextInputAction.done,
                                                                      onTapOutside: (_) {
                                                                        FocusManager.instance.primaryFocus?.unfocus();
                                                                      },
                                                                      textDirection: TextDirection.ltr,
                                                                      decoration: Utils.dateDecoration(hintText: "Sub Task"),
                                                                      controller: taskNameController,
                                                                      // initialValue: subTask["subTaskName"],
                                                                      onChanged: (value) {
                                                                        // taskNameController.text = value;
                                                                        subTask["subTaskName"] = value;
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: SizedBox(
                                                                    width: 200,
                                                                    child: TextFormField(
                                                                      style: const TextStyle(fontSize: 12),
                                                                      textInputAction: TextInputAction.done,
                                                                      onTapOutside: (_) {
                                                                        FocusManager.instance.primaryFocus?.unfocus();
                                                                      },
                                                                      textDirection: TextDirection.ltr,
                                                                      decoration: Utils.dateDecoration(hintText: "Sub Task Assigned to"),
                                                                      controller: taskAssController,
                                                                      // initialValue: subTask["subAssignedTo"],
                                                                      onChanged: (value) {
                                                                        // taskAssController.text = value;
                                                                        subTask["subAssignedTo"] = value;
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: SizedBox(
                                                                    width: 200,
                                                                    child: TextFormField(
                                                                      style: const TextStyle(fontSize: 12),
                                                                      textInputAction: TextInputAction.done,
                                                                      onTapOutside: (_) {
                                                                        FocusManager.instance.primaryFocus?.unfocus();
                                                                      },
                                                                      textDirection: TextDirection.ltr,
                                                                      decoration: Utils.dateDecoration(hintText: "Sub Task Description"),
                                                                      controller: taskDescController,
                                                                      // initialValue: subTask["subDescription"],
                                                                      onChanged: (value) {
                                                                        // taskDescController.text = value;
                                                                        subTask["subDescription"] = value;
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: SizedBox(
                                                                    width: 200,
                                                                    child: TextFormField(
                                                                      style: const TextStyle(fontSize: 12),
                                                                      textInputAction: TextInputAction.done,
                                                                      onTapOutside: (_) {
                                                                        FocusManager.instance.primaryFocus?.unfocus();
                                                                      },
                                                                      decoration: Utils.dateDecoration(hintText: "Sub Task Due Date"),
                                                                      controller: dateController,
                                                                      // initialValue: subTask["subDueDate"],
                                                                      onTap: () async{
                                                                        DateTime? startDate = await showDatePicker(
                                                                            context: context,
                                                                            initialDate: DateTime.now(),
                                                                            firstDate: DateTime(1990),
                                                                            lastDate: DateTime(2100)
                                                                        );
                                                                        if(startDate != null){
                                                                          String formattedDate = DateFormat('dd-MM-yyyy').format(startDate);
                                                                          subTask["subDueDate"] = formattedDate;
                                                                          dateController.text = formattedDate;
                                                                        }
                                                                      },
                                                                      // onChanged: (value) {
                                                                      //
                                                                      //   print(value);
                                                                      //   subTask["subDueDate"] = value;
                                                                      // },
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: SizedBox(
                                                                    width: 200,
                                                                    child: TextFormField(
                                                                      style: const TextStyle(fontSize: 12),
                                                                      textInputAction: TextInputAction.done,
                                                                      onTapOutside: (_) {
                                                                        FocusManager.instance.primaryFocus?.unfocus();
                                                                      },
                                                                      textDirection: TextDirection.ltr,
                                                                      decoration: Utils.dateDecoration(hintText: "Sub Task Priority"),
                                                                      controller: taskPriorityController,
                                                                      // initialValue: subTask["subPriority"],
                                                                      onChanged: (value) {
                                                                        // taskPriorityController.text = value;
                                                                        subTask["subPriority"] = value;
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: SizedBox(
                                                                    width: 200,
                                                                    child: TextFormField(
                                                                      style: const TextStyle(fontSize: 12),
                                                                      textInputAction: TextInputAction.done,
                                                                      onTapOutside: (_) {
                                                                        FocusManager.instance.primaryFocus?.unfocus();
                                                                      },
                                                                      textDirection: TextDirection.ltr,
                                                                      decoration: Utils.dateDecoration(hintText: "Sub Task Tag"),
                                                                      controller: taskTagController,
                                                                      // initialValue: subTask["subTag"],
                                                                      onChanged: (value) {
                                                                        // taskTagController.text = value;
                                                                        subTask["subTag"] = value;
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: SizedBox(
                                                                    width: 200,
                                                                    child: TextFormField(
                                                                      style: const TextStyle(fontSize: 12),
                                                                      textInputAction: TextInputAction.done,
                                                                      onTapOutside: (_) {
                                                                        FocusManager.instance.primaryFocus?.unfocus();
                                                                      },
                                                                      textDirection: TextDirection.ltr,
                                                                      decoration: Utils.dateDecoration(hintText: "Sub Task Hours Spent"),
                                                                      controller: taskHoursController,
                                                                      // initialValue: subTask["subHrsSpend"],
                                                                      onChanged: (value) {
                                                                        // taskHoursController.text = value;
                                                                        subTask["subHrsSpend"] = value;
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            IconButton(
                                                                onPressed: () {
                                                                  print("Deleting milestoneIndex: $mileIndex");
                                                                  print("Deleting taskIndex: $taskIndex");
                                                                  print("Deleting subTaskIndex: $subTaskIndex");
                                                                  print("Deleting subTaskIndex: $subTaskIndex");
                                                                  print("Sub Task Name: ${taskNameController.text} and index is: $subTaskIndex");
                                                                  provider.removeSubTaskFromTask(mileIndex, taskIndex, subTaskIndex);
                                                                },
                                                                icon: const Icon(Icons.delete, color: Colors.red,)
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}
