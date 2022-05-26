import 'package:flutter/material.dart';
import 'package:fluttermovie/screens/home.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  AnimationController _animationController;
  int cont = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        cont++;
        if (cont < 2) {
          _animationController.reset();
          _animationController.forward();
        }else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context)=> Home())
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(211, 12, 27, 1),
      body: Center(
        child: Lottie.asset("assets/lottie/movie.json", controller: _animationController, onLoaded: (composition) {
          _animationController
          ..duration = composition.duration
            ..forward();
        })
    ));
  }
}
