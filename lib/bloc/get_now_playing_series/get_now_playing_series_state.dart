part of 'get_now_playing_series_bloc.dart';

abstract class GetNowPlayingSeriesState extends Equatable {
  const GetNowPlayingSeriesState();

  @override
  List<Object> get props => [];
}

class GetNowPlayingSeriesEmpty extends GetNowPlayingSeriesState {}

class GetNowPlayingSeriesLoading extends GetNowPlayingSeriesState {}

class GetNowPlayingSeriesError extends GetNowPlayingSeriesState {
  final String message;

  GetNowPlayingSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class GetNowPlayingSeriesHasData extends GetNowPlayingSeriesState {
  final List<Series> result;

  GetNowPlayingSeriesHasData(this.result);

  @override
  List<Object> get props => [result];
}
