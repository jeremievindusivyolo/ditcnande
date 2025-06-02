import 'package:get/get.dart';

class ControllerApp extends GetxController {
  var count = 0.obs;
  var lastTime = ''.obs;
  var primaryColor = 0XFF8E5765;
  var secondaryColor = 0XFFE3D7D6;
  RxString userString = ''.obs;
  RxString dashUser = ''.obs;
  void increment() {
    count++;
  }

  void setLastTime(String time){
    lastTime.value = time;
  }

  bool testUserConnected(){
    bool toReturn = true;
    if (userString.value.isEmpty){
      toReturn = false;
    }
    return toReturn;
  }

  @override
  void onInit(){
    // Get called when controller is created
    super.onInit();
    /*
    readSession().then((value) {
      userSession.value = value;
      Get.toNamed('/home');
    }, onError: (error) {
      Get.toNamed('/login');
    });

     */
  }

  void setDashUser(String userData){
    dashUser.value = userData;
  }

  void setNewUser (RxString userObject){
    userString = userObject;
  }
}