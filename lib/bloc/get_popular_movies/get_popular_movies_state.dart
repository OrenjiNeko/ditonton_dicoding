part of 'get_popular_movies_bloc.dart';

abstract class GetPopularMoviesState extends Equatable {
  const GetPopularMoviesState();

  @override
  List<Object> get props => [];
}

class GetPopularMoviesEmpty extends GetPopularMoviesState {}

class GetPopularMoviesLoading extends GetPopularMoviesState {}

class GetPopularMoviesError extends GetPopularMoviesState {
  final String message;

  GetPopularMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class GetPopularMoviesHasData extends GetPopularMoviesState {
  final List<Movie> result;

  GetPopularMoviesHasData(this.result);

  @override
  List<Object> get props => [result];
}
