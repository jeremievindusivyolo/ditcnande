import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'ctrl/api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'ctrl/getCTRL.dart';
import 'dart:developer';
import 'dart:convert';
import 'ctrl/dictionnary_sync.dart';
import 'dictionary_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _App();
}



class _App extends State<HomeScreen>  {
  final ctrl = Get.put(ControllerApp());
  bool showSearchInAppBar = false;
  bool showSuggestions = false;
  TextEditingController searchCtrl = TextEditingController();
  ScrollController scrollController = ScrollController();
  List wordsList = [];

  late final DictionarySync sync;


  void _callGetWordsReq() async {
    Get.rawSnackbar(
      message: 'Chargement des données'
    );
    try {
      final http.Response response = await API().getWords(ctrl.lastTime);
      if (response.statusCode == 200) {
        final reponse = jsonDecode(response.body);

        print(reponse);

        if (reponse['code'] == true) {

        }
      } else {

      }
    } catch (e) {
      log(e.toString());
      Get.rawSnackbar(
          message: 'Echec, Essayez plus tard'
      );
    }
  }

  @override
  void initState() {
    scrollController.addListener(() { //scroll listener
      double showoffset = 70.0; //Back to top botton will show on scroll offset 10.0
      if(scrollController.offset > showoffset){
        setState(() {
          showSearchInAppBar = true;
        });
      }else{
        setState(() {
          showSearchInAppBar = false;
        });
      }
    });
    // TODO: implement initState
    super.initState();

    //navigate to DictionaryScreen()



    WidgetsBinding.instance.addPostFrameCallback((_) {

    });
  }


  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    //_loadProducts();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.background,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () async{
            final dir = await getApplicationDocumentsDirectory();
            debugPrint('DB is at: ${dir.path}/dictionary.db');
            Get.to(() => DictionaryScreen());
          },
          child: Icon(Icons.dashboard),
        ),
        title: !showSearchInAppBar ? Text('Dictionaire Nande') :
        Padding(
          padding: EdgeInsets.only(bottom: 10, top: 5),
          child: TextFormField(
            //cursorColor: Colors.white,
            keyboardType: TextInputType.text,
            controller: searchCtrl,
            onChanged: (value){

              if(value.isNotEmpty){
                setState(() {
                  showSearchInAppBar = true;
                  showSuggestions = true;
                });
              }else{
                setState(() {
                  showSearchInAppBar = false;
                  showSuggestions = false;
                });
              }
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 0, horizontal: 20),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(Icons.close),
                onPressed: (){
                  setState(() {
                    searchCtrl.text = '';
                  });
                },
              ),
              fillColor: Theme.of(context).colorScheme.background,
              filled: true,
              hintText: 'Recherche 2...',
              hintStyle: TextStyle(fontFamily: 'Regular'),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20)),
            ),
            validator: (value) {
              if ((value == null || value.isEmpty)) {
                return 'Rechereche invalide';
              }
              return null;
            },
          ).animate().fadeIn(),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(10),
            child: GestureDetector(
              onTap: (){

              },
              child: Icon(Icons.star),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      height: showSearchInAppBar ? 0 : 70,
                      duration: const Duration(milliseconds: 200),
                      color: Theme.of(context).colorScheme.primary,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: TextFormField(
                          //cursorColor: Colors.white,
                          keyboardType: TextInputType.text,
                          controller: searchCtrl,
                          onChanged: (value){
                            if(value.isNotEmpty){
                              setState(() {
                                showSearchInAppBar = true;
                                showSuggestions = true;
                              });
                            }else{
                              setState(() {
                                showSearchInAppBar = false;
                                showSuggestions = false;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: (){
                                setState(() {
                                  searchCtrl.text = '';
                                });
                              },
                            ),
                            fillColor: Theme.of(context).colorScheme.background,
                            filled: true,
                            hintText: 'Recherche ...',
                            hintStyle: TextStyle(fontFamily: 'Regular'),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          validator: (value) {
                            if ((value == null || value.isEmpty)) {
                              return 'Rechereche invalide';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    wordsList.isNotEmpty ?
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).colorScheme.secondary,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(wordsList.length, (index) {
                            return ListTile(
                              title: Text('Abatunga', style: Theme.of(context).textTheme.titleMedium),
                              subtitle: Text('une parenté, un membre du clan'),
                            );
                          }),
                        ),
                      ),
                    ): Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.60,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.hourglass_empty, size: Theme.of(context).textTheme.displayLarge?.fontSize),
                            SizedBox(height: 20),
                            Text('Vous n\'avez pas encore les données du dictionnaire'),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: (){
                                    _callGetWordsReq();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Recharger les données'),
                                      Icon(Icons.download)
                                    ],
                                  ),
                                )
                              ],
                            )
                          ]
                        ),
                      ),
                    )
                  ],
                ),
              ),
              AnimatedPositioned(
                left: 0,
                top: 0,
                duration: const Duration(milliseconds: 200),
                width: MediaQuery.of(context).size.width,
                height: showSuggestions ? MediaQuery.of(context).size.height : 0,
                child: Scaffold(
                  appBar: AppBar(
                    centerTitle: false,
                    automaticallyImplyLeading: false,
                    title: Text('Suggestions', style: Theme.of(context).textTheme.bodyMedium),
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: IconButton(
                          onPressed: (){
                            setState(() {
                              showSuggestions = false;
                            });
                          },
                          icon: Icon(Icons.close),
                        ),
                      )

                    ],
                  ),
                  body: Container(
                    color: Theme.of(context).colorScheme.background,
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          ListTile(
                            leading: Icon(Icons.search),
                            title: Text('abandu'),
                            trailing: GestureDetector(
                              onTap: (){
                                setState(() {
                                  searchCtrl.text = '';
                                });
                              },
                              child: Icon(Icons.close),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.search),
                            title: Text('abandu'),
                            trailing: GestureDetector(
                              onTap: (){

                              },
                              child: Icon(Icons.close),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.search),
                            title: Text('abandu'),
                            trailing: GestureDetector(
                              onTap: (){

                              },
                              child: Icon(Icons.close),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.search),
                            title: Text('abandu'),
                            trailing: GestureDetector(
                              onTap: (){

                              },
                              child: Icon(Icons.close),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.search),
                            title: Text('abandu'),
                            trailing: GestureDetector(
                              onTap: (){

                              },
                              child: Icon(Icons.close),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.search),
                            title: Text('abandu'),
                            trailing: GestureDetector(
                              onTap: (){

                              },
                              child: Icon(Icons.close),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().slideX(),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}