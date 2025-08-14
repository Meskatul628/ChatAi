import 'package:ai_chat/feature/home/model/home_response_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../repository/home_repository.dart';
class HomeController extends GetxController{

  TextEditingController controller = TextEditingController() ;

  RxList<HomeResponseModel>  chating = <HomeResponseModel>[].obs ;
  ScrollController scrollController = ScrollController();

  var isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
   if(controller.value.text.isEmpty){
     return null ;
   }
   else{
     featchAllMessage() ;
    }
  }

    void featchAllMessage ()async{

      var  userResponse = HomeResponseModel(message: controller.value.text, responseId: "1");
      chating.add(userResponse);


      var allmessage = await HomeRepository().sendMessage(controller.value.text);
      chating.add(allmessage);
    }


    void loading (bool value){

    isLoading.value = value ;
    update();

  }












}