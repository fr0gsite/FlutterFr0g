
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/widgets/ageverification/quizcard.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}


class _QuizState extends State<Quiz> {

  Future<Uint8List> loadAssetAsUint8List(String path) async {
  final byteData = await rootBundle.load(path);
  return byteData.buffer.asUint8List();
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: 600,
          height: 800,
          child: Material(
              color: AppColor.nicegrey,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  side: BorderSide(
                    color: Colors.white,
                    width: 6,
                  )),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                body: Scaffold(
                  body: Stack(
                    children: [
                      Image.asset(
                      'assets/images/ageverification/quiz1.gif',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      ),
                      Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FutureBuilder(future: loadAssetAsUint8List('assets/images/ageverification/vhs.png'), builder: 
                          (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return QuizCard(
                                question: "Was ist das?",
                                answers: const [
                                  "VHS Kasette",
                                  "CD",
                                  "Floppy Disk",
                                  "USB Stick"],
                                imageData: snapshot.data as Uint8List,
                                onAnswerSelected: (index) {
                                  // Handle answer selection
                                  debugPrint("Selected answer: $index");
                                },
                              );
                            } else {
                              return const Center(child: CircularProgressIndicator(color:Colors.white));
                            }
                          },
                        ),
                      ),
                      ),
                  
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
