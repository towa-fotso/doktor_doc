// ignore_for_file: file_names, depend_on_referenced_packages

import 'dart:io';
import 'package:docteur_doc/google_api/Api.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_animations/simple_animations.dart';

final filename = TextEditingController();
final numcol = TextEditingController();
final _formKey = GlobalKey<FormState>();
List<String>? imagesResults = [];
String folderName = "Doktor_doc";
int row = 0;

Future<String?> insertInfo(List<List<String>>? headerrowvalues,
    List<List<String>>? bodyrowvalues, String imagename) async {
  Excel? excel;

  int datalength = 1;
  excel ??= Excel.createExcel();
  //print(headerrowvalues);
  Sheet sheet = excel[imagename];

  sheet.appendRow(headerrowvalues![headerrowvalues.length - 1]);
  for (var i = 0; i < bodyrowvalues!.length; i++) {
    sheet.insertRowIterables(bodyrowvalues[i], datalength);
    datalength++;
    /*if (bodyrowvalues[i + 1] != bodyrowvalues[i]) {
      sheet.insertRowIterables(bodyrowvalues[i], datalength);
      datalength++;
    }*/
  }

  /*while (datalength != datavalue.length - 1) {
    if (datavalue[datalength].isEmpty) {
      datalength++;
    } else {
      /// Iterating and changing values to desired type
      for (int col = 0; col < maxcol; col++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row))
            .value = datavalue[datalength];
        datalength++;
        datalength >= datavalue.length
            ? datalength = datavalue.length - 1
            : datalength;
        print(datavalue[datalength]);
        //datalength++;
      }
      row++;
      print("row : $row");
      //datalength++;
    }
  }*/

  /// Saving the excel file
  var filebytes = excel.save();
  var filePath = await createFolderInAppDocDir().catchError((e) {
    return e;
  });
  File(join("$filePath/$imagename.xlsx"))
    ..createSync(recursive: true)
    ..writeAsBytesSync(filebytes!);

  showToast("Classeur Enregistrer Avec success");
  return null;
}

Future<String> createFolderInAppDocDir() async {
  String folderName = "Doktor_doc";
  //Get this App Document Directory

  final Directory? appDocDir = await getExternalStorageDirectory();
  //App Document Directory + folder name
  final Directory appDocDirFolder =
      Directory('${appDocDir?.path}/$folderName/');

  if (await appDocDirFolder.exists()) {
    //if folder already exists return path
    return appDocDirFolder.path;
  } else {
    //if folder not exists create folder and then return its path
    final Directory appDocDirNewFolder =
        await appDocDirFolder.create(recursive: true);
    return appDocDirNewFolder.path;
  }
}

List<FileSystemEntity>? _folders;
Future<List<FileSystemEntity>?> getDir() async {
  final Directory? directory = await getExternalStorageDirectory();
  final myDir = Directory('${directory?.path}/$folderName/');
  if (await myDir.exists()) {
    //if folder already exists list files found
    _folders = myDir.listSync(recursive: true, followLinks: false);
  } else {
    //if folder not exists create folder and then return list of sub files
    final Directory appDocDirNewFolder = await myDir.create(recursive: true);
    _folders = myDir.listSync(recursive: true, followLinks: false);
  }
  _folders?.forEach((FileSystemEntity file) {
    // ignore: avoid_print
    print(file.path);
  });
  return _folders;
}

Future dialog(
    {required BuildContext
        context /*,
    GoogleCloudDocumentaiV1ProcessResponse? singleDoc,
    String? batchtext}*/
    }) {
  /* if (imagesResults!.isNotEmpty) {
    imagesResults?.clear();
  }
  if (singleDoc != null) {
    imagesResults = singleDoc.document?.text?.split("\n");
  } else {
    imagesResults = batchtext?.split("\n");
    //print(imagesResults?.length);
  }*/

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return PlayAnimation<double>(
          tween: Tween(begin: 50.0, end: 200.0),
          duration: const Duration(seconds: 1),
          builder: (context, child, value) {
            return AlertDialog(
              content: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Positioned(
                    right: -40.0,
                    top: -40.0,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: const CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Icon(Icons.close),
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: TextFormField(
                            controller: filename,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Veulliez Saisir un Nom";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                hintText:
                                    "Veuillez entre le nom du fichier finale",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                          ),
                        ),
                        /* Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            maxLength: 1,
                            controller: numcol,
                            validator: (value) {
                              if (value!.length > 8) {
                                return "Veuillez Saisir un nombre de colonne inferieur a 8";
                              }

                              return null;
                            },
                            decoration: const InputDecoration(
                                hintText:
                                    "Nombre de colonnes du Formulaire desirer",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                          ),
                        ),*/
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.lime[600]),
                            child: const Text("Valider"),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                localfilename = filename.text;
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      });
}

showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    textColor: Colors.white,
    backgroundColor: Colors.greenAccent,
    fontSize: 10.0,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
  );
}
