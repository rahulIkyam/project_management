import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:project_management/res/app_url.dart';
import 'package:project_management/utils/routes/routes_name.dart';
import 'package:http/http.dart' as http;
import '../static_data/colors.dart';
import '../static_data/static_list.dart';
import '../widgets/outlined_buttons.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final _horizontalScrollController = ScrollController();
  final _verticalScrollController = ScrollController();
  final searchProjectName =TextEditingController();
  final searchCustomerName =TextEditingController();
  late double screenWidth;
  late double screenHeight;
  bool isLoading = false;
  bool isFiltered = false;

  // List displayList = [];
  List filteredList = [];
  List displayList = [];
  List paginatedList = [];
  int startVal=0;
  int pageSize = 15;

  void resetList() {
    setState(() {
      startVal = 0;
      isFiltered = false;
      filteredList = displayList;
      updatePagination();
    });
  }
  void updatePagination() {
    List listToPaginate = isFiltered ? filteredList : displayList;

    if (listToPaginate.isNotEmpty) {
      setState(() {
        paginatedList = listToPaginate.sublist(startVal, (startVal + pageSize) > listToPaginate.length ? listToPaginate.length : startVal + pageSize,);
      });
    }
  }

  Future getAllProjects() async{
    isLoading = true;
    try{
      final response = await http.get(Uri.parse(AppUrl.getProject));
      if(response.statusCode == 200){
        setState(() {
          isLoading = false;
          displayList = json.decode(response.body);
          filteredList = displayList;
          startVal = 0;
          updatePagination();
        });
      }
    }catch(e){
      isLoading = false;
      print('Error in getting project list: $e');
    }


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllProjects();

  }


  fetchProjectName(String projectName) {
    if (projectName.isNotEmpty) {
      setState(() {
        filteredList = displayList
            .where((element) =>
            element['projectName'].toLowerCase().contains(projectName.toLowerCase()))
            .toList();
        isFiltered = true;
        startVal = 0;
        updatePagination();
      });
    } else {
      resetList();
    }
  }
  fetchCustomerName(String customerName){
    if (customerName.isNotEmpty) {
      setState(() {
        filteredList = displayList
            .where((element) =>
            element['clientName'].toLowerCase().contains(customerName.toLowerCase()))
            .toList();
        isFiltered = true;
        startVal = 0;
        updatePagination();
      });
    } else {
      resetList();
    }
  }

  void nextPage() {
    List listToPaginate = isFiltered ? filteredList : displayList;

    if (startVal + pageSize < listToPaginate.length) {
      setState(() {
        startVal += pageSize;
        updatePagination();
      });
    }
  }
  void previousPage() {
    if (startVal - pageSize >= 0) {
      setState(() {
        startVal -= pageSize;
        updatePagination();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: isLoading ? const Center(child: CircularProgressIndicator(),) : AdaptiveScrollbar(
          controller: _verticalScrollController,
          underColor: Colors.blueGrey.withOpacity(0.3),
          sliderDefaultColor: Colors.grey.withOpacity(0.7),
          sliderActiveColor: Colors.grey,
          width: 10,
          child: SingleChildScrollView(
            controller: _verticalScrollController,
            scrollDirection: Axis.vertical,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 60, right: 60, top: 30, bottom: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 1016,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)
                            ),
                            border: Border.all(color: const Color(0xFFE0E0E0),)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 18,),
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0, right: 18),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children:  [
                                  const Text("Project List ", style: TextStyle(color: Colors.blue, fontSize: 15, fontWeight: FontWeight.bold),),
                                  SizedBox(
                                    height: 35,
                                    width: 130,
                                    child: OutlinedMButton(
                                      text: "+  New Project",
                                      buttonColor: mSaveButton,
                                      textColor: Colors.white,
                                      borderColor: mSaveButton,
                                      onTap: () {
                                        Navigator.pushNamed(context, RoutesName.createProject);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:18.0, right: 18, bottom: 5),
                              child: SizedBox(
                                height: 40,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      width: 190,
                                      child: TextFormField(
                                        style: const TextStyle(fontSize: 11),
                                        controller: searchProjectName,
                                        decoration: searchProjectNameDecoration(hintText: "Project Name"),
                                        onChanged: (value) {
                                          if(value.isEmpty || value == ""){
                                            resetList();
                                          }else{
                                            fetchProjectName(searchProjectName.text);
                                            searchCustomerName.clear();
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 20,),
                                    SizedBox(
                                      height: 30,
                                      width: 190,
                                      child: TextFormField(
                                        style: const TextStyle(fontSize: 11),
                                        controller: searchCustomerName,
                                        decoration: searchCustomerNameDecoration(hintText: "Client Name"),
                                        onChanged: (value) {
                                          if(value.isEmpty || value == ""){
                                            resetList();
                                          }
                                          else{
                                            // startVal = 0;
                                            // filteredList = [];
                                            searchProjectName.clear();
                                            fetchCustomerName(searchCustomerName.text);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 1016,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              // bottomLeft: Radius.circular(10),
                              // bottomRight: Radius.circular(10),
                                topRight: Radius.circular(0),
                                topLeft: Radius.circular(0)
                            ),
                            border: Border.all(color: const Color(0xFFE0E0E0),)
                        ),
                        child: Scrollbar(
                            controller: _horizontalScrollController,
                            thumbVisibility: true,
                            thickness: 8,
                            radius: Radius.zero,
                            child: SingleChildScrollView(
                              controller: _horizontalScrollController,
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                                    Container(
                                      color: Colors.grey[100],
                                      height: 32,
                                      child: IgnorePointer(
                                        ignoring: true,
                                        child: MaterialButton(
                                          onPressed: () {},
                                          hoverColor: Colors.transparent,
                                          hoverElevation: 0,
                                          child:  const Padding(
                                            padding: EdgeInsets.only(left: 18.0, top: 5),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(top: 4.0, right: 4),
                                                  child: SizedBox(
                                                    height: 25,
                                                    width: 200,
                                                    child: Text("Project Code",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(top: 4.0, right: 4),
                                                  child: SizedBox(
                                                    height: 25,
                                                    width: 200,
                                                    child: Text("Project Name",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(top: 4.0, right: 4),
                                                  child: SizedBox(
                                                    height: 25,
                                                    width: 200,
                                                    child: Text("Client Name",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(top: 4.0, right: 4),
                                                  child: SizedBox(
                                                    height: 25,
                                                    width: 200,
                                                    child: Text("Client Id",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(top: 4.0, right: 4),
                                                  child: SizedBox(
                                                    height: 25,
                                                    width: 200,
                                                    child: Text("Start Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(top: 4.0, right: 4),
                                                  child: SizedBox(
                                                    height: 25,
                                                    width: 200,
                                                    child: Text("End Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                  ),
                                                ),
                                                Center(child: Padding(
                                                  padding: EdgeInsets.only(right: 8),
                                                  child: Icon(size: 18,
                                                    Icons.more_vert,
                                                    color: Colors.transparent,
                                                  ),
                                                ),)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                                    for(int i=0; i<paginatedList.length; i++)
                                      Column(
                                        children: [
                                          MaterialButton(
                                            hoverColor: Colors.blue[50],
                                            onPressed: () {

                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 18.0,top: 4,bottom: 3),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 4.0, right: 4),
                                                    child: SizedBox(
                                                      // height: 25,
                                                      width: 200,
                                                      child: Text(paginatedList[i]['projectCode']??"",style: const TextStyle(fontSize: 11)),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 4.0, right: 4),
                                                    child: SizedBox(
                                                      // height: 25,
                                                      width: 200,
                                                      child: Text(paginatedList[i]['projectName']??"",style: const TextStyle(fontSize: 11)),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 4.0, right: 4),
                                                    child: SizedBox(
                                                      // height: 25,
                                                      width: 200,
                                                      child: Text(paginatedList[i]['clientName']??"",style: const TextStyle(fontSize: 11)),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 4.0, right: 4),
                                                    child: SizedBox(
                                                      // height: 25,
                                                      width: 200,
                                                      child: Text(paginatedList[i]['clientId']??"",style: const TextStyle(fontSize: 11)),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 4.0, right: 4),
                                                    child: SizedBox(
                                                      // height: 25,
                                                      width: 200,
                                                      child: Text(paginatedList[i]['startingDate']??"",style: const TextStyle(fontSize: 11)),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 4.0, right: 4),
                                                    child: SizedBox(
                                                      // height: 25,
                                                      width: 200,
                                                      child: Text(paginatedList[i]['endingDate']??"",style: const TextStyle(fontSize: 11)),
                                                    ),
                                                  ),

                                                  const Center(child: Padding(
                                                    padding: EdgeInsets.only(right: 8),
                                                    child: Icon(size: 18,
                                                      Icons.arrow_circle_right,
                                                      color: Colors.blue,
                                                    ),
                                                  ),)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            )
                        ),
                      ),
                      if (filteredList.isNotEmpty)
                        Container(
                          width: 1016,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(color: Color(0xFFE0E0E0)),
                                right: BorderSide(color: Color(0xFFE0E0E0)),
                                left: BorderSide(color: Color(0xFFE0E0E0))
                            ),

                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Text("${startVal + 15 > filteredList.length ? filteredList.length : startVal + 1}-${startVal + 15 > filteredList.length ? filteredList.length : startVal +15} of ${filteredList.length}",style: const TextStyle(color: Colors.grey)),
                                Text(
                                  "${startVal + 1} - ${(startVal + pageSize) > filteredList.length ? filteredList.length : startVal + pageSize} of ${filteredList.length}",
                                  style: const TextStyle(color: Colors.black),
                                ),
                                const SizedBox(width: 10,),
                                if (startVal > 0)
                                  Material(color: Colors.transparent,
                                    child: InkWell(
                                      hoverColor: mHoverColor,
                                      onTap: previousPage,
                                      child: const Padding(
                                        padding: EdgeInsets.all(18.0),
                                        child: Icon(Icons.arrow_back_ios_sharp,size: 12),
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 10,),
                                if (startVal + pageSize < (isFiltered ? filteredList.length : displayList.length))
                                  Material(color: Colors.transparent,
                                    child: InkWell(
                                      hoverColor: mHoverColor,
                                      onTap: nextPage,
                                      child: const Padding(
                                        padding: EdgeInsets.all(18.0),
                                        child: Icon(Icons.arrow_forward_ios,size: 12),
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 20,),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          )
      ),
    );
  }

  searchProjectNameDecoration ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: searchProjectName.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(
          onTap: (){
            setState(() {
              searchProjectName.clear();
              filteredList = [];
              startVal = 0;
              // if(displayList.length > 5){
              //   filteredList.addAll(displayList.sublist(startVal, startVal+15));
              // }else{
              //   filteredList.addAll(displayList);
              // }
              // getProjectList();
            });
          },
          child: const Icon(Icons.close,size: 14,)),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  const BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 11),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
    );
  }
  searchCustomerNameDecoration ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: searchCustomerName.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(
          onTap: (){
            setState(() {
              searchCustomerName.clear();
              filteredList = [];
              startVal = 0;
              // if(displayList.length > 5){
              //   filteredList.addAll(displayList.sublist(startVal, startVal +15));
              // }else{
              //   filteredList.addAll(displayList);
              // }
              // getProjectList();
            });
          },
          child: const Icon(Icons.close,size: 14,)),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  const BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 11),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
    );
  }
}
