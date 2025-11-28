import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "get_popular_movies_event.dart";
part "get_popular_movies_state.dart";

class GetPopularMoviesBloc
    extends Bloc<GetPopularMoviesEvent, GetPopularMoviesState> {
  final GetPopularMovies _getPopularMovies;

  GetPopularMoviesBloc(this._getPopularMovies)
      : super(GetPopularMoviesEmpty()) {
    on<FetchPopularMovies>(
      (event, emit) async {
        emit(GetPopularMoviesLoading());
        final result = await _getPopularMovies.execute();

        result.fold(
          (failure) {
            emit(GetPopularMoviesError(failure.message));
          },
          (data) {
            emit(GetPopularMoviesHasData(data));
          },
        );
      },
    );
  }
}
