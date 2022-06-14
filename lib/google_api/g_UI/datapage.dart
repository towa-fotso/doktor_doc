import 'package:docteur_doc/google_api/Api.dart';
import 'package:docteur_doc/google_api/systemEvents.dart';
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
  bool deleting = false;

  @override
  void initState() {
    super.initState();
    bucketcontent = retrieveProccessedData();
  }

  @override
  Widget build(BuildContext context) {
    rootBundle.loadString('assets/upload_images/credentials.json').then((json) {
      jsonCredentials = json;
    });
    return FutureBuilder<List<String>?>(
        future: bucketcontent,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            List<String>? data = [];
            data.clear();
            data = snapshot.data;
            if (data!.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.notifications),
                  Text("Votre Espace donnees est vide"),
                ],
              );
            } else {
              return GridView.builder(
                  itemCount: snapshot.data?.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: MediaQuery.of(context).size.height * 0.3,
                      crossAxisCount: 2),
                  itemBuilder: (context, int index) {
                    return createDataItem(data![index], context);
                  });
            }
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

  Widget _checkdownloadingVisibility() {
    if (download) {
      return const Center(
        child: CircularProgressIndicator(
          //backgroundColor: Colors.white60,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _checkdeletingVisibility() {
    if (deleting) {
      return const Center(
        child: CircularProgressIndicator(
          //backgroundColor: Colors.white60,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget createDataItem(String data, BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        String displaydataname = data.split('/').last;
        //print(data);
        return Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Card(
            /*shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.blueGrey),
            ),*/
            margin: const EdgeInsets.all(10),
            child: Stack(children: [
              const Center(
                child: Icon(
                  Icons.file_present_outlined,
                  size: 150,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 200,
                    height: 40,
                    color: const Color.fromARGB(119, 0, 98, 255),
                    child: Text(displaydataname,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            overflow: TextOverflow.fade,
                            textBaseline: TextBaseline.alphabetic,
                            color: Colors.blueGrey)),
                  ),
                  Container(
                    color: Colors.black87,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: (() {}),
                            icon: const Icon(Icons.storage,
                                color: Colors.blueAccent)),
                        !download
                            ? IconButton(
                                tooltip:
                                    "Cliquer Pour telecharger le document et le Convertir",
                                splashColor: Colors.greenAccent,
                                splashRadius: 5,
                                onPressed: (() async {
                                  playpressedVibration();
                                  playpressedSound();
                                  setState(() {
                                    download = true;
                                  });
                                  await downloadfile(data, displaydataname);
                                  //dialog(context: context, batchtext: text);

                                  setState(() {
                                    download = false;
                                  });
                                }),
                                icon: const Icon(Icons.download,
                                    color: Colors.blueAccent))
                            : _checkdownloadingVisibility(),
                        !deleting
                            ? IconButton(
                                tooltip:
                                    "Cliquer Pour supprimer l'image de votre espace",
                                splashColor: Colors.greenAccent,
                                splashRadius: 5,
                                onPressed: (() async {
                                  playpressedVibration();
                                  playpressedSound();
                                  
                                  setState(() {
                                    deleting = true;
                                  });
                                  await deleteFile(data, false);
                                  setState(() {});
                                  setState(() {
                                    deleting = false;
                                  });
                                }),
                                icon: const Icon(Icons.delete_forever,
                                    color: Colors.blueAccent))
                            : _checkdeletingVisibility(),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          ),
        );
      },
    );
  }
}
