import 'dart:async';
import 'package:fluttermovie/models/movie.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class MovieFormBloc implements BlocBase {

  final _movieNameController = BehaviorSubject<String>();
  final _movieImageController = BehaviorSubject<String>();
  final _movieAuthorController = BehaviorSubject<String>();
  final _movieYearController = BehaviorSubject<String>();
  final _movieStatusController = BehaviorSubject<bool>();
  final _movieIdController = BehaviorSubject<int>();
  // Get
  Stream<String> get movieName =>
      _movieNameController.stream.transform(validateMovieName);

  Stream<String> get movieImage => _movieImageController.stream;

  Stream<String> get movieAuthor =>
      _movieAuthorController.stream.transform(validateMovieAuthor);

  Stream<String> get movieYear =>
      _movieYearController.stream.transform(validateMovieYear);

  Stream<bool> get movieStatus =>
      _movieStatusController.stream;

  get movieIsValid =>
      Rx.combineLatest3(movieName, movieAuthor, movieYear, (a, b, c) => true);

  // Set
  Function(String) get changeMovieName => _movieNameController.sink.add;

  Function(String) get changeMovieImage => _movieImageController.sink.add;

  Function(String) get changeMovieAuthor => _movieAuthorController.sink.add;

  Function(String) get changeMovieYear => _movieYearController.sink.add;

  Function(bool) get changeMovieStatus => _movieStatusController.sink.add;

  final validateMovieName = StreamTransformer<String, String>.fromHandlers(
      handleData: (movieName, sink) {
        if (movieName.isEmpty) {
          sink.addError("Nome do filme é obrigatório");
        } else {
          sink.add(movieName);
        }
      });

  final validateMovieAuthor = StreamTransformer<String, String>.fromHandlers(
      handleData: (movieAuthor, sink,) {
        if (movieAuthor.isEmpty) {
          sink.addError("Nome do autor é obrigatório");
        } else {
          sink.add(movieAuthor);
        }
      });

  final validateMovieYear = StreamTransformer<String, String>.fromHandlers(
      handleData: (movieYear, sink) {
        if (movieYear.isEmpty) {
          sink.addError("Ano do filme é obrigatório");
        } else {
          sink.add(movieYear);
        }
      });

  void setFormData(Movie movie) {
    _movieIdController.sink.add(movie.id);
    _movieNameController.sink.add(movie.name);
    _movieImageController.sink.add(movie.img);
    _movieAuthorController.sink.add(movie.author);
    _movieYearController.sink.add(movie.year);
    _movieStatusController.sink.add(movie.status);
  }

  Movie buildMovieFromFormData() {
    Movie movie = Movie();

    movie.id = _movieIdController.value;
    movie.name = _movieNameController.value;
    movie.img = _movieImageController.value;
    movie.author = _movieAuthorController.value;
    movie.year = _movieYearController.value;
    movie.status = _movieStatusController.value??false;

    print(movie);

    return movie;
  }

  @override
  void dispose() {
    _movieIdController.close();
    _movieNameController.close();
    _movieImageController.close();
    _movieAuthorController.close();
    _movieYearController.close();
    _movieStatusController.close();
  }

  @override
  void addListener(void Function() listener) {
    // TODO: implement addListener
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(void Function() listener) {
    // TODO: implement removeListener
  }

}
