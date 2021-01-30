import 'dart:convert';

class Test{

 int length;

  Test(this.length);


Test.fromJson(Map<dynamic,dynamic> map) : length=map['length'];
  




}

