import 'package:seekers/constant/constant_builder.dart';
import 'package:seekers/factory/game_factory.dart';
import 'package:seekers/view/review_finish_page.dart';
import 'package:seekers/view/impaired/texttospeech.dart';

class ReviewPage extends StatefulWidget {
  int gameCounter;
  Game gameObj;
  String uid;
  int userRoles;
  ReviewPage(this.gameObj, this.gameCounter, this.uid, this.userRoles, {super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState(gameObj, gameCounter, uid, userRoles);
}

class _ReviewPageState extends State<ReviewPage> {
  Game gameObj;
  int gameCounter;
  String uid;
  int userRoles;
  _ReviewPageState(this.gameObj, this.gameCounter, this.uid, this.userRoles);

  @override
  void initState() {
    if(userRoles == 1){
      speakDescription();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appOrange,
        title: Text('Review: ${gameObj.place}, No: #${gameCounter+1}'),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.symmetric(vertical: 20),
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: appOrange,
                ),
                child: Column(
                  children: [
                    Transform.rotate(
                      angle: 3.14 / 2,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        height: 293,
                        child:ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          child: Image.network(
                              gameObj.obj[gameCounter].image,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return skeletonBox(double.infinity, 293);
                                }
                              }
                            ),
                        ),
                      ),
                    ),
                    Text(
                      gameObj.obj[gameCounter].objName,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: white
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: white
                      ),
                      child: 
                        (uid == gameObj.createdBy)
                        ? RichText( text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Your Description:\n',
                              style: TextStyle(
                                fontSize: 15,
                                color: fontColor,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            TextSpan(
                              text: gameObj.obj[gameCounter].description,
                              style: const TextStyle(
                                fontSize: 15,
                                color: fontColor
                              )
                            )
                          ]
                        ))
                        : RichText( text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Your Description:\n',
                              style: TextStyle(
                                fontSize: 15,
                                color: fontColor,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            TextSpan(
                              text: gameObj.obj[gameCounter].colaboratorDesc,
                              style: const TextStyle(
                                fontSize: 15,
                                color: fontColor
                              )
                            )
                          ]
                        ))
                    ),

                    const SizedBox(height: 10),

                    (gameObj.obj[gameCounter].colaboratorDesc == '-')
                    ? const SizedBox()
                    : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white
                      ),
                      child: 
                        (uid == gameObj.createdBy)
                        ? RichText( text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Friend Description:\n',
                              style: styleB15
                            ),
                            TextSpan(
                              text: gameObj.obj[gameCounter].colaboratorDesc,
                              style:styleR15
                            )
                          ]
                        ))
                        : RichText( text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Friend Description:\n',
                              style: styleB15
                            ),
                            TextSpan(
                              text: gameObj.obj[gameCounter].description,
                              style: styleR15
                            )
                          ]
                        ))
                    ),

                    const SizedBox(height: 15),
                    (userRoles == 1)
                    ? Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white, 
                          backgroundColor: Colors.white,
                          fixedSize: const Size(100, 100),
                          shape: const CircleBorder(),
                          alignment: Alignment.center,
                        ),
                        onPressed: () => speakDescription(), 
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.volume_up_rounded, size: 37, color: appOrange,),
                            Text('Hear', style: TextStyle(color: appOrange, fontSize: 18),)
                          ],
                        ),
                      )
                    )
                    : const SizedBox(height: 15),
                  ],
                ),
              ),

               SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (){
                    if(gameCounter < 4){
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => ReviewPage(gameObj, gameCounter+1, uid, userRoles))
                      );
                    }else{
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(builder: (context) => ReviewFinishPage(uid))
                      );
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
                    'Next',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    )
                  )
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void speakDescription(){
    if(uid == gameObj.createdBy){
      (gameObj.obj[gameCounter].colaboratorDesc == '-')
      ? textToSpeech('This is ${gameObj.obj[gameCounter].objName}. Your description of ${gameObj.obj[gameCounter].objName}is:${gameObj.obj[gameCounter].description}')
      : textToSpeech('This is ${gameObj.obj[gameCounter].objName}. Your description of ${gameObj.obj[gameCounter].objName}is:${gameObj.obj[gameCounter].description}. And your friend description is: ${gameObj.obj[gameCounter].colaboratorDesc}.');
    }
  }

}