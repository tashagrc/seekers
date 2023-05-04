import 'dart:io';

import 'package:seekers/constant/constant_builder.dart';
import 'package:seekers/factory/game_factory.dart';
import 'package:seekers/view/impaired/scan_obj_page.dart';
import 'package:seekers/view/impaired/speechtotext.dart';
import 'package:seekers/view/impaired/success_page.dart';
import 'package:seekers/view/impaired/texttospeech.dart';

class DescribePage extends StatefulWidget {
  String title;
  String image;
  String objName;
  List<ItemObject> objects;
  DescribePage(this.title, this.image, this.objects, this.objName, {super.key});
  
  @override
  // ignore: no_logic_in_create_state
  State<DescribePage> createState() => _DescribePageState(title, image, objects, objName);
}

class _DescribePageState extends State<DescribePage> {

  String title;
  String image;
  List<ItemObject> objects;
  String objName;

  _DescribePageState(
    this.title,
    this.image,
    this.objects,
    this.objName
  );

  bool speechEnabled = false;
  String lastWord = '';
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    _initSpeech();
    super.initState();
  }

  void _initSpeech() async {
    speechEnabled = await speech.initialize();
    setState(() {});
  }

  void _startListening() async {
    await speech.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await speech.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWord = result.recognizedWords;
      textController.text = lastWord;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Transform.rotate(
            angle: 3.14 / 2,
            child: SizedBox(
              height: 392.75,
              child: Image.file(
                File(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            child: DraggableScrollableSheet(
              initialChildSize: 0.65,
              minChildSize: 0.5,
              maxChildSize: 0.68,
              builder:(_, ScrollController scrollController) => 
                Container(
                  width: double.maxFinite,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Touch it!',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: fontColor
                            ),
                          ),
                          const SizedBox(height: 15,),
                          const Text(
                            'What is the texture? Is it soft or hard? and the weight, is it light or heavy? How about the size? Is it big or small? What is the function of the object?',
                            softWrap: true,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 13,
                              color: fontColor
                            )
                          ),
                            
                          const SizedBox(height: 15,),
                          
                          const Text(
                            'Describe it here!\nYou can type or speak!',
                            softWrap: true,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: fontColor
                            )
                          ),
                          const SizedBox(height: 10,),
                          SizedBox(
                            width: double.maxFinite,
                            child: TextButton.icon(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white, 
                                backgroundColor: appOrange,
                                fixedSize: const Size(100, 100),
                                shape: const CircleBorder(),
                                
                              ),
                              onPressed: () => speech.isNotListening ? _startListening() : _stopListening(), 
                              icon: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children:  [
                                  Icon(speech.isNotListening ? Icons.mic_off : Icons.mic, size: 27,),
                                  const Text('Speak')
                                ],
                              ), 
                              label: const SizedBox.shrink()
                            ),
                          ),
                            
                          const SizedBox(height: 15),
                          TextField(
                            maxLength: 300,
                            controller: textController,
                            decoration: const InputDecoration(
                              fillColor: Color(0xffE9E9E9),
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              hintText: 'Enter text here Or talk',
                            ),
                          ),
                            
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: (){
                                if(textController.text.isNotEmpty || textController.text != ''){
                                  String description = textController.text;
                                  ItemObject item = ItemObject(image: image, objName: objName, description: description);
                                  objects.add(item);
                                  if(objects.length < 5){
                                    Navigator.pushReplacement(
                                      context, 
                                      MaterialPageRoute(builder: (context) => ScanObjectPage(title, objects))
                                    );
                                  }else{
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => SuccessPage(title, objects))
                                    );
                                  }
                                }else{
                                  textToSpeech('Please tell me the description of the object first!');
                                }
                              },
                              
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appOrange,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Next!',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                )
                              )
                            ),
                          ),
                        ]
                      ),
                    ),
                  ),
                ),
            )
          ),
        ]
      ),
    );
  }
}