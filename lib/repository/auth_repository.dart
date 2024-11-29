

import '../data/network/baseApiService.dart';
import '../data/network/networkApiService.dart';
import '../res/app_url.dart';

class AuthRepository{

  final BaseApiService _apiService = NetworkApiResponse();

  Future<dynamic> loginApi(dynamic data) async{
    try{
      dynamic response = await _apiService.getPostApiResponse(AppUrl.createProject, data);
      return response;
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> signUpApi(dynamic data) async{
    try{
      dynamic response = await _apiService.getPostApiResponse(AppUrl.createProject, data);
      return response;
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> createProjectApi(dynamic data) async{
    try{
      dynamic response = await _apiService.getPostApiResponse(AppUrl.createProject, data);
      return response;
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> getProjects() async{
    try{
      dynamic response = await _apiService.getGetApiResponse(AppUrl.getProject);
      return response;
    }catch(e){
      print('---- get api -----');
      print("Error in getting Projects: $e");
      throw e;
    }
  }

  Future<dynamic> createMilestoneApi(dynamic data) async{
    try{
      dynamic response = await _apiService.getPostApiResponse(AppUrl.postMilestone, data);
      return response;
    }catch(e){
      print('Error in post Milestone: $e');
      throw e;
    }
  }
}