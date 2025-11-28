part of 'get_detail_movies_bloc.dart';

abstract class GetDetailMovieState extends Equatable {
  const GetDetailMovieState();

  @override
  List<Object?> get props => [];
}

class GetDetailMovieInitial extends GetDetailMovieState {}

class GetDetailMovieLoading extends GetDetailMovieState {}

class GetDetailMovieHasData extends GetDetailMovieState {
  final MovieDetail movieDetail;
  final List<Movie> recommendations;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const GetDetailMovieHasData({
    required this.movieDetail,
    required this.recommendations,
    required this.isAddedToWatchlist,
    this.watchlistMessage = '',
  });

  GetDetailMovieHasData copyWith({
    MovieDetail? movieDetail,
    List<Movie>? recommendations,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return GetDetailMovieHasData(
      movieDetail: movieDetail ?? this.movieDetail,
      recommendations: recommendations ?? this.recommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
        movieDetail,
        recommendations,
        isAddedToWatchlist,
        watchlistMessage,
      ];
}

class GetDetailMovieError extends GetDetailMovieState {
  final String message;

  const GetDetailMovieError(this.message);

  @override
  List<Object> get props => [message];
}

class GetDetailMovieWatchlistSuccess extends GetDetailMovieState {
  final String message;
  final bool isAddedToWatchlist;

  const GetDetailMovieWatchlistSuccess({
    required this.message,
    required this.isAddedToWatchlist,
  });

  @override
  List<Object> get props => [message, isAddedToWatchlist];
}
