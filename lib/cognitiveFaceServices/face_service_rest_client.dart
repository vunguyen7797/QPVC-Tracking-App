import 'dart:io';

import 'package:qpv_client_app/cognitiveFaceServices/rest/web_service_request.dart';

import 'common/request_method.dart';
import 'contract/add_persisted_face_result.dart';
import 'contract/face.dart';
import 'contract/person.dart';
import 'face_service_client.dart';

const String DEFAULT_API_ROOT =
    "https://westus.api.cognitive.microsoft.com/face/v1.0";
const String DETECT_QUERY = "detect";
const String TRAIN_QUERY = "train";
const String LARGE_PERSON_GROUPS_QUERY = "largepersongroups";
const String PERSONS_QUERY = "persons";
const String PERSISTED_FACES_QUERY = "persistedfaces";
const String GROUP_QUERY = "group";
const String STREAM_DATA = "application/octet-stream";
const String DATA = "data";

class FaceServiceClient {
  WebServiceRequest mRestCall;
  String serviceHost;

  FaceServiceClient(String subscriptionKey,
      {this.serviceHost = DEFAULT_API_ROOT}) {
    mRestCall = WebServiceRequest(subscriptionKey);
  }

  Future<List<Face>> detect({
    String url,
    File image,
    bool returnFaceId = true,
    bool returnFaceLandmarks = false,
    bool returnRecognitionModel = false,
    String recognitionModel = "recognition_03",
    String detectionModel = "detection_02",
    List<FaceAttributeType> returnFaceAttributes,
  }) async {
    assert(url != null || image != null);

    print("Detecting face...");

    Map<String, dynamic> params = {
      "returnFaceId": returnFaceId,
      "recognitionModel": recognitionModel,
      "returnRecognitionModel": returnRecognitionModel,
      "detectionModel": detectionModel
    };

    String path = '$serviceHost/$DETECT_QUERY';
    String uri = WebServiceRequest.getUrl(path, params);
    print(uri);

    List<dynamic> json;

    if (url != null && image == null) {
      json = await mRestCall.request(
        uri,
        method: RequestMethod.POST,
        data: {'url': url},
      );
    } else if (image != null) {
      json = await mRestCall.request(
        uri,
        method: RequestMethod.POST,
        contentType: STREAM_DATA,
        data: {
          'data': image.readAsBytesSync(),
        },
      );
    }

    List<Face> faces = json
        .map((data) => Face.fromJson((data as Map<String, dynamic>)))
        .toList();

    return faces;
  }

  Future<Person> createPersonInLargePersonGroup(
      {String largePersonGroupId, String customerName, String userUID}) async {
    assert(largePersonGroupId != null);

    String uri =
        '$serviceHost/$LARGE_PERSON_GROUPS_QUERY/$largePersonGroupId/persons';

    Map<String, Object> params = {};

    if (largePersonGroupId != null) {
      params["name"] = customerName;
      params["userData"] = userUID;
    }

    var json = await mRestCall.request(
      uri,
      method: RequestMethod.POST,
      data: params,
    );
    return Person.fromJson(json as Map<String, dynamic>);
  }

  Future<AddPersistedFaceResult> addPersonFaceInLargePersonGroup(
      {String largePersonGroupId,
      String personId,
      String detectionModel,
      File imageFile}) async {
    assert(largePersonGroupId != null && personId != null && imageFile != null);

    String path =
        '$serviceHost/$LARGE_PERSON_GROUPS_QUERY/$largePersonGroupId/persons/$personId/persistedfaces';

    Map<String, dynamic> paramsUrl = {
      "detectionModel": detectionModel,
      "userData": "",
      "targetFace": ""
    };
    String uri = WebServiceRequest.getUrl(path, paramsUrl);
    var json = await mRestCall.request(
      uri,
      contentType: STREAM_DATA,
      method: RequestMethod.POST,
      data: {
        'data': imageFile.readAsBytesSync(),
      },
    );

    print(json);
    return json != null
        ? AddPersistedFaceResult.fromJson(json as Map<String, dynamic>)
        : AddPersistedFaceResult("");
  }

  Future<void> trainLargePersonGroup({String largePersonGroupId}) async {
    assert(largePersonGroupId != null);

    String uri =
        '$serviceHost/$LARGE_PERSON_GROUPS_QUERY/$largePersonGroupId/$TRAIN_QUERY';

    await mRestCall.request(
      uri,
      method: RequestMethod.POST,
      data: null,
    );
  }
}
