import 'package:seekers/constant/constant_builder.dart';

class ReviewFinishPage extends StatelessWidget {
  String uid;
  ReviewFinishPage(this.uid, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Yay, you described it!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30,
                    color: fontColor,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 15,
            ),
            const Image(image: AssetImage(completedTask)),
            const SizedBox(
              height: 15,
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 25),
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appOrange,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Return',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ))),
            ),
          ],
        ),
      ),
    );
  }
}
