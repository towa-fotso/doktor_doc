import 'package:docteur_doc/Animation/FadeAnimation.dart';
import 'package:docteur_doc/google_api/Api.dart';
import 'package:docteur_doc/google_api/g_UI/userspace.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({Key? key}) : super(key: key);

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  final bucketnamectrl = TextEditingController();
  final pinNameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool validename = false;
  bool validpin = false;
  Future<String?>? bc;
  int? pin;
  String errormsg = "";

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

  Future<int?> getUserPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int? pin = prefs.getInt('pin');
    return pin;
  }

  addPinToSF(String pin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('pin', int.parse(pin));
  }

  @override
  void initState() {
    super.initState();
    bc = getBucketnameSF();
    pin = getUserPin() as int?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String?>(
          future: bc,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              bucketname = snapshot.data;
                /*return Form(
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
                );*/
                return Scaffold(
                    backgroundColor: Colors.white,
                    body: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 400,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/background.png'),
                                      fit: BoxFit.fill)),
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    left: 30,
                                    width: 80,
                                    height: 200,
                                    child: FadeAnimation(
                                        1,
                                        Container(
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/light-1.png'))),
                                        )),
                                  ),
                                  Positioned(
                                    left: 140,
                                    width: 80,
                                    height: 150,
                                    child: FadeAnimation(
                                        1.3,
                                        Container(
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/light-2.png'))),
                                        )),
                                  ),
                                  Positioned(
                                    right: 40,
                                    top: 40,
                                    width: 80,
                                    height: 150,
                                    child: FadeAnimation(
                                        1.5,
                                        Container(
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/clock.png'))),
                                        )),
                                  ),
                                  Positioned(
                                    child: FadeAnimation(
                                        1.6,
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 50),
                                          child: const Center(
                                            child: Text(
                                              "Login",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Column(
                                children: <Widget>[
                                  bc == null
                                      ? FadeAnimation(
                                          1.8,
                                          Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Color.fromRGBO(
                                                          143, 148, 251, .2),
                                                      blurRadius: 20.0,
                                                      offset: Offset(0, 10))
                                                ]),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  decoration: const BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: Color(
                                                                  0xFFE5E5E5)))),
                                                  child: TextField(
                                                    maxLength: 10,
                                                    controller: bucketnamectrl,
                                                    onEditingComplete: () {
                                                      if (bucketnamectrl
                                                              .text.isEmpty ||
                                                          bucketnamectrl
                                                                  .text.length >
                                                              10 ||
                                                          bucketnamectrl
                                                                  .text.length <
                                                              3 ||
                                                          bucketnamectrl.text
                                                              .contains(" ") ||
                                                          bucketnamectrl.text
                                                              .contains("/") ||
                                                          bucketnamectrl.text
                                                              .contains("\\") ||
                                                          bucketnamectrl.text
                                                              .contains("*") ||
                                                          bucketnamectrl.text
                                                              .contains("?") ||
                                                          bucketnamectrl.text
                                                              .contains("\"") ||
                                                          bucketnamectrl.text
                                                              .contains("<") ||
                                                          bucketnamectrl.text
                                                              .contains(">") ||
                                                          bucketnamectrl.text
                                                              .contains("|")) {
                                                        return;
                                                      } else {
                                                        validename = true;
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                        errorText: !validename
                                                            ? "Veulliez Saisir un Nom sans caractere speciaux, sans espace, et de 3 a 15 caracteres"
                                                            : null,
                                                        icon: const Icon(
                                                            Icons.storage),
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            "Nom de Stockage",
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400])),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                    controller: pinNameCtrl,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    maxLength: 4,
                                                    onEditingComplete: () {
                                                      int inputPin =
                                                          int.parse(pinNameCtrl
                                                              .text);
                                                      if (pinNameCtrl
                                                              .text.length !=
                                                          4 && bc == null) {
                                                        validpin = false;
                                                        errormsg = "Le PIN doit contenir 4 chiffres";
                                                      }
                                                      else if(inputPin != pin){
                                                        validpin = false;
                                                        errormsg = "Le PIN est incorrect";
                                                      }
                                                      else{
                                                        validpin = true;
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                        icon: const Icon(
                                                            Icons.pin),
                                                        errorText: !validpin
                                                            ? errormsg
                                                            : null,
                                                        border:
                                                            InputBorder.none,
                                                        hintText: "Code Pin",
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400])),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ))
                                      : Container(),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  FadeAnimation(
                                      2,
                                      Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient:
                                                const LinearGradient(colors: [
                                              Color.fromRGBO(143, 148, 251, 1),
                                              Color.fromRGBO(143, 148, 251, .6),
                                            ])),
                                        child: Center(
                                          child: TextButton(
                                            onPressed: () {
                                              if (bc == null) {
                                                if (validename && validpin) {
                                                  bucketname =
                                                      pinNameCtrl.text +
                                                          bucketnamectrl.text;
                                                  addBucketnameToSF(
                                                      bucketnamectrl.text);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const UserSpace()));
                                                }
                                              } else if (bc != null) {
                                                if (validpin) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const UserSpace()));
                                                }
                                              }
                                            },
                                            child: const Text(
                                              "Login",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      )),
                                  /* const SizedBox(
                                    height: 70,
                                  ),
                                  FadeAnimation(
                                      1.5,
                                      const Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                143, 148, 251, 1)),
                                      )),*/
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ));
              
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
