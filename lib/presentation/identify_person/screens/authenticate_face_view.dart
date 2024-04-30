import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:seek_reunite/constants/constant_size.dart';
import 'package:seek_reunite/presentation/complaint/screens/match_found_screen.dart';
import 'package:seek_reunite/presentation/identify_person/scanning_animation/animated_view.dart';
// import 'package:face_auth/authenticate_face/user_details_view.dart';
// import 'package:face_auth/common/utils/custom_snackbar.dart';
import 'package:seek_reunite/utils/extract_face_feature.dart';
import 'package:seek_reunite/utils/camera_view.dart';
// import 'package:face_auth/common/views/custom_button.dart';
import 'package:seek_reunite/constants/theme.dart';
import 'package:seek_reunite/models/user_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_face_api/face_api.dart' as regula;
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../../../widgets/custom_button.dart';

class AuthenticateFaceView extends StatefulWidget {
  const AuthenticateFaceView({Key? key}) : super(key: key);

  @override
  State<AuthenticateFaceView> createState() => _AuthenticateFaceViewState();
}

class _AuthenticateFaceViewState extends State<AuthenticateFaceView> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );
  FaceFeatures? _faceFeatures;
  var image1 = regula.MatchFacesImage();
  var image2 = regula.MatchFacesImage();

  final TextEditingController _nameController = TextEditingController();
  String _similarity = "";
  bool _canAuthenticate = true;
  List<dynamic> users = [];
  bool userExists = false;
  UserModel? loggingUser;
  bool isMatching = false;
  int trialNumber = 1;

  @override
  void dispose() {
    _faceDetector.close();
    _audioPlayer.dispose();
    super.dispose();
  }

  get _playScanningAudio => _audioPlayer
    ..setReleaseMode(ReleaseMode.loop)
    ..play(AssetSource("scan_beep.wav"));

  get _playFailedAudio => _audioPlayer
    ..stop()
    ..setReleaseMode(ReleaseMode.release)
    ..play(AssetSource("failed.mp3"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarColor,
        title: const Text("Authenticate Face"),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            // width: constrains.maxWidth,
            // height: constrains.maxHeight,
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: const BoxDecoration(
              color: Color(0xFFF3F6FD)
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height:double.maxFinite,
                    width: double.infinity,
                    padding:
                    const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: overlayContainerClr,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CameraView(
                              onImage: (image) {
                                _setImage(image);
                              },
                              onInputImage: (inputImage) async {
                                setState(() => isMatching = true);
                                _faceFeatures = await extractFaceFeatures(
                                    inputImage, _faceDetector);
                                setState(() => isMatching = false);
                              },
                            ),
                            if (isMatching)
                              const Positioned(
                                left: 0,
                                top: 0,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: AnimatedView(),
                                ),
                              ),
                          ],
                        ),
                        // const Spacer(),
                        // if (_canAuthenticate)
                          SizeConstant.getHeightSpace(40),
                          CustomButton(
                            text: "Authenticate",
                            onTap: () {
                              setState(() => isMatching = true);
                              _playScanningAudio;
                              _fetchUsersAndMatchFace();
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future _setImage(Uint8List imageToAuthenticate) async {
    image2.bitmap = base64Encode(imageToAuthenticate);
    image2.imageType = regula.ImageType.PRINTED;

    setState(() {
      _canAuthenticate = true;
    });
  }

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

  _fetchUsersAndMatchFace() {
    FirebaseFirestore.instance.collection("faces").get().catchError((e) {
      log("Getting User Error: $e");
      setState(() => isMatching = false);
      _playFailedAudio;
      // CustomSnackBar.errorSnackBar("Something went wrong. Please try again.");
    }).then((snap) {
      if (snap.docs.isNotEmpty) {
        users.clear();
        log(snap.docs.length.toString(), name: "Total Registered Users");
        for (var doc in snap.docs) {
          UserModel user = UserModel.fromJson(doc.data());
          double similarity = compareFaces(_faceFeatures!, user.faceFeatures!);
          if (similarity >= 0.6 && similarity <= 1.5) {
            users.add([user, similarity]);
          }
        }
        log(users.length.toString(), name: "Filtered Users");
        setState(() {
          //Sorts the users based on the similarity.
          //More similar face is put first.
          users.sort((a, b) => (((a.last as double) - 1).abs())
              .compareTo(((b.last as double) - 1).abs()));
        });

        _matchFaces();
      } else {
        // _showFailureDialog(
        //   title: "No Users Registered",
        //   description:
        //       "Make sure users are registered first before Authenticating.",
        // );
        Get.snackbar(
          "Face Didn't matched",
          "Trying Again",
          colorText: Colors.white,
          backgroundColor: Colors.lightBlue,
          icon: const Icon(Icons.add_alert),
        );
      }
    });
  }

  _matchFaces() async {
    bool faceMatched = false;
    String refId = "";

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
      setState(() {
        _similarity = split!.matchedFaces.isNotEmpty
            ? (split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2)
            : "error";
        log("similarity: $_similarity");

        if (_similarity != "error" && double.parse(_similarity) > 90.00) {
          faceMatched = true;
          loggingUser = user.first;
          log(loggingUser!.registeredOn.toString() ?? "", name: "MATCH!!!!!");
          setState(() {
            refId = loggingUser!.registeredOn.toString();
          });

        } else {
          faceMatched = false;
          log("FACE DIDN't MATCHED!",name: "result");
          Get.snackbar(
            "Face Didn't matched",
            "Trying Again",
            colorText: Colors.white,
            backgroundColor: Colors.lightBlue,
            icon: const Icon(Icons.add_alert),
          );
        }
      });
      if (faceMatched) {
        _audioPlayer
          ..stop()
          ..setReleaseMode(ReleaseMode.release)
          ..play(AssetSource("success.mp3"));

        setState(() {
          trialNumber = 1;
          isMatching = false;
        });

        if (mounted) {
          log(refId, name: "ID");
          await FirebaseFirestore.instance.collection("complaints").doc(refId).get().catchError((e){}).then((DocumentSnapshot snap) {
              if (snap.exists) {
                Map<String, dynamic>? data = snap.data() as Map<String, dynamic>?;
                log(data.toString(), name:"DATA");
                Get.to(MatchFoundScreen(data: data));
              } else {
                log("Document does not exist", name: "DATA");
              }
          });
        }
        break;
      }
    }
    if (!faceMatched) {
      if (trialNumber == 4) {
        setState(() => trialNumber = 1);
        _showFailureDialog(
          title: "Redeem Failed",
          description: "Face doesn't match. Please try again.",
        );
      } else if (trialNumber == 3) {
        //After 2 trials if the face doesn't match automatically, the registered name prompt
        //will be shown. After entering the name the face registered with the entered name will
        //be fetched and will try to match it with the to be authenticated face.
        //If the faces match, Viola!. Else it means the user is not registered yet.
        _audioPlayer.stop();
        setState(() {
          isMatching = false;
          trialNumber++;
        });
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
        //                 // CustomSnackBar.errorSnackBar("Enter a name to proceed");
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
      } else {
        setState(() => trialNumber++);
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
      setState(() => isMatching = false);
      _playFailedAudio;
      // CustomSnackBar.errorSnackBar("Something went wrong. Please try again.");
    }).then((snap) {
      if (snap.docs.isNotEmpty) {
        users.clear();

        for (var doc in snap.docs) {
          setState(() {
            users.add([UserModel.fromJson(doc.data()), 1]);
          });
        }
        _matchFaces();
      } else {
        setState(() => trialNumber = 1);
      }
    });
  }

  _showFailureDialog({
    required String title,
    required String description,
  }) {
    _playFailedAudio;
    setState(() => isMatching = false);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Ok",
                style: TextStyle(
                  color: accentColor,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
