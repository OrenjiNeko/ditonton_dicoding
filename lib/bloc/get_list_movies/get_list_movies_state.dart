part of 'get_list_movies_bloc.dart';

abstract class GetListMoviesState extends Equatable {
  const GetListMoviesState();

  @override
  List<Object> get props => [];
}

class GetListMoviesEmpty extends GetListMoviesState {}

class GetListMoviesLoading extends GetListMoviesState {}

class GetListMoviesError extends GetListMoviesState {
  final String message;

  GetListMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class GetListMoviesHasData extends GetListMoviesState {
  final List<Movie> nowPlayingMovies;
  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;

  const GetListMoviesHasData({
    this.nowPlayingMovies = const [],
    this.popularMovies = const [],
    this.topRatedMovies = const [],
  });

  GetListMoviesHasData copyWith({
    List<Movie>? nowPlayingMovies,
    List<Movie>? popularMovies,
    List<Movie>? topRatedMovies,
  }) {
    return GetListMoviesHasData(
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      popularMovies: popularMovies ?? this.popularMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
    );
  }

  @override
  List<Object> get props => [nowPlayingMovies, popularMovies, topRatedMovies];
}
