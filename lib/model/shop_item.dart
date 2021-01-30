import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class ShopItem {
  final String typeTitle;
  final String title;
  final String icon;
  final String link;
  final String id;

  ShopItem({this.id, this.typeTitle, this.title, this.icon, this.link});

  ShopItem.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.key,
        typeTitle = snapshot.value["typeTitle"],
        icon = snapshot.value["icon"],
        link = snapshot.value["link"],
        title = snapshot.value["title"];

  toJson() {
    return {
      "icon": icon,
      "link": link,
      "title": title,
      "typeTitle": typeTitle
    };
  }
}
