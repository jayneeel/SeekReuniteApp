
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter_face_api/face_api.dart' as regula;
import 'dart:math' as math;

import '../../../models/user_model.dart';

class AuthenticateController extends GetxController{
  final FaceDetector faceDetector = FaceDetector(
  options: FaceDetectorOptions(
  enableLandmarks: true,
  performanceMode: FaceDetectorMode.accurate,
  ),
  );
  FaceFeatures? faceFeatures;
  var image1 = regula.MatchFacesImage();
  var image2 = regula.MatchFacesImage();
  RxString _similarity = "".obs;
  RxBool _canAuthenticate = false.obs;
  List<dynamic> users = [].obs;
  RxBool userExists = false.obs;
  UserModel? loggingUser;
  RxBool isMatching = true.obs;
  RxInt trialNumber = 1.obs;

  double compareFaces(FaceFeatures face1, FaceFeatures face2) {
    double distEar1 = euclideanDistance(face1.rightEar!, face1.leftEar!);
    double distEar2 = euclideanDistance(face2.rightEar!, face2.leftEar!);

    double ratioEar = distEar1 / distEar2;

    double distEye1 = euclideanDistance(face1.rightEye!, face1.leftEye!);
    double distEye2 = euclideanDistance(face2.rightEye!, face2.leftEye!);

    double ratioEye = distEye1 / distEye2;

    double distCheek1 = euclideanDistance(face1.rightCheek!, face1.leftCheek!);
    double distCheek2 = euclideanDistance(face2.rightCheek!, face2.leftCheek!);

    double ratioCheek = distCheek1 / distCheek2;

    double distMouth1 = euclideanDistance(face1.rightMouth!, face1.leftMouth!);
    double distMouth2 = euclideanDistance(face2.rightMouth!, face2.leftMouth!);

    double ratioMouth = distMouth1 / distMouth2;

    double distNoseToMouth1 =
    euclideanDistance(face1.noseBase!, face1.bottomMouth!);
    double distNoseToMouth2 =
    euclideanDistance(face2.noseBase!, face2.bottomMouth!);

    double ratioNoseToMouth = distNoseToMouth1 / distNoseToMouth2;

    double ratio =
        (ratioEye + ratioEar + ratioCheek + ratioMouth + ratioNoseToMouth) / 5;
    log(ratio.toString(), name: "Ratio");

    return ratio;
  }

// A function to calculate the Euclidean distance between two points
  double euclideanDistance(Points p1, Points p2) {
    final sqr =
    math.sqrt(math.pow((p1.x! - p2.x!), 2) + math.pow((p1.y! - p2.y!), 2));
    return sqr;
  }

  fetchUsersAndMatchFace() {
    FirebaseFirestore.instance.collection("faces").get().catchError((e) {
      log("Getting User Error: $e");
    }).then((snap) {
      if (snap.docs.isNotEmpty) {
        users.clear();
        log(snap.docs.length.toString(), name: "Total Registered Users");
        for (var doc in snap.docs) {
          UserModel user = UserModel.fromJson(doc.data());
          double similarity = compareFaces(faceFeatures!, user.faceFeatures!);
          log(similarity.toString(), name: "SIMILARITY");
          if (similarity >= 0.8 && similarity <= 1.5) {
            users.add([user, similarity]);
            log(users.toString(),name: "USERS");
          }
        }
        log(users.length.toString(), name: "Filtered Users");
        //   //Sorts the users based on the similarity.
        //   //More similar face is put first.
          users.sort((a, b) => (((a.last as double) - 1).abs())
              .compareTo(((b.last as double) - 1).abs()));
        _matchFaces();
      } else {
          log("No Users Registered", name: "FAILURE");
      }
    });
  }

  _matchFaces() async {
    RxBool faceMatched = false.obs;
    for (List user in users) {
      image1.bitmap = (user.first as UserModel).image;
      image1.imageType = regula.ImageType.PRINTED;

      //Face comparing logic.
      var request = regula.MatchFacesRequest();
      request.images = [image1, image2];
      dynamic value = await regula.FaceSDK.matchFaces(jsonEncode(request));

      var response = regula.MatchFacesResponse.fromJson(json.decode(value));
      dynamic str = await regula.FaceSDK.matchFacesSimilarityThresholdSplit(
          jsonEncode(response!.results), 0.75);

      var split =
      regula.MatchFacesSimilarityThresholdSplit.fromJson(json.decode(str));
      // setState(() {
        _similarity.value = split!.matchedFaces.isNotEmpty
            ? (split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2)
            : "error";
        log("similarity: ${_similarity.value}");

        if (_similarity.value != "error" && double.parse(_similarity.value) > 90.00) {
          faceMatched.value = true;
          loggingUser = user.first;
        } else {
          faceMatched.value = false;
        }
      // });
      if (faceMatched.value) {
          trialNumber.value = 1;
          isMatching.value = false;
          log("FACE MATCHED!!!!!!!");
        break;
      }
    }
    if (!faceMatched.value) {
      if (trialNumber.value == 4) {
        trialNumber.value = 1;
      } else if (trialNumber.value == 3) {
        //After 2 trials if the face doesn't match automatically, the registered name prompt
        //will be shown. After entering the name the face registered with the entered name will
        //be fetched and will try to match it with the to be authenticated face.
        //If the faces match, Viola!. Else it means the user is not registered yet.
          isMatching.value = false;
          trialNumber.value = trialNumber.value + 1;
        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       return AlertDialog(
        //         title: const Text("Enter Name"),
        //         content: TextFormField(
        //           controller: _nameController,
        //           cursorColor: accentColor,
        //           decoration: InputDecoration(
        //             enabledBorder: OutlineInputBorder(
        //               borderSide: const BorderSide(
        //                 width: 2,
        //                 color: accentColor,
        //               ),
        //               borderRadius: BorderRadius.circular(4),
        //             ),
        //             focusedBorder: OutlineInputBorder(
        //               borderSide: const BorderSide(
        //                 width: 2,
        //                 color: accentColor,
        //               ),
        //               borderRadius: BorderRadius.circular(4),
        //             ),
        //           ),
        //         ),
        //         actions: [
        //           TextButton(
        //             onPressed: () {
        //               if (_nameController.text.trim().isEmpty) {
        //                 CustomSnackBar.errorSnackBar("Enter a name to proceed");
        //               } else {
        //                 Navigator.of(context).pop();
        //                 setState(() => isMatching = true);
        //                 _playScanningAudio;
        //                 _fetchUserByName(_nameController.text.trim());
        //               }
        //             },
        //             child: const Text(
        //               "Done",
        //               style: TextStyle(
        //                 color: accentColor,
        //               ),
        //             ),
        //           )
        //         ],
        //       );
        //     });
        log("***********************MATCH");
      } else {
        trialNumber.value++;
      }
    }
  }

  _fetchUserByName(String orgID) {
    FirebaseFirestore.instance
        .collection("faces")
        .where("organizationId", isEqualTo: orgID)
        .get()
        .catchError((e) {
      log("Getting User Error: $e");
      isMatching.value = false;
          }).then((snap) {
      if (snap.docs.isNotEmpty) {
        users.clear();

        for (var doc in snap.docs) {
            users.add([UserModel.fromJson(doc.data()), 1]);
        }
        _matchFaces();
      } else {
        trialNumber.value = 1;
      }
    });
  }
}