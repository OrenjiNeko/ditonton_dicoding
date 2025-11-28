part of 'get_popular_movies_bloc.dart';

abstract class GetPopularMoviesEvent extends Equatable {
  const GetPopularMoviesEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularMovies extends GetPopularMoviesEvent {
  @override
  List<Object> get props => [];
}
