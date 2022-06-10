import 'dart:typed_data';

import 'package:docteur_doc/google_api/excelOps.dart';
import 'package:docteur_doc/google_api/systemEvents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis/documentai/v1.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:docteur_doc/google_api/Api.dart';
import 'package:mime/mime.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);
  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final picker = ImagePicker();
  late Uint8List _imageBytes;
  //GoogleCloudDocumentaiV1ProcessResponse? treatedDoc;
  GoogleLongrunningOperation? treatedDocs;
  List<Uint8List> multiimages = [];
  List<File> multiimagespath = [];
  List<String> imagesname = [];

  bool imageloading = false;
  bool multipleselection = false;
  String Imagename = "";
  var file;
  bool isUploading = false;
  bool uploaded = false;
  CloudApi? api;

  Future<File> singleimageFile(ImageSource source) async {
    setState(() {
      file = null;
      multiimages.clear();
      //multipleselection = true;
      multiimagespath.clear();
      imagesname.clear();
    });
    final pickedFile = await picker.pickImage(source: source);
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      setState(() {
        file = File(pickedFile!.path);
        Imagename = pickedFile.name;
        _imageBytes = file.readAsBytesSync();
      });
    } else if (response.file != null) {
      setState(() {
        file = File(response.file!.path);
        // _imageBytes = file.readAsBytesSync();
      });
    }
    return file;
  }

  @override
  Widget build(BuildContext context) {
    rootBundle.loadString('assets/upload_images/credentials.json').then((json) {
      api = CloudApi(json);
      jsonCredentials = json;
    });
    return Stack(children: [
      ListView(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // ignore: unnecessary_null_comparison
          StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return changedisplay();
            },
          ),
          Center(child: _checkUploadingVisibility())
        ],
      ),
      StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) setState) =>
                Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                child: FloatingActionButton(
                    splashColor: const Color.fromARGB(255, 0, 255, 132),
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    backgroundColor: Colors.blueAccent,
                    child: const Icon(Icons.attach_file),
                    onPressed: (() {
                      playpressedSound();
                      pickmultipleImages();
                    })),
                /* onTap: (()=> singleimageFile(ImageSource.gallery)),*/
              ),
              (file != null || multiimagespath.isNotEmpty) && !isUploading
                  ? ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                        elevation: MaterialStateProperty.all(2.0),
                        shadowColor: MaterialStateProperty.all(
                            const Color.fromARGB(106, 99, 99, 99)),
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder()),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: (() {
                        playpressedSound();
                        //playpressedVibration();
                        setState(() {
                          isUploading = true;
                          multipleselection
                              ? _sendMultipleImage()
                              : _sendImage();
                        });
                      }),
                      child: const Text("Envoyer L'Image"))
                  : !isUploading
                      ? Container()
                      : Center(child: _checkUploadingVisibility()),
              FloatingActionButton(
                splashColor: const Color.fromARGB(255, 0, 255, 132),
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                backgroundColor: Colors.blueAccent,
                child: const Icon(Icons.camera),
                onPressed: (() {
                  playpressedSound();
                  singleimageFile(ImageSource.camera);
                }),
              ),
            ],
          ),
        ),
      )
    ]);
  }

  _sendImage() async {
    if (api == null) {
      rootBundle
          .loadString('assets/upload_images/credentials.json')
          .then((json) {
        api = CloudApi(json);
        jsonCredentials = json;
      });
    }
    final response = await api?.save(Imagename, _imageBytes);

    Fluttertoast.showToast(
      msg: "Image Charger et en cours de traitement",
      textColor: Colors.white,
      backgroundColor: Colors.greenAccent,
      fontSize: 10.0,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
    );
    //treatedDoc;
    await treatSingledocument(_imageBytes,
        Imagename); /*.catchError((e) {
      Fluttertoast.showToast(
        msg: "Une Erreur est survenu",
        textColor: Colors.white,
        backgroundColor: Colors.redAccent,
        fontSize: 10.0,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
      setState(() {
        isUploading = false;
      });
    });*/

    setState(() {
      isUploading = false;
    });
    /*singleDocUri = response?.downloadLink.toString();*/
  }

  _sendMultipleImage() async {
    if (api == null) {
      rootBundle
          .loadString('assets/upload_images/credentials.json')
          .then((json) {
        api = CloudApi(json);
        jsonCredentials = json;
      });
    }
    int counter = 0;
    for (var image in multiimages) {
      final response =
          await api?.save(imagesname[counter], image).catchError((e) {
        Fluttertoast.showToast(
          msg: imagesname[counter] + " non charger",
          textColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 244, 2, 2),
          fontSize: 10.0,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );
        setState(() {
          isUploading = false;
        });
      });
      String? uri = response?.downloadLink.toString();
      List<String> UriList = uri!.split("?");
      String imgname = imagesname[counter];
      onlinedoclicks.add(GoogleCloudDocumentaiV1GcsDocument(
          gcsUri: "gs://$bucketname/$imageSpaces/$imgname",
          mimeType: lookupMimeType(imagesname[counter])));
      counter++;
    }

    print(onlinedoclicks[0].gcsUri);

    counter = 0;
    treatedDocs = await treatMultipledocument().catchError((e) {
      print(e);
      Fluttertoast.showToast(
        msg: "Echec lors du Traitement",
        textColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 244, 2, 2),
        fontSize: 10.0,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
      setState(() {
        isUploading = false;
        onlinedoclicks.clear();
        multiimages.clear();
        multiimagespath.clear();
        imagesname.clear();
      });
    });
    Fluttertoast.showToast(
      msg: "Images Charger avec success et en cours de traitement",
      textColor: Colors.white,
      backgroundColor: Colors.greenAccent,
      fontSize: 10.0,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
    Fluttertoast.showToast(
      msg: "Les resultats seronts disponibles sur la page suivante",
      textColor: Colors.white,
      backgroundColor: Colors.greenAccent,
      fontSize: 20.0,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
    setState(() {
      isUploading = false;
      onlinedoclicks.clear();
      multiimages.clear();
      multiimagespath.clear();
      imagesname.clear();
    });
  }

  Widget _checkUploadingVisibility() {
    if (isUploading) {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
      );
    } else {
      return Container();
    }
  }

  Future<List<Uint8List>> pickmultipleImages() async {
    setState(() {
      file = null;
      multiimages.clear();
      multipleselection = true;
      multiimagespath.clear();
      imagesname.clear();
    });

    final pickedfile = (await picker.pickMultiImage())!;
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      for (var pickedfiles in pickedfile) {
        multiimages.add(await File(pickedfiles.path).readAsBytes());
        setState(() {
          multiimagespath.add(File(pickedfiles.path));
        });

        imagesname.add(pickedfiles.name);
      }
    } else if (response.file != null) {
      setState(() {
        multipleselection = false;
        for (var responses in response.files!) {
          multiimagespath = File(responses.path) as List<File>;
        }
      });
    }
    return multiimages;
  }

  editText(int index) {
    String defaultname = imagesname[index];
    final nameEditor = TextEditingController(text: defaultname);
    return showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text("Renommer le fichier"),
              actions: [
                Material(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: defaultname.isEmpty ? null : defaultname,
                      controller: defaultname.isEmpty ? nameEditor : null,
                      maxLength: 40,
                      validator: (value) {
                        if (value!.length <= 4) {
                          return "Entrer le nom de l'image";
                        } else if (value.contains("/")) {
                          return "Le nom ne doit pas contenir le caractere /";
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onFieldSubmitted: (newname) {
                        setState(() {
                          imagesname.removeAt(index);
                          imagesname.insert(index, newname);
                        });
                        Navigator.pop(context);
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.edit),
                        //errorText: "Longeur Limite atteinte !",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ));
  }

  Widget createViewImage(File image, int index) {
    String defaultname = imagesname[index];
    final nameEditor = TextEditingController(text: defaultname);
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Card(
          //color: Colors.blueAccent,
          /*shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.blueAccent),
          ),*/
          margin: const EdgeInsets.all(10),
          child: Hero(
            tag: const Text(
              "data",
              overflow: TextOverflow.fade,
            ),
            child: Material(
              child: Stack(children: [
                FadeInImage(
                    fit: BoxFit.fill,
                    placeholder:
                        const AssetImage("assets/upload_images/no_user.jpg"),
                    image: FileImage(image)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 40,
                      width: 200,
                      color: const Color.fromARGB(92, 0, 98, 255),
                      child: Text(defaultname,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Container(
                      color: Colors.black87,
                      child: Center(
                          child: IconButton(
                              onPressed: (() => editText(index)),
                              icon: const Icon(Icons.edit,
                                  color: Colors.blueAccent))),
                    ),
                  ],
                ),
              ]),
            ),
          )),
    );
  }

  Widget changedisplay() {
    if (file != null) {
      return Align(
        heightFactor: 1.02,
        child: Container(
            height: MediaQuery.of(context).size.height / 1.2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blueAccent,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                image:
                    DecorationImage(image: FileImage(file), fit: BoxFit.cover)),
            child: null),
      );
    } else if (multiimagespath.isNotEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: GridView.builder(
            shrinkWrap: true,
            itemCount: multiimages.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: MediaQuery.of(context).size.height * 0.3,
                crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return createViewImage(multiimagespath[index], index);
            }),
      );
    } else {
      return Align(
        heightFactor: 1.02,
        child: Container(
          height: MediaQuery.of(context).size.height / 1.2,
          width: MediaQuery.of(context).size.width - 10,
          decoration: BoxDecoration(
            color: Colors.blueGrey[500],
            borderRadius: const BorderRadius.all(Radius.circular(50)),
          ),
          child: const Icon(Icons.upload_file_outlined,
              size: 200, color: Color.fromARGB(255, 168, 168, 168)),
        ),
      );
    }
  }
}
