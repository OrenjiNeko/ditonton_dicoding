import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "get_top_rated_movie_event.dart";
part "get_top_rated_movie_state.dart";

class GetTopRatedMovieBloc
    extends Bloc<GetTopRatedMovieEvent, GetTopRatedMovieState> {
  final GetTopRatedMovies _getPopularMovies;

  GetTopRatedMovieBloc(this._getPopularMovies)
      : super(GetTopRatedMoviesEmpty()) {
    on<FetchTopRatedMovies>(
      (event, emit) async {
        emit(GetTopRatedMoviesLoading());
        final result = await _getPopularMovies.execute();

        result.fold(
          (failure) {
            emit(GetTopRatedMoviesError(failure.message));
          },
          (data) {
            emit(GetTopRatedMoviesHasData(data));
          },
        );
      },
    );
  }
}
