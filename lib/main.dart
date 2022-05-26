import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttermovie/blocs/movie_bloc.dart';
import 'package:fluttermovie/blocs/movie_form_bloc.dart';
import 'package:fluttermovie/screens/splash_screen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc((i) => MovieBloc()),
        Bloc((i) => MovieFormBloc()),
      ],
      child: MaterialApp(
        title: "Movies ",
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'GeosansLight'),
      ),
    );
  }
}
