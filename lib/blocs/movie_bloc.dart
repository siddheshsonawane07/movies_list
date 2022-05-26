import 'package:fluttermovie/models/movie.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttermovie/repository/movie_repository.dart';
import 'dart:async';

class MovieBloc implements BlocBase {
  final _movieRepository = MovieRepository();

  final _movieController = StreamController<List<Movie>>.broadcast();

  get movies => _movieController.stream;

  MovieBloc() {
    getMovies();
  }

  getMovies() async {
    _movieController.sink
        .add(await _movieRepository.getMovies());
  }

  addMovie(Movie movie) async {
    await _movieRepository.insertMovie(movie);
    getMovies();
  }

  updateMovie(Movie movie) async {
    await _movieRepository.updateMovie(movie);
    getMovies();
  }

  deleteMovieById(int id) async {
    _movieRepository.deleteMovieById(id);
    getMovies();
  }

  @override
  void addListener(void Function() listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    _movieController.close();
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
