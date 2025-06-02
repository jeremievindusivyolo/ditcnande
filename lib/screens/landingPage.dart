import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'ctrl/getCTRL.dart';
import 'dart:developer';
import 'dart:convert';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key, required this.title});

  final String title;

  @override
  State<LandingScreen> createState() => _App();
}



class _App extends State<LandingScreen>  {
  final ctrl = Get.put(ControllerApp());
  bool continuPositionned = false;

  @override
  void initState() {
    if (ctrl.testUserConnected()){
      Get.toNamed('/home');
    }

    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {

    });
  }


  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    //_loadProducts();
    return Scaffold(
      backgroundColor: Colors.white,
      body : Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(ctrl.primaryColor),
                ],
              )
          ),
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),

                    Text(
                      "Votre mariage de rêve commence ici",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize : 18,
                        color: Colors.white,
                        fontFamily: 'Regular',
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: (){
                        Get.toNamed('/home');
                      },
                      child: Text('Continuer'),
                    ),
                    SizedBox(height: 10),
                    SizedBox(height: 30),
                  ],
                ),
              )
            ],
          )

      ),
    );
  }
}