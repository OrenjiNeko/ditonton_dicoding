import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_watchlist_movies_event.dart';
part 'get_watchlist_movies_state.dart';

class GetWatchlistMoviesBloc
    extends Bloc<GetWatchlistMoviesEvent, GetWatchlistMoviesState> {
  final GetWatchlistMovies _getWatchlistMovies;

  GetWatchlistMoviesBloc(this._getWatchlistMovies)
      : super(GetWatchlistMoviesEmpty()) {
    on<FetchWatchlistMovies>(
      (event, emit) async {
        emit(GetWatchlistMoviesLoading());
        final result = await _getWatchlistMovies.execute();

        result.fold(
          (failure) {
            emit(GetWatchlistMoviesError(failure.message));
          },
          (data) {
            emit(GetWatchlistMoviesHasData(data));
          },
        );
      },
    );
  }
}
