import 'package:all_in_one_shop/provider/firebase_provider.dart';
import 'package:all_in_one_shop/screens/home.dart';
import 'package:all_in_one_shop/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity/connectivity.dart';
import 'screens/no_connection.dart';
import 'package:page_transition/page_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
            appId: '1:297855924061:ios:c6de2b69b03a5be8',
            apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
            projectId: 'flutter-firebase-plugins',
            messagingSenderId: '297855924061',
            databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
          )
        : FirebaseOptions(
            appId: '1:857827055895:android:cda4003e5703903925ff52',
            apiKey: 'AIzaSyCDrq_00ULTmbyv4yZFxa_o8VvGV8-uYSw',
            messagingSenderId: '297855924061',
            projectId: 'flutter-firebase-plugins',
            databaseURL: 'https://allinone-e2d4b-default-rtdb.firebaseio.com',
          ),
  );


ErrorWidget.builder = (FlutterErrorDetails details) {
    bool inDebug = false;
    assert(() { inDebug = true; return true; }());
    // In debug mode, use the normal error widget which shows
    // the error message:
    if (inDebug){
            print("error ${details.exception}");

       runApp(NotConnectedScreen(title: "You "));

    }else{
                
         runApp(NotConnectedScreen(title: "You "));

    
    }
    return ErrorWidget(details.exception);
};
    
    runApp(Builder(
    builder: (BuildContext context) {
   
    return MyApp();

    }
  ), );
    
    

    
  
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (c) => FirebaseProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: true,
        title: 'Flutter Demo',
        home: StreamBuilder(
            stream: checkConectivity().asStream().asBroadcastStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                bool connection;
                connection = snapshot.data;


                if (connection) {
                  return SplashScreen();
                } else {
                  return NotConnectedScreen(title:"You are not connected to internet",);
                }
              } else {
                return NotConnectedScreen(title:"You are not connected to internet",);
              }
            }),
      ),
    );
  }

  Future<bool> checkConectivity() async {
    bool isConnected = false;

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      isConnected = true;
             return isConnected;


    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      isConnected = true;
    return isConnected;

    } else {
      isConnected = false;
          print(isConnected);
    return isConnected;

    }


  }

 
}
