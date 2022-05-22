import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:custom_navigator/custom_navigator.dart';
import 'package:docteur_doc/google_api/g_UI/upload_UI.dart';
import 'package:flutter/material.dart';

class UserSpace extends StatefulWidget {
  final String title;

  UserSpace({Key? key, required this.title});

  @override
  State<UserSpace> createState() => _UserSpaceState();
}

class _UserSpaceState extends State<UserSpace> {
  //Keys Used for navigation between pages
  GlobalKey _bottomNavigationKey = GlobalKey();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Page _page = const Page(title: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 1,
        height: 50,
        items: const [
          Icon(
            Icons.image,
            size: 30,
          ),
          Icon(
            Icons.data_object,
            size: 30,
          ),
          Icon(
            Icons.cloud_upload,
            size: 30,
          ),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 69, 168, 249),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 500),
        onTap: (index) {
          setState(() {
            switch (index) {
              case 0:
                _page = const Page(title: "Mes Images");
                break;
              case 1:
                _page = const Page(title: "Mes Donnees");
                break;
              case 2:
                _page = const Page(title: "Traitements");
                break;
              default:
            }
          });
        },
      ),
      body: Container(
        color: const Color.fromARGB(255, 69, 168, 249),
        child: CustomNavigator(
          navigatorKey: navigatorKey,
          home: _page,
          pageRoute: PageRoutes.materialPageRoute,
        ),
      ),
    );
  }
}

class Page extends StatefulWidget {
  final String title;
  const Page({required this.title});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  GlobalKey<NavigatorState> navigatorKey1 = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    switch (widget.title) {
      case "Mes Images":
        return Container();
      case "Mes Donnees":
        return Container();
      case "Traitements":
        return const UploadPage();
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 50,
        title: Text(widget.title),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlueAccent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter)),
        ),
      ),
    );
  }
}
