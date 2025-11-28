import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "get_list_movies_event.dart";
part "get_list_movies_state.dart";

class GetListMovieBloc extends Bloc<GetListMoviesEvent, GetListMoviesState> {
  final GetNowPlayingMovies _getNowPlayingMovies;
  final GetPopularMovies _getPopularMovies;
  final GetTopRatedMovies _getTopRatedMovies;

  GetListMovieBloc({
    required GetNowPlayingMovies getNowPlayingMovies,
    required GetPopularMovies getPopularMovies,
    required GetTopRatedMovies getTopRatedMovies,
  })  : _getNowPlayingMovies = getNowPlayingMovies,
        _getPopularMovies = getPopularMovies,
        _getTopRatedMovies = getTopRatedMovies,
        super(GetListMoviesEmpty()) {
    on<FetchNowPlayingMovies>(_onFetchNowPlayingMovies);
    on<FetchPopularMovies>(_onFetchPopularMovies);
    on<FetchTopRatedMovies>(_onFetchTopRatedMovies);
  }

  void _onFetchNowPlayingMovies(
    FetchNowPlayingMovies event,
    Emitter<GetListMoviesState> emit,
  ) async {
    emit(GetListMoviesLoading());

    final result = await _getNowPlayingMovies.execute();

    result.fold(
      (failure) => emit(GetListMoviesError(failure.message)),
      (movies) {
        final currentState = state;
        if (currentState is GetListMoviesHasData) {
          emit(currentState.copyWith(nowPlayingMovies: movies));
        } else {
          emit(GetListMoviesHasData(nowPlayingMovies: movies));
        }
      },
    );
  }

  void _onFetchPopularMovies(
    FetchPopularMovies event,
    Emitter<GetListMoviesState> emit,
  ) async {
    emit(GetListMoviesLoading());

    final result = await _getPopularMovies.execute();

    result.fold(
      (failure) => emit(GetListMoviesError(failure.message)),
      (movies) {
        final currentState = state;
        if (currentState is GetListMoviesHasData) {
          emit(currentState.copyWith(popularMovies: movies));
        } else {
          emit(GetListMoviesHasData(popularMovies: movies));
        }
      },
    );
  }

  void _onFetchTopRatedMovies(
    FetchTopRatedMovies event,
    Emitter<GetListMoviesState> emit,
  ) async {
    emit(GetListMoviesLoading());

    final result = await _getTopRatedMovies.execute();

    result.fold(
      (failure) => emit(GetListMoviesError(failure.message)),
      (movies) {
        final currentState = state;
        if (currentState is GetListMoviesHasData) {
          emit(currentState.copyWith(topRatedMovies: movies));
        } else {
          emit(GetListMoviesHasData(topRatedMovies: movies));
        }
      },
    );
  }
}
