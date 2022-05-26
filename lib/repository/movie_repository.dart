import 'package:fluttermovie/models/movie.dart';
import 'package:fluttermovie/dao/movie_dao.dart';

class MovieRepository {
  final movieDao = MovieDao();

  Future getMovies() => movieDao.getMovies();

  Future insertMovie(Movie movie) => movieDao.saveMovie(movie);

  Future updateMovie(Movie movie) => movieDao.updateMovie(movie);

  Future deleteMovieById(int id) => movieDao.deleteMovie(id);

}