
import 'package:flutter/foundation.dart';


class MilestoneProvider with ChangeNotifier{
  List<Map<String, dynamic>> milestones = [
    {
      "milestoneName": "",
      "tasks": <Map<String, dynamic>>[
        {
          "taskName": "",
          "assignedTo": "",
          "description": "",
          "dueDate": "",
          "priority": "",
          "tag": "",
          "hrsSpend": "",
          "subTasks": <Map<String, String>>[
            {
              "subTaskName": "",
              "subAssignedTo": "",
              "subDescription": "",
              "subDueDate": "",
              "subPriority": "",
              "subTag": "",
              "subHrsSpend": "",
            },
          ],
        },
      ],
    },
  ];

  void addTaskToMilestone(int index) {
    if (index >= 0 && index < milestones.length) {
      milestones[index]["tasks"].add({
        "taskName": "",
        "assignedTo": "",
        "description": "",
        "dueDate": "",
        "priority": "",
        "tag": "",
        "hrsSpend": "",
        "subTasks": <Map<String, String>>[],
      });
      print('Task added to milestone $index: ${milestones[index]}');
      notifyListeners();
    }
  }

  void updateMilestone(int index, String key, String value){
    if(index >= 0 && index < milestones.length){
      milestones[index][key] = value;
      notifyListeners();
    }
  }

  void addSubTaskToTask(int mileIndex, int taskIndex, Map<String, String> subTask){
    if(mileIndex >= 0 &&
        mileIndex < milestones.length &&
        taskIndex >= 0 &&
        taskIndex < (milestones[mileIndex]["tasks"] as List).length){
      (milestones[mileIndex]["tasks"][taskIndex]["subTasks"] as List<Map<String, String>>).add(subTask);
      notifyListeners();
    }
    print('--- add sub task ----');
    print(milestones);
  }

  void removeSubTaskFromTask(int mileIndex, int taskIndex, int subTaskIndex) {
    if (mileIndex >= 0 &&
        mileIndex < milestones.length &&
        taskIndex >= 0 &&
        taskIndex < (milestones[mileIndex]["tasks"] as List).length &&
        subTaskIndex >= 0 &&
        subTaskIndex < (milestones[mileIndex]["tasks"][taskIndex]["subTasks"] as List).length) {
      (milestones[mileIndex]["tasks"][taskIndex]["subTasks"] as List).removeAt(subTaskIndex);
      notifyListeners();
      print('----- sub task index ------');
      print(subTaskIndex);
    }
  }


}