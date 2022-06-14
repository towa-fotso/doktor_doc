// ignore_for_file: file_names

import 'dart:io';

import 'package:docteur_doc/google_api/systemEvents.dart';
import 'package:flutter/material.dart';
import 'package:docteur_doc/google_api/excelOps.dart';
import 'package:open_file/open_file.dart';

class FileStoredpage extends StatefulWidget {
  const FileStoredpage({Key? key}) : super(key: key);

  @override
  State<FileStoredpage> createState() => _FileStoredpageState();
}

class _FileStoredpageState extends State<FileStoredpage> {
  Future<List<FileSystemEntity>?>? _folders;
  bool download = false;

  @override
  void initState() {
    super.initState();
    _folders = getDir();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FileSystemEntity>?>(
        future: _folders,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<FileSystemEntity>? data = [];
            data.clear();
            data = snapshot.data;
            // ignore: avoid_print
            print(data!.length);
            if (data.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.notifications),
                  Text("Votre Espace donnees locale est vide"),
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
                    return createDataItem(
                        data![index].toString(), context, data[index].path);
                  });
            }
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
                  "Nous recuperons vos donnees Locales",
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

  Widget createDataItem(String data, BuildContext context, String path) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        String displaydataname = data.split('/').last;
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.blueGrey),
          ),
          margin: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    iconSize: 150,
                    tooltip: "Cliquer Pour Pour ouvrir le document",
                    splashColor: Colors.greenAccent,
                    splashRadius: 5,
                    color: Colors.green,
                    onPressed: (() async {
                      playpressedVibration();
                      playpressedSound();
                      OpenFile.open(path,
                          type:
                              "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                    }),
                    icon: const Icon(
                      Icons.table_view,
                    )),
                Text(displaydataname,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        overflow: TextOverflow.fade,
                        textBaseline: TextBaseline.alphabetic,
                        color: Colors.blueGrey)),
              ],
            ),
          ),
        );
      },
    );
  }
}
