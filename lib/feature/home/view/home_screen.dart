import 'dart:ui';

import 'package:ai_chat/core/const/app_images.dart';
import 'package:ai_chat/feature/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:lottie/lottie.dart';

import '../../../core/const/app_loti.dart';
import '../repository/home_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // HomeRepository.getChat("you know me");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat Ai",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.chatAiImage),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Padding(
            padding: const EdgeInsets.all(10).r,
            child: Column(
              children: [
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: homeController.chating.length,
                      itemBuilder: (context, index) {
                        var data = homeController
                            .chating
                            .value[homeController.chating.length - 1 - index];

                        return data.responseId == "1"
                            ? Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    data.message?.toString() ?? "",
                                    style: TextStyle(fontSize: 16.sp,color: Colors.black),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(vertical: 10).r,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      //color: Colors.blue,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: GptMarkdown(
                                      data
                                              .candidates?[0]
                                              .content
                                              ?.parts?[0]
                                              .text ??
                                          "",

                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                      },
                    ),
                  ),
                ),
                Obx(
                  () => homeController.isLoading.value
                      ? Align(
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                            height: 80.h,
                            child: Lottie.asset(
                              AppLoti.loadingLotti,
                              width: 80.w,
                            ),
                          ),
                        )
                      : Container(),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 300.w,
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: homeController.controller,
                        minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20).r,
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2.w,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.blueGrey,
                              width: 2.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //SizedBox(width: 10.w,),
                    InkWell(
                      onTap: () {
                        if (homeController.controller.value.text.isEmpty) {
                          return null;
                        }
                        homeController.featchAllMessage();
                        homeController.controller.clear();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20).r,
                        ),
                        height: 50,
                        width: 40,
                        child: Center(
                          child: Icon(Icons.send, color: Colors.blue, size: 30),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
