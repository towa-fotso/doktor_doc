import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:docteur_doc/google_api/excelOps.dart';
import 'package:docteur_doc/models/googleapi_json.dart' as gjson;
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:gcloud/storage.dart';
import 'package:mime/mime.dart';
import 'package:googleapis/documentai/v1.dart';

String? bucketname; //= "test_buket";
String resultSpace = "data";
String imageSpaces = "images";
List<String> bucketlistings = [];
List BactchOpResults = [];
String jsonCredentials = "";
List<List<String>>? headerrowvalues;
List<List<String>>? bodyrowvalues;
GoogleCloudDocumentaiV1Document? batchresponse;
String? localfilename;

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
    var storage = Storage(_client!, 'doktor-doc-346016');

    /// Checking if the bucket exists and if it doesn't it creates it.
    bool checkbucket = await storage.bucketExists(bucketname!);

    if (!checkbucket) {
      storage.createBucket(bucketname!, predefinedAcl: PredefinedAcl.private);
      //storage.createBucket(bucketname+"/data",predefinedAcl: PredefinedAcl.private);
    }

    var bucket = storage.bucket(bucketname!);

    // ignore: todo
    //TODO save to bucket
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    var type = lookupMimeType(name);
    return await bucket.writeBytes(imageSpaces + "/" + name, imgbytes,
        metadata: ObjectMetadata(contentType: type, custom: {
          'timestamp': '$timestamp',
        }));
  }
}

List<GoogleCloudDocumentaiV1GcsDocument> onlinedoclicks = [];
String? singleDocUri = "";

treatSingledocument(Uint8List imgByte, String name) async {
  final auth.AutoRefreshingAuthClient httpClient;
  var credentials = auth.ServiceAccountCredentials.fromJson(jsonCredentials);

  var scopes = [DocumentApi.cloudPlatformScope];

  httpClient = await auth.clientViaServiceAccount(credentials, scopes);

  String processorpath =
      "projects/doktor-doc-346016/locations/us/processors/bf63f8e2d6549283";

  final docApi = DocumentApi(httpClient);

  //Single file proccess setup
  GoogleCloudDocumentaiV1Document singledoc;
  singledoc = GoogleCloudDocumentaiV1Document(
    content: base64Encode(imgByte).toString(),
    mimeType:

        /// A function that returns the mime type of the file.
        lookupMimeType(name),
  );

  GoogleCloudDocumentaiV1Processor documentaiV1Processor;
  documentaiV1Processor = await docApi.projects.locations.processors
      .get(processorpath)
      .catchError((e) => print(e));
  print(documentaiV1Processor.displayName);
  GoogleCloudDocumentaiV1ProcessRequest request;
  request = GoogleCloudDocumentaiV1ProcessRequest(
      inlineDocument: singledoc, skipHumanReview: true);
  GoogleCloudDocumentaiV1ProcessResponse response;
  response = await docApi.projects.locations.processors
      .process(request, processorpath)
      .catchError((e) => print(e));
  //print(response.document?.text);
  //Processedpages = response.document!.pages;

  for (var page in response.document!.pages!) {
    for (var table in page.tables!) {
      headerrowvalues =
          gettabledata(table.headerRows, response.document!.text!);
      bodyrowvalues = gettabledata(table.bodyRows, response.document!.text!);
    }
  }

  return insertInfo(headerrowvalues, bodyrowvalues, name.split(".")[0]);
}

Future<GoogleLongrunningOperation> treatMultipledocument() async {
  final auth.AutoRefreshingAuthClient httpClient;
  var credentials = auth.ServiceAccountCredentials.fromJson(jsonCredentials);

  var scopes = [DocumentApi.cloudPlatformScope];

  httpClient = await auth.clientViaServiceAccount(credentials, scopes);

  String processorpath =
      "projects/doktor-doc-346016/locations/us/processors/bf63f8e2d6549283";

  final docApi = DocumentApi(httpClient);

  GoogleCloudDocumentaiV1DocumentOutputConfigGcsOutputConfig outputConfig;

  //Batch Files proccess setup
  GoogleCloudDocumentaiV1BatchDocumentsInputConfig config;

  GoogleLongrunningOperation batchOp;
  GoogleCloudDocumentaiV1GcsDocuments docsonline;

  outputConfig = GoogleCloudDocumentaiV1DocumentOutputConfigGcsOutputConfig(
      gcsUri: "gs://$bucketname/$resultSpace");

  GoogleCloudDocumentaiV1DocumentOutputConfig batchoutputconf;

  batchoutputconf = GoogleCloudDocumentaiV1DocumentOutputConfig(
      gcsOutputConfig: outputConfig);

  docsonline = GoogleCloudDocumentaiV1GcsDocuments(documents: onlinedoclicks);

  config = GoogleCloudDocumentaiV1BatchDocumentsInputConfig(
      gcsDocuments: docsonline);
  GoogleCloudDocumentaiV1BatchProcessRequest batchproccessReq;

  batchproccessReq = GoogleCloudDocumentaiV1BatchProcessRequest(
    inputDocuments: config,
    skipHumanReview: true,
    documentOutputConfig: batchoutputconf,
  );
  batchOp = await docApi.projects.locations.processors
      .batchProcess(batchproccessReq, processorpath);
  return batchOp;
}

Future<List<String>?> retrieveProccessedData() async {
  final auth.ServiceAccountCredentials _credentials;
  auth.AutoRefreshingAuthClient? _client;
  _credentials = auth.ServiceAccountCredentials.fromJson(jsonCredentials);

  // ignore: todo
  //TODO Create a client
  _client ??=
      await auth.clientViaServiceAccount(_credentials, Storage.SCOPES).timeout(
    const Duration(minutes: 2),
    onTimeout: () {
      _client = null;
      const SnackBar(
        content: Text("Connexion au serveur Expirer"),
        duration: Duration(seconds: 20),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      );
      return _client!;
    },
  ).catchError((_client) {
    _client = null;
    return _client;
  });

  // ignore: todo
  //TODO Instantiate objects to cloud storage
  var storage = Storage(_client!, 'doktor-doc-346016');

  // print(_client.credentials.scopes);

  /// Checking if the bucket exists and if it doesn't it creates it.
  bool checkbucket = await storage.bucketExists(bucketname!);

  if (!checkbucket) {
    //storage.createBucket(bucketname+"/images",predefinedAcl: PredefinedAcl.private);
    storage
        .createBucket(
          bucketname!,
          predefinedAcl: PredefinedAcl.private,
        )
        .catchError((e) => print(e));
  }

//Retrieve Root Bucket
  var bucket = storage.bucket(bucketname!);
  bucketlistings.clear();

  //This will be used to retrieve all the bucket's listing in an attempt to download the user's required info from batch processes.
  List bucketListing = await bucket
      .list(prefix: "data/", delimiter: "")
      .toList()
      .catchError((e) => e);
  //print(bucketListing[0].name.toString());
  if (bucketListing.length == 1) {
    bucketlistings.add(bucketListing[0].name.toString());
  } else {
    for (int i = 0; i < bucketListing.length; i++) {
      bucketlistings.add(bucketListing[i].name.toString());
    }
  }
  return bucketlistings;
}

Future<String?> downloadfile(String fileUrl, String displaydataname) async {
  final auth.ServiceAccountCredentials _credentials;
  auth.AutoRefreshingAuthClient? _client;
  _credentials = auth.ServiceAccountCredentials.fromJson(jsonCredentials);

  // ignore: todo
  //TODO Create a client
  _client ??= await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);

  // ignore: todo
  //TODO Instantiate objects to cloud storage
  var storage = Storage(_client, 'doktor-doc-346016');

  /// Checking if the bucket exists and if it doesn't it creates it.
  bool checkbucket = await storage.bucketExists(bucketname!);

  if (!checkbucket) {
    //storage.createBucket(bucketname+"/images",predefinedAcl: PredefinedAcl.private);
    storage.createBucket(bucketname!, predefinedAcl: PredefinedAcl.private);
  }

  //Retrieve Root Bucket
  var bucket = storage.bucket(bucketname!);

  Stream<List<int>> file = bucket.read(fileUrl).handleError((e) => e);
  String? text = await file.transform(utf8.decoder).join();
  //Batchdata batchdata = Batchdata.fromJson(json.decode(text));
  gjson.BatchOp batchOp = gjson.BatchOp.fromMap(json.decode(text));
  for (var page in batchOp.pages!) {
    for (var table in page.tables!) {
      headerrowvalues = customgettabledata(table.headerRows!, batchOp.text!);
      bodyrowvalues = customgettabledata(table.bodyRows!, batchOp.text!);
    }
  }
  return insertInfo(headerrowvalues, bodyrowvalues, displaydataname);
}

Future deleteFile(String name, bool isimage) async {
  final auth.ServiceAccountCredentials _credentials;
  auth.AutoRefreshingAuthClient? _client;
  _credentials = auth.ServiceAccountCredentials.fromJson(jsonCredentials);

  // ignore: todo
  //TODO Create a client
  _client ??= await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);

  // ignore: todo
  //TODO Instantiate objects to cloud storage
  var storage = Storage(_client, 'doktor-doc-346016');

  /// Checking if the bucket exists and if it doesn't it creates it.
  bool checkbucket = await storage.bucketExists(bucketname!);

  if (!checkbucket) {
    //storage.createBucket(bucketname+"/images",predefinedAcl: PredefinedAcl.private);
    storage.createBucket(bucketname!, predefinedAcl: PredefinedAcl.private);
  }

  //Retrieve Root Bucket
  var bucket = storage.bucket(bucketname!);

  //String filetype = isimage ? imageSpaces : resultSpace;

  return await bucket.delete(name).catchError((e) => e);
}

Future<List<String>?> retrieveLoadedImages() async {
  final auth.ServiceAccountCredentials _credentials;
  auth.AutoRefreshingAuthClient? _client;
  _credentials = auth.ServiceAccountCredentials.fromJson(jsonCredentials);

  // ignore: todo
  //TODO Create a client
  _client ??=
      await auth.clientViaServiceAccount(_credentials, Storage.SCOPES).timeout(
    const Duration(minutes: 2),
    onTimeout: () {
      _client = null;
      const SnackBar(
        content: Text("Connexion au serveur Expirer"),
        duration: Duration(seconds: 20),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      );
      return _client!;
    },
  ).catchError((_client) {
    _client = null;
    return _client;
  });

  // ignore: todo
  //TODO Instantiate objects to cloud storage
  var storage = Storage(_client!, 'doktor-doc-346016');

  // print(_client.credentials.scopes);

  /// Checking if the bucket exists and if it doesn't it creates it.
  bool checkbucket = await storage.bucketExists(bucketname!);

  if (!checkbucket) {
    //storage.createBucket(bucketname+"/images",predefinedAcl: PredefinedAcl.private);
    storage
        .createBucket(
          bucketname!,
          predefinedAcl: PredefinedAcl.private,
        )
        .catchError((e) => print(e));
  }

//Retrieve Root Bucket
  var bucket = storage.bucket(bucketname!);
  bucketlistings.clear();

  //This will be used to retrieve all the bucket's listing in an attempt to download the user's required info from batch processes.
  List bucketListing = await bucket
      .list(prefix: "images/", delimiter: "")
      .toList()
      .catchError((e) => e);
  //print(bucketListing[0].name.toString());
  if (bucketListing.length == 1) {
    bucketlistings.add(bucketListing[0].name.toString());
  } else {
    for (int i = 0; i < bucketListing.length; i++) {
      bucketlistings.add(bucketListing[i].name.toString());
    }
  }
  return bucketlistings;
}

Future<GoogleCloudDocumentaiV1ProcessResponse> treatClouddocument(
    String name) async {
  final auth.AutoRefreshingAuthClient httpClient;
  var credentials = auth.ServiceAccountCredentials.fromJson(jsonCredentials);

  var scopes = [DocumentApi.cloudPlatformScope];

  httpClient = await auth.clientViaServiceAccount(credentials, scopes);

  String processorpath =
      "projects/doktor-doc-346016/locations/us/processors/bf63f8e2d6549283";

  final docApi = DocumentApi(httpClient);

  //Single file proccess setup
  GoogleCloudDocumentaiV1Document singledoc;
  singledoc = GoogleCloudDocumentaiV1Document(
    uri: "gs://$bucketname/$imageSpaces/$name",
  );

  GoogleCloudDocumentaiV1Processor documentaiV1Processor;
  documentaiV1Processor = await docApi.projects.locations.processors
      .get(processorpath)
      .catchError((e) => print(e));
  print(documentaiV1Processor.displayName);
  GoogleCloudDocumentaiV1ProcessRequest request;
  request = GoogleCloudDocumentaiV1ProcessRequest(
      inlineDocument: singledoc, skipHumanReview: true);
  GoogleCloudDocumentaiV1ProcessResponse response;
  response = await docApi.projects.locations.processors
      .process(request, processorpath)
      .catchError((e) => print(e));
  //print(response.document?.text);

  return response;
}

gettabledata(List<GoogleCloudDocumentaiV1DocumentPageTableTableRow>? headerRows,
    String s) {
  List<List<String>?>? allvalues;
  for (var row in headerRows!) {
    List<String>? currentRowValues;
    for (var cell in row.cells!) {
      currentRowValues!.add(textanchortotext(cell.layout!.textAnchor, s));
      allvalues!.add(currentRowValues);
    }
  }
  return allvalues;
}

textanchortotext(
    GoogleCloudDocumentaiV1DocumentTextAnchor? textAnchor, String s) {
  String response = "";
  int? startindex;
  int? endindex;
  for (var segment in textAnchor!.textSegments!) {
    if (segment.startIndex != null) startindex = int.parse(segment.startIndex!);
    if (segment.endIndex != null) endindex = int.parse(segment.endIndex!);
    response += s.substring(startindex!, endindex);
  }
  return response.trim().replaceAll("\n", "");
}

List<List<String>> customgettabledata(List<gjson.Row>? headerRows, String s) {
  List<List<String>> allvalues = [];
  for (var row in headerRows!) {
    List<String> currentRowValues = [];
    for (var cell in row.cells!) {
      currentRowValues.add(customtextanchortotext(cell.layout!.textAnchor!, s));
    }
    allvalues.add(currentRowValues);
  }
  return allvalues;
}

String customtextanchortotext(gjson.PurpleTextAnchor textAnchor, String s) {
  String response = "";
  int startindex = 0;
  int? endindex;
  if (textAnchor.textSegments != null) {
    for (var segment in textAnchor.textSegments!) {
      if (segment.startIndex != null) {
        startindex = int.parse(segment.startIndex!);
      }
      if (segment.endIndex != null) endindex = int.parse(segment.endIndex!);
      response += s.substring(startindex, endindex);
    }
  }
  //print(textAnchor.textSegments);

  return response.trim().replaceAll("\n", " ");
}
