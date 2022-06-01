import 'package:docteur_doc/google_api/Api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Datapage extends StatefulWidget {
  const Datapage({Key? key}) : super(key: key);

  @override
  State<Datapage> createState() => _DatapageState();
}

class _DatapageState extends State<Datapage> {
  Future<List<String>?>? bucketcontent;
  bool download = false;

  void iniState() {
    super.initState();
    bucketcontent = retrieveProccessedData();
    print("Initialised");
  }

  @override
  Widget build(BuildContext context) {
    rootBundle.loadString('assets/upload_images/credentials.json').then((json) {
      jsonCredentials = json;
    });
    return FutureBuilder<List<String>?>(
        future: retrieveProccessedData(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            List<String>? data = snapshot.data;
            return GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: MediaQuery.of(context).size.height * 0.3,
                    crossAxisCount: 2),
                itemBuilder: (context, int index) {
                  return createDataItem(data![index], context);
                });
          } else if (snapshot.hasError ||
              snapshot.connectionState == ConnectionState.done) {
            return Container(
                decoration: const BoxDecoration(color: Colors.white60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.cloud_off_outlined),
                    Text("Echec de chargement des Donnees"),
                  ],
                ));
          }
          return Container(
            decoration:
                const BoxDecoration(color: Color.fromARGB(153, 53, 52, 52)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(
                  backgroundColor: Colors.white60,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ),
                Text(
                  "Nous recuperons vos donnees",
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _checkUploadingVisibility() {
    if (download) {
      return Container(
        color: Colors.grey,
        child: const Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white60,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget createDataItem(String data, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.blueGrey),
      ),
      margin: const EdgeInsets.all(10),
      child: Stack(children: [
        _checkUploadingVisibility(),
        IconButton(
            tooltip: "Cliquer Pour telecharger le document et le Convertir",
            splashColor: Colors.greenAccent,
            splashRadius: 5,
            color: Colors.white,
            onPressed: (() {
              setState(() {
                download = true;
              });
            }),
            icon: const Icon(Icons.file_present_outlined)),
      ]),
    );
  }
}
