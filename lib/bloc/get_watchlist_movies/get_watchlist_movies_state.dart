part of 'get_watchlist_movies_bloc.dart';

abstract class GetWatchlistMoviesState extends Equatable {
  const GetWatchlistMoviesState();

  @override
  List<Object> get props => [];
}

class GetWatchlistMoviesEmpty extends GetWatchlistMoviesState {}

class GetWatchlistMoviesLoading extends GetWatchlistMoviesState {}

class GetWatchlistMoviesError extends GetWatchlistMoviesState {
  final String message;

  GetWatchlistMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class GetWatchlistMoviesHasData extends GetWatchlistMoviesState {
  final List<Movie> result;

  GetWatchlistMoviesHasData(this.result);

  @override
  List<Object> get props => [result];
}
