import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis/documentai/v1.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:docteur_doc/google_api/Api.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);
  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final picker = ImagePicker();
  late Uint8List _imageBytes;
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

  @override
  void iniState() {
    super.initState();
    rootBundle.loadString('assets/upload_images/credentials.json').then((json) {
      api = CloudApi(json);
    });
  }

  Future<File> singleimageFile(ImageSource source) async {
    setState(() {
      file = null;
      multiimages.clear();
      multipleselection = true;
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
    return Scaffold(
      body: Stack(children: [
        ListView(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // ignore: unnecessary_null_comparison
            changedisplay(),
          ],
        ),
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
                    onPressed: (() => singleimageFile(ImageSource.gallery))),
                onLongPress: (() => pickmultipleImages()),
                /* onTap: (()=> singleimageFile(ImageSource.gallery)),*/
              ),
              file != null || multiimagespath.isNotEmpty
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
                        setState(() {
                          multipleselection
                              ? _sendMultipleImage()
                              : _sendImage();
                        });
                      }),
                      child: const Text("Envoyer L'Image"))
                  : Container(),
              FloatingActionButton(
                splashColor: const Color.fromARGB(255, 0, 255, 132),
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                backgroundColor: Colors.blueAccent,
                child: const Icon(Icons.camera),
                onPressed: (() => singleimageFile(ImageSource.camera)),
              ),
            ],
          ),
        )
      ]),
    );
  }

  _sendImage() async {
    if (api == null) {
      rootBundle
          .loadString('assets/upload_images/credentials.json')
          .then((json) {
        api = CloudApi(json);
      });
    }
    isUploading = true;
    final response = await api?.save(Imagename, _imageBytes);
    /*onlinedoclicks.add(GoogleCloudDocumentaiV1GcsDocument(
        gcsUri: response?.downloadLink.toString()));*/
    singleDocUri = response?.downloadLink.toString();
    googlelogin(Imagename);
    isUploading = false;
    Fluttertoast.showToast(
      msg: "Image Charger et en cours de traitement",
      textColor: Colors.white,
      backgroundColor: Colors.greenAccent,
      fontSize: 10.0,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
    );
  }

  _sendMultipleImage() async {
    if (api == null) {
      rootBundle
          .loadString('assets/upload_images/credentials.json')
          .then((json) {
        api = CloudApi(json);
      });
    }
    isUploading = true;
    int counter = 0;
    for (var image in multiimages) {
      final response = await api?.save(imagesname[counter], image);
      onlinedoclicks.add(GoogleCloudDocumentaiV1GcsDocument(
          gcsUri: response?.downloadLink.toString()));
      counter++;
    }
    counter = 0;
    isUploading = false;
    if (onlinedoclicks.isEmpty) {
      Fluttertoast.showToast(
        msg: "Echec de chargement",
        textColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 244, 2, 2),
        fontSize: 10.0,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Images Charger avec success",
        textColor: Colors.white,
        backgroundColor: Colors.greenAccent,
        fontSize: 10.0,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      setState(() {
        onlinedoclicks.clear();
        multiimages.clear();
        multiimagespath.clear();
        imagesname.clear();
      });
    }
  }

  _checkUploadingVisibility() {
    isUploading
        ? const CircularProgressIndicator(
            value: 5.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
          )
        : null;
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
        print("$imagesname");
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

  Widget createViewImage(File image, int index) {
    String defaultname = imagesname[index];
    final nameEditor = TextEditingController(text: defaultname);
    return Material(
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.blueAccent),
          ),
          margin: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FadeInImage(
                    fit: BoxFit.fill,
                    placeholder:
                        const AssetImage("assets/upload_images/no_user.jpg"),
                    image: FileImage(image)),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    initialValue: defaultname.isEmpty ? null : defaultname,
                    controller: defaultname.isEmpty ? nameEditor : null,
                    maxLength: 40,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onFieldSubmitted: (newname) {
                      imagesname.removeAt(index);
                      imagesname.insert(index, newname);
                    },
                    decoration: const InputDecoration(
                      //errorText: "Longeur Limite atteinte !",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget changedisplay() {
    if (file != null) {
      return Expanded(
        child: Stack(
          children: [
            Image.file(
              file,
              filterQuality: FilterQuality.high,
              fit: BoxFit.fill,
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: _checkUploadingVisibility()),
          ],
        ),
      );
    } else if (multiimagespath.isNotEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height,
        child: GridView.builder(
            shrinkWrap: true,
            itemCount: multiimages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return createViewImage(multiimagespath[index], index);
            }),
      );
    } else {
      return Container(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width - 10,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              image: DecorationImage(
                  image: AssetImage("assets/upload_images/no_user.jpg"))));
    }
  }
}
