part of 'get_top_rated_series_bloc.dart';

abstract class GetTopRatedSeriesState extends Equatable {
  const GetTopRatedSeriesState();

  @override
  List<Object> get props => [];
}

class GetTopRatedSeriesEmpty extends GetTopRatedSeriesState {}

class GetTopRatedSeriesLoading extends GetTopRatedSeriesState {}

class GetTopRatedSeriesError extends GetTopRatedSeriesState {
  final String message;

  GetTopRatedSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class GetTopRatedSeriesHasData extends GetTopRatedSeriesState {
  final List<Series> result;

  GetTopRatedSeriesHasData(this.result);

  @override
  List<Object> get props => [result];
}
