import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:gcloud/storage.dart';
import 'package:mime/mime.dart';
import 'package:googleapis/documentai/v1.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

class data {
  final key, value;

  data({this.key, this.value});
  factory data.fromJson(Map<String, dynamic> jsonData) {
    return data(
      key: jsonData['key'],
      value: jsonData['value'],
    );
  }
}

String bucketname = "test_buket";
List<String> bucketlistings = [];
List decodedContent = [];

class CloudApi {
  final auth.ServiceAccountCredentials _credentials;
  auth.AutoRefreshingAuthClient? _client;

  CloudApi(String json)
      : _credentials = auth.ServiceAccountCredentials.fromJson(json);

  Future<ObjectInfo> save(String name, Uint8List imgbytes) async {
    // ignore: todo
    //TODO Create a client
    // ignore: prefer_conditional_assignment, unnecessary_null_comparison
    if (_client == null) {
      _client =
          await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);
    }

    // ignore: todo
    //TODO Instantiate objects to cloud storage
    var storage = Storage(_client!, 'Doktor-doc');
    
   /// Checking if the bucket exists and if it doesn't it creates it.
  /*  bool checkbucket = await storage.bucketExists(bucketname);

    if (!checkbucket) {
      storage.createBucket(bucketname,predefinedAcl: PredefinedAcl.private);
      storage.createBucket(bucketname+"/images",predefinedAcl: PredefinedAcl.private);
      storage.createBucket(bucketname+"/data",predefinedAcl: PredefinedAcl.private);
    }
    */
    var bucket = storage.bucket(bucketname);
  

    //This will be used to retrieve all the bucket's listing in an attempt to download the user's required info from batch processes.
    /*List bucketListing = await bucket.list().toList();
    bucketlistings = bucketListing as List<String>;
    print(bucketlistings);

    Stream bucketcontent = bucket.read("");
    //bucketcontent.transform(json.decoder) as List;
    decodedContent = json.decode(bucketcontent.toString());
    decodedContent.map((event) => data.fromJson(event)).toList();*/
    // ignore: todo
    //TODO save to bucket
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    var type = lookupMimeType(name);
    return await bucket.writeBytes(name, imgbytes,
        metadata: ObjectMetadata(contentType: type, custom: {
          'timestamp': '$timestamp',
        }));
  }
}

googlelogin(String name) async {
  var _currentUser;
  final googleSignIn = GoogleSignIn(scopes: [DocumentApi.cloudPlatformScope]);
  bool signedIn = await googleSignIn.isSignedIn();
  if (!signedIn) {
    googleSignIn.signIn();
    googleSignIn.onCurrentUserChanged.listen((account) {
      /* setState(() {

    });*/
      _currentUser = account;
    });
    if (_currentUser != null) {
      treatdocument(googleSignIn, name);
    }
  } else {
    treatdocument(googleSignIn, name);
  }
}

List<GoogleCloudDocumentaiV1GcsDocument> onlinedoclicks = [];
String? singleDocUri = "";
Future<GoogleCloudDocumentaiV1Document?> treatdocument(
    GoogleSignIn googleSignIn, String name) async {
  final authClient = await googleSignIn.authenticatedClient();
  final docApi = DocumentApi(authClient!);

  //docApi.operations;
  //Single file proccess setup

  if (onlinedoclicks.isEmpty) {
    GoogleCloudDocumentaiV1Document singledoc;
    singledoc = GoogleCloudDocumentaiV1Document(
      content: name,
      mimeType: lookupMimeType(name),
      uri: singleDocUri,
    );
    GoogleCloudDocumentaiV1ProcessRequest request;
    request = GoogleCloudDocumentaiV1ProcessRequest(inlineDocument: singledoc);
    GoogleCloudDocumentaiV1Document responsedoc;
    responsedoc = GoogleCloudDocumentaiV1Document();

    GoogleCloudDocumentaiV1ProcessResponse response;

    response = GoogleCloudDocumentaiV1ProcessResponse(document: responsedoc);
    if (response.document != null) {
      return response.document;
    } else {
      Timer.periodic(const Duration(seconds: 30),
          <GoogleCloudDocumentaiV1Document>(Timer available) {
        if (response.document != null) {
          available.cancel();
          return response.document;
        }
      });
    }
  } else {
    GoogleCloudDocumentaiV1DocumentOutputConfigGcsOutputConfig outputConfig;

    //Batch Files proccess setup
    GoogleCloudDocumentaiV1BatchDocumentsInputConfig config;

    outputConfig = GoogleCloudDocumentaiV1DocumentOutputConfigGcsOutputConfig(
        gcsUri: "gs://.$bucketname");

    GoogleCloudDocumentaiV1DocumentOutputConfig batchoutputconf;

    batchoutputconf = GoogleCloudDocumentaiV1DocumentOutputConfig(
        gcsOutputConfig: outputConfig);

    GoogleCloudDocumentaiV1GcsDocuments docsonline;

    docsonline = GoogleCloudDocumentaiV1GcsDocuments(documents: onlinedoclicks);

    config = GoogleCloudDocumentaiV1BatchDocumentsInputConfig(
        gcsDocuments: docsonline);

    GoogleCloudDocumentaiV1BatchProcessRequest batchproccessReq;

    batchproccessReq = GoogleCloudDocumentaiV1BatchProcessRequest(
      inputDocuments: config,
      skipHumanReview: true,
      documentOutputConfig: batchoutputconf,
    );
  }
  return null;
  /*GoogleCloudDocumentaiV1DocumentPageFormField formField;
  formField = GoogleCloudDocumentaiV1DocumentPageFormField();*/
}
