// ignore_for_file: use_build_context_synchronously

import 'package:seekers/constant/constant_builder.dart';
import 'package:seekers/constant/firebase_constant.dart';
import 'package:seekers/factory/game_factory.dart';
import 'package:seekers/view/peer/describe_peer_page.dart';
import 'package:seekers/view/peer/official_game_card.dart';


class GamePeer extends StatefulWidget {
  const GamePeer({super.key});
  @override
  State<GamePeer> createState() => _GamePeerState();
}

class _GamePeerState extends State<GamePeer> {
  TextEditingController textController = TextEditingController();

  String errorText = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 38, right: 38, top: 60),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Find A Game',
                style: styleB30
              ),
              const SizedBox(height: 20),
              Text(
                'Enter game Code that shared by your friends!',
                style: styleSB25
              ),
              const SizedBox(height: 15),
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: appOrange, width: 3)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: appOrange, width: 3)),
                  hintText: 'Type code here...',
                  filled: true,
                  fillColor: whiteGrey,
                ),
              ),
              Text(
                errorText,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.red),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      
                      findGame();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appOrange,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Play!',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ))),
              ),
              const SizedBox(height: 20),
              const SizedBox(
                width: double.infinity,
                child: Text(
                  'OR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: fontColor),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Play Official Games!',
                  textAlign: TextAlign.center,
                  style: styleB25
                ),
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                  stream: getGame
                      .where('createdBy', isEqualTo: 'Carbonara')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Column(children: [
                        skeletonBox(double.infinity, 125),
                        const SizedBox(height: 15),
                        skeletonBox(double.infinity, 125),
                      ]);
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Image(image: AssetImage(inspired)),
                            Text(
                              'No official game',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: fontColor.withOpacity(0.5),
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Column(
                        children: (snapshot.data!).docs.map((e) {
                          List<dynamic> items = e['obj'];
                          List<ItemObject> itemObject = items
                              .map((e) => ItemObject(
                                  image: e['image'],
                                  objName: e['objName'],
                                  description: e['description'],
                                  colaboratorDesc: e['colaboratorDesc']))
                              .toList();
                          Game gameObj = Game(
                              place: e['place'],
                              obj: itemObject,
                              code: e['code'],
                              createdBy: e['createdBy'],
                              playedBy: e['playedBy'],
                              createdTime: e['createdTime'],
                              colaboratorTime: e['colaboratorTime'],
                              isPlayed: e['isPlayed'],
                              colaboratorUid: e['colaboratorUid']);
                          return OfficialGameCard(gameObj, 'Carbonara');
                        }).toList(),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> findGame() async{
    if(textController.text == ""){
      setState(() {
        errorText = "Please enter the game code!";
      });
    }else {
      try {
        DocumentReference docRef =
            db.collection('games').doc(textController.text);
        var docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          final data =
              docSnapshot.data() as Map<String, dynamic>;

          List<dynamic> items = data['obj'];
          List<ItemObject> itemObject = items.map(
            (e) {
              return ItemObject(
                image: e['image'],
                objName: e['objName'],
                description: e['description'],
                colaboratorDesc: e['colaboratorDesc'],
              );
            },
          ).toList();

          Game game = Game(
              code: data['code'],
              place: data['place'],
              createdBy: data['createdBy'],
              createdTime: data['createdTime'],
              colaboratorTime: data['colaboratorTime'],
              playedBy: data['playedBy'],
              isPlayed: data['isPlayed'],
              colaboratorUid: data['colaboratorUid'],
              obj: itemObject);

          if(game.isPlayed == false){
            textController.clear();
            setState(() {
              errorText = "";
            });
            
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DescribePeerPage(game, 0, false)),
            );
          }else{
            setState(() {
              errorText = "Game is already played";
            });
          }
          
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Game does not exists'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error Code: $e'),
              backgroundColor: Colors.red,
            ),
          );
      }
    }
  }
}
