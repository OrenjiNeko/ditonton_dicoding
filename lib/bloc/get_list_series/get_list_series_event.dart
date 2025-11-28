part of 'get_list_series_bloc.dart';

abstract class GetListSeriesEvent extends Equatable {
  const GetListSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingSeries extends GetListSeriesEvent {}

class FetchPopularSeries extends GetListSeriesEvent {}

class FetchTopRatedSeries extends GetListSeriesEvent {}
