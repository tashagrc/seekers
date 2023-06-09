import 'package:seekers/constant/constant_builder.dart';
import 'package:seekers/factory/game_factory.dart';
import 'package:seekers/view/peer/describe_peer_page.dart';

class OfficialGameCard extends StatelessWidget {
  Game gameObj;
  String officialUid;
  OfficialGameCard(this.gameObj, this.officialUid, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: appOrange),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            gameObj.place,
            style: const TextStyle(
              color: white,
              fontSize: 20,
            ),
            overflow: TextOverflow.fade,
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DescribePeerPage(gameObj, 0, true)));
          },
          child: Container(
            decoration: const BoxDecoration(
                color: green,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )),
            padding: const EdgeInsets.all(8),
            width: 110,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.play_circle_fill,
                    color: white,
                    size: 40,
                  ),
                  Text('Play',
                      style: TextStyle(
                          color: white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600))
                ]),
          ),
        )
      ]),
    );
  }
}
