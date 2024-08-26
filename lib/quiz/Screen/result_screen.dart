import 'package:flutter/material.dart';
import 'package:quizapp/quiz/const/colors.dart';
import 'package:quizapp/quiz/screen/splash_screen.dart';

class ResultScreen extends StatelessWidget {
  final int correctAnswer;
  final int incorrectAnswer;
  final int totalQuestion;
  const ResultScreen(this.correctAnswer, this.incorrectAnswer, this.totalQuestion, {super.key});

  @override
  Widget build(BuildContext context) {
    double correctPercentage = (correctAnswer/totalQuestion*100);
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
                child: Center(child: Column

                (
                   mainAxisAlignment: MainAxisAlignment.center,
                  children: [const Text("Congratulation You Got", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white,),),
                Text("${correctPercentage.toStringAsFixed(1)}%", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white,),),
      
                Text("Correct Answer: $correctAnswer", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green,),),
                  Text("Incorrect Answer: $incorrectAnswer", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red,),),
                  SizedBox(height: 20,),
                  ElevatedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>QuizSplashScreen()));
                  }, child: Text("Back To Home"))
                ],),),
      ),
    );
  }
}