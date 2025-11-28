part of 'get_popular_series_bloc.dart';

abstract class GetPopularSeriesState extends Equatable {
  const GetPopularSeriesState();

  @override
  List<Object> get props => [];
}

class GetPopularSeriesEmpty extends GetPopularSeriesState {}

class GetPopularSeriesLoading extends GetPopularSeriesState {}

class GetPopularSeriesError extends GetPopularSeriesState {
  final String message;

  GetPopularSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class GetPopularSeriesHasData extends GetPopularSeriesState {
  final List<Series> result;

  GetPopularSeriesHasData(this.result);

  @override
  List<Object> get props => [result];
}
