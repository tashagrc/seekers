
import 'package:seekers/constant/constant_builder.dart';
import 'package:seekers/constant/firebase_constant.dart';
import 'package:seekers/factory/game_factory.dart';
import 'package:seekers/factory/user_factory.dart';
import 'package:seekers/view/peer/success_peer_page.dart';
import 'package:seekers/view/repository/firestore_repository.dart';

class DescribePeerPage extends StatefulWidget {
  Game game;
  int objectCount;
  bool isOfficial;
  DescribePeerPage(this.game, this.objectCount, this.isOfficial, {super.key});

  @override
  // ignore: no_logic_in_create_state
  State<DescribePeerPage> createState() =>
      _DescribePageState(game, objectCount, isOfficial);
}

class _DescribePageState extends State<DescribePeerPage> {
  Game game;
  int objectCount;
  bool isOfficial;
  UserSeekers? user;
  final _formKey = GlobalKey<FormState>();

  _DescribePageState(this.game, this.objectCount, this.isOfficial);

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: appOrange.withOpacity(0.7),
            shape: BoxShape.circle
          ),
          child: IconButton(
            onPressed: (() => Navigator.pop(context)), 
            icon: const Icon(Icons.arrow_back),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            splashRadius: 24,
            color: white,
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            iconSize: 24,
            enableFeedback: true,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: _formKey,
        child: Stack(children: [
          Transform.rotate(
            angle: isOfficial ? 0 : 3.14 / 2,
            child: SizedBox(
                height: 392.75,
                child: Image.network(game.obj[objectCount].image,
                    fit: BoxFit.cover,
                    key: ValueKey(DateTime.now().millisecondsSinceEpoch),
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return skeletonBox(double.infinity, 293);
                  }
                })),
          ),
          Align(
              child: DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.5,
            maxChildSize: 0.65,
            builder: (_, ScrollController scrollController) => Container(
              width: double.maxFinite,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 38, vertical: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Describe ${game.obj[objectCount].objName}!',
                          style: styleB30
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'What is the color? Shape? Material? Where this object usually belong? Tell me fun fact about this object.',
                          softWrap: true,
                          textAlign: TextAlign.left,
                          style: styleR15
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          maxLength: 200,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          controller: textController,
                          decoration: const InputDecoration(
                            fillColor: Color(0xffE9E9E9),
                            filled: true,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            hintText: 'Type here...',
                          ),
                          validator: (value) {
                            if(value == null || value.isEmpty){
                              return "Please describe the object first!";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                if(_formKey.currentState!.validate()){
                                  String description = textController.text;
                                  game.obj[objectCount].colaboratorDesc =
                                      description;
                                  if (objectCount < 4) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                // ke page selanjutnya
                                                DescribePeerPage(
                                                    game,
                                                    objectCount + 1,
                                                    isOfficial)));
                                  
                                  } else {
                                    if(!isOfficial){
                                      game.isPlayed = true;
                                      game.colaboratorUid = user!.uid;
                                      game.playedBy = user!.name;
                                      game.colaboratorTime = Timestamp.now();
                                      saveToFirestore(game);
                                    }
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SuccessPeerPage(
                                                game) // loading page
                                            ));
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appOrange,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Next!',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ))),
                        ),
                      ]),
                ),
              ),
            ),
          )),
        ]),
      ),
    );
  }

  Future<void> _getUserData() async {
    UserSeekers user = await getUserData();
    setState(() {
      this.user = user;
    });
  }
}
