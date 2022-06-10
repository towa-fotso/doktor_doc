import 'package:docteur_doc/google_api/Api.dart';
import 'package:docteur_doc/google_api/g_UI/userspace.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/adsense/v1_4.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({Key? key}) : super(key: key);

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  final bucketnamectrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future<String?>? bc;

  addBucketnameToSF(String bucketname) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('bucketname', bucketname);
  }

  Future<String?> getBucketnameSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    String? name = prefs.getString('bucketname');
    return name;
  }

  @override
  void initState() {
    super.initState();
    bc = getBucketnameSF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String?>(
          future: bc,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              bucketname = snapshot.data;
              if (bucketname == null) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Bienvenue sur Docteur Doc',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 18.0,
                        ),
                      ),
                      const Text(
                        'Veuillez entrer votre nom espace de stockage',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 18.0,
                        ),
                      ),
                      const Text(
                        "Si il n'existe pas, il sera créée",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 20.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: TextFormField(
                          maxLength: 10,
                          controller: bucketnamectrl,
                          validator: (value) {
                            if (value!.isEmpty ||
                                value.length > 15 ||
                                value.length < 3 ||
                                value.contains(" ") ||
                                value.contains("/") ||
                                value.contains("\\") ||
                                value.contains("*") ||
                                value.contains("?") ||
                                value.contains("\"") ||
                                value.contains("<") ||
                                value.contains(">") ||
                                value.contains("|")) {
                              return "Veulliez Saisir un Nom sans caractere speciaux, sans espace, et de 3 a 15 caracteres";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              icon: Icon(Icons.folder),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueAccent,
                                ),
                              ),
                              hintText: "Nom de votre espace de stockage",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.lime[600]),
                          child: const Text("Creer"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              bucketname = bucketnamectrl.text;
                              addBucketnameToSF(bucketnamectrl.text);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const UserSpace(),
                                ),
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return const UserSpace();
              }
            }
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration:
                  const BoxDecoration(color: Color.fromARGB(153, 53, 52, 52)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(
                    backgroundColor: Colors.white60,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  ),
                  Text(
                    "Doctor Doc recherche le nom de votre espace de stockage",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
            );
          })),
    );
  }
}
