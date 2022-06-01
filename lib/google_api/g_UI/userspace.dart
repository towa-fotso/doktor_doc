import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:custom_navigator/custom_navigator.dart';
import 'package:docteur_doc/google_api/g_UI/datapage.dart';
import 'package:docteur_doc/google_api/g_UI/upload_UI.dart';
import 'package:flutter/material.dart';

class UserSpace extends StatefulWidget {

  const UserSpace({Key? key});

  @override
  State<UserSpace> createState() => _UserSpaceState();
}

class _UserSpaceState extends State<UserSpace> {
  //Keys Used for navigation between pages
  GlobalKey _bottomNavigationKey = GlobalKey();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Page _page = const Page("Traitements");
  String pagename = "Traitements";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 50,
        title: Text(pagename),
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
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 2,
        height: 50,
        items: const [
          Icon(
            Icons.image,
            size: 30,
          ),
          Icon(
            Icons.file_download_rounded,
            size: 30,
            //color: Colors.black,
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
                pagename = "Mes Images";
                _page = const Page("Mes Images");
                break;
              case 1:
                pagename = "Mes Donnees";
                _page = const Page("Mes Donnees");
                break;
              case 2:
                pagename = "Traitements";
                _page = const Page("Traitements");
                break;
              default:
            }
          });
        },
      ),
      body: CustomNavigator(
        navigatorKey: navigatorKey,
        home: _page,
        pageRoute: PageRoutes.materialPageRoute,
      ),
    );
  }
}

class Page extends StatefulWidget {
  final String title;
  const Page(this.title) : assert(title != null);

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
        return const Datapage();
      case "Traitements":
        return const UploadPage();
    }
    return Container();
  }
}
