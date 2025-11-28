part of 'get_top_rated_movie_bloc.dart';

abstract class GetTopRatedMovieEvent extends Equatable {
  const GetTopRatedMovieEvent();

  @override
  List<Object> get props => [];
}

class FetchTopRatedMovies extends GetTopRatedMovieEvent {
  @override
  List<Object> get props => [];
}
