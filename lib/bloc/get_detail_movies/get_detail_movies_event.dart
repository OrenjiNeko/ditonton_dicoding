part of 'get_detail_movies_bloc.dart';

abstract class GetDetailMovieEvent extends Equatable {
  const GetDetailMovieEvent();

  @override
  List<Object> get props => [];
}

class FetchMovieDetail extends GetDetailMovieEvent {
  final int id;

  const FetchMovieDetail(this.id);

  @override
  List<Object> get props => [id];
}

class AddToWatchlist extends GetDetailMovieEvent {
  final MovieDetail movieDetail;

  const AddToWatchlist(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class RemoveFromWatchlist extends GetDetailMovieEvent {
  final MovieDetail movieDetail;

  const RemoveFromWatchlist(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class LoadWatchlistStatus extends GetDetailMovieEvent {
  final int id;

  const LoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}
