import 'package:docteur_doc/google_api/Api.dart';
import 'package:docteur_doc/google_api/systemEvents.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/documentai/v1.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({Key? key}) : super(key: key);

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  GoogleCloudDocumentaiV1ProcessResponse? treatedDoc;
  Future<List<String>?>? bucketcontent;
  bool process = false;
  bool deleting = false;

  @override
  void initState() {
    super.initState();
    bucketcontent = retrieveLoadedImages();
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
                  Text("Votre Espace Images est vide"),
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
                    Text("Echec de chargement des Images"),
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
                  "Nous recuperons vos images",
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
    if (process) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
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
                  Icons.image,
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
                        !process
                            ? IconButton(
                                tooltip: "Cliquer pour scanner le document",
                                splashColor: Colors.greenAccent,
                                splashRadius: 5,
                                onPressed: (() async {
                                  playpressedVibration();
                                  playpressedSound();
                                  setState(() {
                                    process = true;
                                  });
                                  treatedDoc =
                                      await treatClouddocument(displaydataname);

                                  setState(() {
                                    process = false;
                                  });
                                }),
                                icon: const Icon(Icons.document_scanner,
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
                                  await deleteFile(data, true);

                                  setState(() {
                                    deleting = false;
                                  });
                                  setState(() {});
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
