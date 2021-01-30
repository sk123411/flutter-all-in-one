import 'package:flutter/cupertino.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FirebaseProvider extends ChangeNotifier {

  FirebaseApp _firebaseApp;

  int length;



  FirebaseApp getFirebase(){
    return _firebaseApp;
  }


  void setFirebase(FirebaseApp app){
    app = _firebaseApp;

  }

   getLength() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

                notifyListeners();

      return length = prefs.getInt("length"); 

  }


}