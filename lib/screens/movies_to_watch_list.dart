import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fluttermovie/blocs/movie_bloc.dart';
import 'package:fluttermovie/models/movie.dart';
import 'package:fluttermovie/screens/movie_form.dart';

class MoviesToWatchList extends StatelessWidget {
  final MovieBloc movieBloc = BlocProvider.getBloc<MovieBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Column(children: [
          Text('Movies',
              style: TextStyle(fontFamily: 'Amstrike', fontSize: 22)),
          Text('Pending Movies',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
        ]),
        backgroundColor: Color.fromRGBO(211, 12, 27, 1),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: movieBloc.movies,
        builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                if (snapshot.data[index].status != true) {
                  return _movieCard(context, index, snapshot.data);
                } else {
                  return Container();
                }
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _movieCard(BuildContext context, int index, List<Movie> movies) {
    return GestureDetector(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Ink.image(
                        image: movies[index].img != null
                            ? FileImage(File(movies[index].img))
                            : AssetImage("assets/images/movie2.png"),
                        height: 190,
                        fit: BoxFit.fitWidth),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        movies[index].name ?? "",
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(movies[index].author ?? "",
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1)),
                          Text(movies[index].year ?? "",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                  letterSpacing: 1.2)),
                        ],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(Icons.update,
                                color: Color.fromRGBO(211, 12, 27, 1)),
                          ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index, movies);
        //_showContactPage(contact: contacts[index]);
      },
    );
  }

  void _showOptions(BuildContext context, int index, List<Movie> movies) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, color: Color.fromRGBO(211, 12, 27, 1)),
                        SizedBox(width: 10),
                        Text(
                          'To edit',
                          style: TextStyle(fontSize: 17, letterSpacing: 2),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MovieForm(movie: movies[index])));
                    },
                    onLongPress: null,
                  ),
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Color.fromRGBO(211, 12, 27, 1),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Delete',
                          style: TextStyle(fontSize: 17, letterSpacing: 2),
                        )
                      ],
                    ),
                    onTap: () {
                      movieBloc.deleteMovieById(movies[index].id);
                      Navigator.pop(context);
                    },
                    onLongPress: null,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
