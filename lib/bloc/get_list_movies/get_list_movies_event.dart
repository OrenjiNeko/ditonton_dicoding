part of 'get_list_movies_bloc.dart';

abstract class GetListMoviesEvent extends Equatable {
  const GetListMoviesEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingMovies extends GetListMoviesEvent {}

class FetchPopularMovies extends GetListMoviesEvent {}

class FetchTopRatedMovies extends GetListMoviesEvent {}
