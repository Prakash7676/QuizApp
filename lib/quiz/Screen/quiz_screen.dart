import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/quiz/screen/result_screen.dart';
import '../Services/api_services.dart';
import '../const/colors.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
   late Future quiz;
  var currentIndexOfQuestion = 0;
  int seconds = 60;
  Timer? timer;
  bool isLoading = false;
   var optionsList = [];
  int correctAnswers = 0;
  int incorrectAnswers = 0;

  @override
  void initState() {
    super.initState();
    quiz = getQuiz();
    startTimer();
  }

  var optionsColor = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];

  resetColors() {
    optionsColor = [
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
    ];
  }
  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          gotoNextQuestion();
        }
      });
    });
  }

  gotoNextQuestion() {
    setState((){
       isLoading = false;
    currentIndexOfQuestion++;
    resetColors();
    timer!.cancel();
    seconds = 60;
    startTimer();

    });
   
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
        gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [blue, darkBlue,],
              ),),
              child: FutureBuilder(
      future: quiz,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // for error handling
        if(snapshot.connectionState == ConnectionState.waiting){
         return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          );
        }else if(snapshot.hasError){
            return Center(child: Text("Error:${snapshot.error}", style: const TextStyle(color: Colors.white),),);
        }
        else if (snapshot.hasData) {
          var data = snapshot.data["results"];
      
          if (isLoading == false) {
            optionsList = data[currentIndexOfQuestion]["incorrect_answers"];
            optionsList.add(data[currentIndexOfQuestion]["correct_answer"]);
            optionsList.shuffle();
            isLoading = true;
          }
      
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color:Colors.red, width: 3),
                        ),
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              CupertinoIcons.xmark,
                              color: Colors.red,
                              size: 30,
                            )),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            "$seconds",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(
                            width: 70,
                            height: 70,
                            child: CircularProgressIndicator(
                              value: seconds / 60,
                              valueColor:
                                  const AlwaysStoppedAnimation(Colors.white),
                            ),
                          ),
                        ],
                      ),
                     
                    ],
                  ),
                  const SizedBox(height: 20),
                  Image.asset("ideas.png", width: 200,),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Question ${currentIndexOfQuestion + 1} of ${data.length}",
                      style: const TextStyle(
                        color: lightgrey,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    data[currentIndexOfQuestion]["question"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: optionsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var correctAnswer =
                          data[currentIndexOfQuestion]["correct_answer"];
                  
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (correctAnswer.toString() ==
                                optionsList[index].toString()) {
                              optionsColor[index] = Colors.green;
                              correctAnswers++;
                            } else {
                              optionsColor[index] = Colors.red;
                              incorrectAnswers++;
                            }
                  
                            if (currentIndexOfQuestion < data.length - 1) {
                              Future.delayed(const Duration(milliseconds: 400), () {
                                gotoNextQuestion();
                              });
                            } else {
                              timer!.cancel();
                              //here you can do whatever you want with the results
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ResultScreen(
                                correctAnswers, 
                                incorrectAnswers,
                                currentIndexOfQuestion+1,
                                )));
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          alignment: Alignment.center,
                          width: size.width - 100,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: optionsColor[index],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            optionsList[index].toString(),
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(
          child: Text("No Data Found"),
          );
        }
      },
              ),
            ),
    );
  }
}