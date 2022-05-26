import 'package:flutter/material.dart';
import 'package:fluttermovie/screens/movies_to_watch_list.dart';
import 'package:fluttermovie/screens/watched_movies_list.dart';
import 'package:fluttermovie/screens/movie_form.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _currentIndex = 0;

  final List<Widget> _children = [
    MoviesToWatchList(),
    WatchedMoviesList(),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: Text("ftl1"),
        elevation: 5.0,
        icon: Icon(Icons.add),
        label: Text('New Movie', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromRGBO(211, 12, 27, 1),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MovieForm()));
        },
      ),
      bottomNavigationBar:
      BottomAppBar(
        child: Container(
          height: 55,
          margin: EdgeInsets.only(left: 12.0, right: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              IconButton(
                onPressed: () {
                  onTabTapped(0);
                },
                iconSize: 32.0,
                icon: Icon(
                  Icons.update,
                  color: _currentIndex == 0
                      ?  Color.fromRGBO(211, 12, 27, 1)
                      : Colors.grey.shade400,
                ),
              ),
              SizedBox(
                width: 160,
              ),
              IconButton(
                onPressed: () {
                  onTabTapped(1);
                },
                iconSize: 32.0,
                icon: Icon(
                  Icons.check,
                  color: _currentIndex == 1
                      ?  Color.fromRGBO(211, 12, 27, 1)
                      : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
        color: Colors.white,
      )
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
