part of 'get_top_rated_movie_bloc.dart';

abstract class GetTopRatedMovieState extends Equatable {
  const GetTopRatedMovieState();

  @override
  List<Object> get props => [];
}

class GetTopRatedMoviesEmpty extends GetTopRatedMovieState {}

class GetTopRatedMoviesLoading extends GetTopRatedMovieState {}

class GetTopRatedMoviesError extends GetTopRatedMovieState {
  final String message;

  GetTopRatedMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class GetTopRatedMoviesHasData extends GetTopRatedMovieState {
  final List<Movie> result;

  GetTopRatedMoviesHasData(this.result);

  @override
  List<Object> get props => [result];
}
