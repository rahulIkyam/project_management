



import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:project_management/utils/utils.dart';

import '../repository/auth_repository.dart';
import '../utils/routes/routes_name.dart';

class AuthViewModel with ChangeNotifier{

  final _myRepo = AuthRepository();
  bool _loading = false;
  List<dynamic> _projects = [];
  List<dynamic> _users = [];

  List<dynamic> get projects => _projects;
  List<dynamic> get users => _users;
  bool get loading => _loading;

  setLoading(bool value){
    _loading = value;
    notifyListeners();
  }

  Future<void> loginApi(dynamic data, BuildContext context) async{
    setLoading(true);
    _myRepo.loginApi(data).then((value) {
      setLoading(false);
      Navigator.pushNamed(context, RoutesName.home);
      if (kDebugMode) {
        print('-------');
        print(value.toString());
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print('********');
        print(error.toString());
      }
    });
  }

  Future<void> signUpApi(dynamic data, BuildContext context) async{
    setLoading(true);
    _myRepo.signUpApi(data).then((value){
      setLoading(false);
      Navigator.pushNamed(context, RoutesName.home);
      if (kDebugMode) {
        print('-------');
        print(value.toString());
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print('********');
        print(error.toString());
      }
    });
  }

  Future<void> createProject(dynamic data, BuildContext context) async{
    setLoading(true);
    _myRepo.createProjectApi(data).then((value) {
      setLoading(false);
      Navigator.pushNamed(context, RoutesName.home);
      if (kDebugMode) {
        print('-------');
        print(value.toString());
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print('********');
        print(error.toString());
      }
    });
  }

  Future<void> getAllProjects() async{
    setLoading(true);
    try{
      final response = await _myRepo.getProjects();
      _projects = response;
      print("Projects fetched: $_projects");
    }catch(e){
      print("Error fetching projects: $e");
    }finally{
      setLoading(false);
    }
  }

  Future<void> createMilestone(dynamic data, BuildContext context) async{
    setLoading(true);
    _myRepo.createMilestoneApi(data).then((value) {
      setLoading(false);
      if (kDebugMode) {
        print('-------');
        print(value.toString());
        if(value.toString().contains("error")){
          Utils.snackBar("Internal Server Error", context);
        }
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print('********');
        print(error.toString());
      }
    });
  }


}