import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:all_in_one_shop/widgets/offer_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:all_in_one_shop/model/shop_item.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:all_in_one_shop/model/tab_item.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'package:all_in_one_shop/screens/no_connection.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController tabController;
  StreamController<int> lengthcontroller = StreamController<int>();
  StreamController<PlatformException> platformExcepton =
      StreamController<PlatformException>();

  var subscription;
  var exception;

  bool isConTrollerCreated = true;
  int selectedIndex = 0;

  final shopItems = [
    ShopItem(
        typeTitle: "Shopping",
        icon: "image.png",
        link: "https://flipkart.com",
        title: "Flipkart"),
    ShopItem(
        typeTitle: "Shopping",
        icon: "image.png",
        link: "https://s0.2mdn.net/simgad/5011722324896636776",
        title: "amazon.com"),
    ShopItem(
        typeTitle: "Shopping",
        icon: "https://s0.2mdn.net/simgad/5011722324896636776",
        link: "https://shopclues.com",
        title: "shopclues.com"),
    ShopItem(
        typeTitle: "Shopping",
        icon: "https://s0.2mdn.net/simgad/5011722324896636776",
        link: "https://myntra.com",
        title: "myntra"),
    ShopItem(
        typeTitle: "Shopping",
        icon: "image.png",
        link: "https://s0.2mdn.net/simgad/5011722324896636776",
        title: "myntra"),
    ShopItem(
        typeTitle: "Shopping",
        icon: "image.png",
        link: "myntra.com",
        title: "myntra"),
    ShopItem(
        typeTitle: "Shopping",
        icon: "https://s0.2mdn.net/simgad/5011722324896636776",
        link: "myntra.com",
        title: "myntra"),
    ShopItem(
        typeTitle: "Shopping",
        icon: "https://s0.2mdn.net/simgad/5011722324896636776",
        link: "myntra.com",
        title: "myntra"),
    ShopItem(
        typeTitle: "Shopping",
        icon: "https://s0.2mdn.net/simgad/5011722324896636776",
        link: "myntra.com",
        title: "myntra"),
  ];

  @override
  initState() {
    setTabController();

    subscription = Connectivity().checkConnectivity().asStream();
    exception = PlatformException(code: "No data");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (isConTrollerCreated) {
      Stream streamData = lengthcontroller.stream;

      streamData.listen((event) {
        tabController = TabController(
          length: event,
          vsync: this,
          initialIndex: 0,
        );
      });

      isConTrollerCreated = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = FirebaseDatabase.instance.reference().child("Test");
    final tablist = List<TabItem>();

    return StreamBuilder(
        stream: subscription,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            try {
              return StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .reference()
                      .child("Tabs")
                      .child("tabdata")
                      .once()
                      .asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Map<dynamic, dynamic> values = snapshot.data.value;

                      values.forEach((key, value) {
                        print(key.toString());
                        tablist.add(TabItem(
                            key: key.toString(),
                            title: value['title'],
                            iconCode: value['iconCode'],
                            iconFontFamily: value['iconFontFamily']));
                      });
                      try {
                        return DefaultTabController(
                          length: tabController.length ?? 1,
                          child: Scaffold(
                            drawer: buildDrawer(tablist),
                            appBar: AppBar(
                              bottom: TabBar(
                                  controller: tabController,
                                  isScrollable: true,
                                  tabs: List.generate(tablist.length, (index) {
                                    return Tab(
                                      text: tablist[index].title,
                                      icon: Icon(
                                        IconData(
                                            int.parse(tablist[index].iconCode),
                                            fontFamily:
                                                tablist[index].iconFontFamily),
                                      ),
                                    );
                                  })),
                              title: Text("All in one shop"),
                            ),
                            body: buildPages(tablist, db.reference(), context,
                                tablist.length),
                          ),
                        );
                      } catch (e) {
                        return NotConnectedScreen(
                          title: "You are not connected to internet",
                        );
                      }
                    } else {
                      return NotConnectedScreen(
                        title: "You are not connected to internet",
                      );
                    }
                  });
            } catch (e) {
              return NotConnectedScreen(
                title: "You are not connected to internet",
              );
            }
          } else if (snapshot.hasError) {
            return NotConnectedScreen(
              title: "You are not connected to internet",
            );
          } else {
            return NotConnectedScreen(
              title: "You are not connected to internet",
            );
          }

          // });
        });
  }

  Widget buildPages(List<TabItem> tablist, DatabaseReference db,
      BuildContext context, int size) {
    return TabBarView(
      controller: tabController,
      dragStartBehavior: DragStartBehavior.start,
      children: List.generate(tablist.length, (index) {
        return buildShopPage(tablist[index].key, context);
      }),
    );
  }

  Widget buildShopPage(String key, context) {
    final shopitems = List<ShopItem>();

    return FutureBuilder(
        future: FirebaseDatabase.instance
            .reference()
            .child("Test")
            .child(key)
            .once(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            shopitems.clear();

            Map<dynamic, dynamic> values = snapshot.data.value;

            values.forEach((key, values) {
              shopitems.add(ShopItem(
                  title: values['title'],
                  icon: values['icon'],
                  link: values['link'],
                  typeTitle: values['typeTitle']));
            });

            // print("testttt ${shopItems.toString()}");

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 400,
                    child: GridView.builder(
                      itemCount: shopitems.length,
                      itemBuilder: (c, index) {
                        return FlatButton(
                          onPressed: () {
                            //  tabController.animateTo(1);
                            //Navigate to the homeitem screen

                            // Navigator.of(context).push(MaterialPageRoute
                            // (builder: (c){
                            //     return HomeItem(url:shopItems[index].link, title:shopItems[index].title);
                            // }), );
                          },
                          child: Column(children: [
                            SizedBox(
                                height: 45,
                                child: Image.network(shopitems[index].icon)),
                            Text(shopitems[index].title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                )),
                          ]),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                    ),
                  ),
                          
               
               
               
                buildOfferPage() 
                               
                                
                               
                                ],
                              ),
                            );
                          } else {
                            return Center(
                              child: Text("Loading"),
                            );
                          }
                        });
                  }
                
                  Widget buildDrawer(List<TabItem> tablist) {
                    var drawerKey = GlobalKey<DrawerControllerState>();
                    return Drawer(
                      key: drawerKey,
                      child: ListView.builder(
                          itemCount: tablist.length,
                          itemBuilder: (c, index) {
                            return ListTile(
                              onTap: () {
                                tabController.animateTo(index);
                                Navigator.of(context).pop();
                              },
                              leading: Icon(IconData(int.parse(tablist[index].iconCode),
                                  fontFamily: tablist[index].iconFontFamily)),
                              title: Text(tablist[index].title),
                            );
                          }),
                    );
                  }
                
                  @override
                  void dispose() {
                    super.dispose();
                    lengthcontroller.sink.close();
                    tabController.dispose();
                  }
                
                  void setTabController() {
                    int test;
                    FirebaseDatabase.instance
                        .reference()
                        .child("Tabs")
                        .child("length")
                        .once()
                        .then((value) {
                      test = value.value;
                      lengthcontroller.sink.add(test);
                    });
                  }
                
                  Widget buildOfferPage() {

                       List<Offeritem> offerItems;
                      return StreamBuilder(
                        stream: FirebaseDatabase.instance.reference("Offers")
                        .once().asStream(),

                        builder: (c,snapshot){


                            if(snapshot.hasData){


                             Map<dynamic,dynamic> map = snapshot.data.value;


                             map.forEach((key, value) {

                                offerItems.add(
                                  Offeritem(
                                    title: value['title'],
                                    description: value['description'],
                                    image: value['image'],
                                    dateTime: DateTime.now(),
                                    link:value['link']
                                  )
                                );


                              });  







                            }






                        },


                      )



                  }

  // void setData(int data) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   await prefs.setInt("length", data);
  // }

  // Future<int> getData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   return prefs.getInt("length");
  // }
}
