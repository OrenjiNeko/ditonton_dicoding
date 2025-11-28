part of 'get_watchlist_series_bloc.dart';

abstract class GetWatchlistSeriesState extends Equatable {
  const GetWatchlistSeriesState();

  @override
  List<Object> get props => [];
}

class GetWatchlistSeriesEmpty extends GetWatchlistSeriesState {}

class GetWatchlistSeriesLoading extends GetWatchlistSeriesState {}

class GetWatchlistSeriesError extends GetWatchlistSeriesState {
  final String message;

  GetWatchlistSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class GetWatchlistSeriesHasData extends GetWatchlistSeriesState {
  final List<Series> result;

  GetWatchlistSeriesHasData(this.result);

  @override
  List<Object> get props => [result];
}
