import 'dart:convert';

import 'package:ai_chat/core/const/app_url.dart';
import 'package:ai_chat/feature/home/controller/home_controller.dart';
import 'package:ai_chat/feature/home/model/home_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeRepository {
  HomeController homeController = Get.put(HomeController());
  Future<HomeResponseModel> sendMessage( String message) async {
   homeController.loading(true);

    try {
      var headers = {
        "X-goog-api-key": AppUrl.key,
        "Content-Type": "application/json",
      };

      var body = jsonEncode({
        "contents": [
          {
            "role": "user",
            "parts": [
              {"text": message},
            ],
          },
        ],
      });

      var response = await http.post(
        Uri.parse(AppUrl.baseurl),
        headers: headers,
        body: body,
      );

      var data = jsonDecode(response.body);

      print("statuscode${response.statusCode}");

      if (response.statusCode == 200) {
        homeController.loading(false);
        print(data);
        return HomeResponseModel.fromJson(data);

      }
      homeController.loading(false);
      return HomeResponseModel();
    } catch (e) {
      homeController.loading(false);
      print(e);
      return HomeResponseModel();
    }
  }
}
