part of 'get_list_series_bloc.dart';

abstract class GetListSeriesState extends Equatable {
  const GetListSeriesState();

  @override
  List<Object> get props => [];
}

class GetListSeriesEmpty extends GetListSeriesState {}

class GetListSeriesLoading extends GetListSeriesState {}

class GetListSeriesError extends GetListSeriesState {
  final String message;

  GetListSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class GetListSeriesHasData extends GetListSeriesState {
  final List<Series> nowPlayingSeries;
  final List<Series> popularSeries;
  final List<Series> topRatedSeries;

  const GetListSeriesHasData({
    this.nowPlayingSeries = const [],
    this.popularSeries = const [],
    this.topRatedSeries = const [],
  });

  GetListSeriesHasData copyWith({
    List<Series>? nowPlayingSeries,
    List<Series>? popularSeries,
    List<Series>? topRatedSeries,
  }) {
    return GetListSeriesHasData(
      nowPlayingSeries: nowPlayingSeries ?? this.nowPlayingSeries,
      popularSeries: popularSeries ?? this.popularSeries,
      topRatedSeries: topRatedSeries ?? this.topRatedSeries,
    );
  }

  @override
  List<Object> get props => [nowPlayingSeries, popularSeries, topRatedSeries];
}
