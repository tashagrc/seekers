import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:seekers/constant/constant_builder.dart';
import 'package:seekers/tflite/recognition.dart';
import 'package:seekers/tflite/box_widget.dart';

import '../../tflite/camera_view.dart';

/// [HomeView] stacks [CameraView] and [BoxWidget]s with bottom sheet for stats
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  /// Results to draw bounding boxes
  List<Recognition>? results;

  FlutterTts flutterTts = FlutterTts();

  String objText = '';

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          // Camera View
          CameraView(resultsCallback),
          
          // Bounding boxes
          boundingBoxes(results),

          // Bottom Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.maxFinite,
              height: 221,
              decoration: const BoxDecoration(
                  color: Colors.white,),
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        objText,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: fontColor,            
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white, 
                          backgroundColor: appOrange,
                          fixedSize: const Size(100, 100),
                          shape: const CircleBorder(),
                          alignment: Alignment.center,
                        ),
                        onPressed: () => textToSpeech(objText), 
                        icon: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.volume_up_rounded, size: 27,),
                            Text('Speak')
                          ],
                        ), 
                        label: const SizedBox.shrink()
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  //This method will convert the text to spech
  void textToSpeech(String theObject) async{
    await flutterTts.setLanguage("en-US");
    await flutterTts.setVolume(1);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1);
    await flutterTts.speak(theObject);
    await flutterTts.setSilence(250);
  }


  /// Returns Stack of bounding boxes
  Widget boundingBoxes(List<Recognition>? results) {
    if (results == null) {
      return Container();
    }
    return Stack(
      children: results
          .map((e) => BoxWidget(
                result: e,
              ))
          .toList(),
    );
  }

  /// Callback to get inference results from [CameraView]
  void resultsCallback(List<Recognition> results) {
    bool lastChecker = true;
    if(this.results != null && results.isNotEmpty){
      if(this.results!.isNotEmpty){
        if(this.results!.last.label == results.last.label){
          lastChecker = false;
        }
      }
    }
    if(mounted){
      setState(() {
        this.results = results;
        if(lastChecker){
          if(results.isNotEmpty){
            textToSpeech(results.last.label);
            objText = results.last.label;
          }
        }
      });
    }
  }

  static const BOTTOM_SHEET_RADIUS = Radius.circular(24.0);
  static const BORDER_RADIUS_BOTTOM_SHEET = BorderRadius.only(
      topLeft: BOTTOM_SHEET_RADIUS, topRight: BOTTOM_SHEET_RADIUS);
}