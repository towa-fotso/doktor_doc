import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:gcloud/storage.dart';
import 'package:mime/mime.dart';
import 'package:googleapis/documentai/v1.dart';
import 'dart:io';

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
String jsonCredentials = "";

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

List<GoogleCloudDocumentaiV1GcsDocument> onlinedoclicks = [];
String? singleDocUri = "";

Future<GoogleCloudDocumentaiV1ProcessResponse> treatSingledocument(
    Uint8List imgByte, String name) async {
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
    mimeType: lookupMimeType(name),
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
  print(response.document?.text);

  return response;
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

  outputConfig = GoogleCloudDocumentaiV1DocumentOutputConfigGcsOutputConfig(
      gcsUri: "gs://.$bucketname");

  GoogleCloudDocumentaiV1DocumentOutputConfig batchoutputconf;

  batchoutputconf = GoogleCloudDocumentaiV1DocumentOutputConfig(
      gcsOutputConfig: outputConfig);

  GoogleLongrunningOperation batchOp;
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
  batchOp = await docApi.projects.locations.processors
      .batchProcess(batchproccessReq, processorpath);

  return batchOp;
}
