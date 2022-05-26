import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttermovie/blocs/movie_bloc.dart';
import 'package:fluttermovie/blocs/movie_form_bloc.dart';
import 'package:image_picker/image_picker.dart';

class MovieForm extends StatelessWidget {
  final MovieFormBloc movieFormBloc = MovieFormBloc();
  final MovieBloc movieBloc = BlocProvider.getBloc<MovieBloc>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  MovieForm({movie}) {
    if (movie != null) {
      movieFormBloc.setFormData(movie);
    }
  }
  _getImgFromCamera() {
    ImagePicker.pickImage(source: ImageSource.camera).then((file) {
      // usuario fechou a camera
      if (file == null) return;
      movieFormBloc.changeMovieImage(file.path);
    });
  }

  _getImgFromGallery() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
      if (file == null) return;
      movieFormBloc.changeMovieImage(file.path);
    });
  }

  void _showPicker(context) {
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
                          Icon(Icons.photo_library,
                              color: Color.fromRGBO(211, 12, 27, 1)),
                          SizedBox(width: 10),
                          Text('Gallery',
                              style: TextStyle(fontSize: 17, letterSpacing: 2))
                        ]),
                    onTap: () {
                      _getImgFromGallery();
                      Navigator.of(context).pop();
                    },
                    onLongPress: null,
                  ),
                  ListTile(
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo_camera,
                              color: Color.fromRGBO(211, 12, 27, 1)),
                          SizedBox(width: 10),
                          Text('Camera',
                              style: TextStyle(fontSize: 17, letterSpacing: 2))
                        ]),
                    onTap: () {
                      _getImgFromCamera();
                      Navigator.of(context).pop();
                    },
                    onLongPress: null,
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> requestPop(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Discard Changes ?",
            style: TextStyle(fontSize: 22),
          ),
          content: Text("If you exit the changes will be lost. ",
              style: TextStyle(fontSize: 19)),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Cancel",
                  style: TextStyle(
                      fontSize: 18,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(211, 12, 27, 1))),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text(
                "Yes",
                style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(211, 12, 27, 1),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => requestPop(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(211, 12, 27, 1),
          toolbarHeight: 90,
          title: StreamBuilder(
              stream: movieFormBloc.movieName,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data);
                } else {
                  return Text("New Movie");
                }
              }),
          centerTitle: true,
        ),
        floatingActionButton: StreamBuilder(
          stream: movieFormBloc.movieIsValid,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              return FloatingActionButton(
                heroTag: Text("ftl2"),
                onPressed: () {
                  if (movieFormBloc.buildMovieFromFormData().id == null) {
                    movieBloc.addMovie(movieFormBloc.buildMovieFromFormData());
                  } else {
                    movieBloc
                        .updateMovie(movieFormBloc.buildMovieFromFormData());
                  }
                  Navigator.pop(context);
                },
                child: Icon(Icons.save),
                backgroundColor: Color.fromRGBO(211, 12, 27, 1),
              );
            } else {
              return Container();
            }
          },
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Column(
            children: [
              GestureDetector(
                child: StreamBuilder(
                    stream: movieFormBloc.movieImage,
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return Container(
                        padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: snapshot.data != null
                                  ? FileImage(File(snapshot.data))
                                  : AssetImage("assets/images/moviecover.png"),
                              fit: BoxFit.cover),
                        ),
                      );
                    }),
                onTap: () {
                  _showPicker(context);
                },
              ),
              StreamBuilder<String>(
                  stream: movieFormBloc.movieName,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (nameController.text != snapshot.data) {
                      nameController.text = snapshot.data;
                    }
                    return Padding(
                      padding: EdgeInsets.all(20),
                      child: TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 25, right: 25),
                          fillColor: Color.fromRGBO(211, 12, 27, 1),
                          labelText: "Name",
                          labelStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          errorText: snapshot.error,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        controller: nameController,
                        onChanged: movieFormBloc.changeMovieName,
                      ),
                    );
                  }),
              StreamBuilder(
                  stream: movieFormBloc.movieAuthor,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (authorController.text != snapshot.data) {
                      authorController.text = snapshot.data;
                    }
                    return Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 25, right: 25),
                          fillColor: Color.fromRGBO(211, 12, 27, 1),
                          labelText: "Author",
                          labelStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          errorText: snapshot.error,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        controller: authorController,
                        onChanged: movieFormBloc.changeMovieAuthor,
                      ),
                    );
                  }),
              StreamBuilder(
                  stream: movieFormBloc.movieYear,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (yearController.text != snapshot.data) {
                      yearController.text = snapshot.data;
                    }
                    return Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: TextFormField(
                        controller: yearController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 25, right: 25),
                          fillColor: Color.fromRGBO(211, 12, 27, 1),
                          labelText: "Yes",
                          labelStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          errorText: snapshot.error,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        onChanged: movieFormBloc.changeMovieYear,
                        keyboardType: TextInputType.number,
                      ),
                    );
                  }),
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.error, color: Color.fromRGBO(211, 12, 27, 1)),
                    SizedBox(width: 10),
                    Text(
                      'All fields need to be filled',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
              StreamBuilder(
                stream: movieFormBloc.movieStatus,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Card(
                      child: CheckboxListTile(
                        activeColor: Color.fromRGBO(211, 12, 27, 1),
                        value: snapshot.hasData && snapshot.data ? true : false,
                        title: Text("Have you ever seen this movie ?"),
                        subtitle:
                            Text("confirm by checking the box on the side"),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: movieFormBloc.changeMovieStatus,
                        //  <-- leading Checkbox
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
