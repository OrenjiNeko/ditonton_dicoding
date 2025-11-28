part of 'get_detail_series_bloc.dart';

abstract class GetDetailSeriesEvent extends Equatable {
  const GetDetailSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchSeriesDetail extends GetDetailSeriesEvent {
  final int id;

  const FetchSeriesDetail(this.id);

  @override
  List<Object> get props => [id];
}

class AddToSeriesWatchlist extends GetDetailSeriesEvent {
  final SeriesDetail seriesDetail;

  const AddToSeriesWatchlist(this.seriesDetail);

  @override
  List<Object> get props => [seriesDetail];
}

class RemoveFromSeriesWatchlist extends GetDetailSeriesEvent {
  final SeriesDetail seriesDetail;
  const RemoveFromSeriesWatchlist(this.seriesDetail);

  @override
  List<Object> get props => [seriesDetail];
}

class LoadSeriesWatchlistStatus extends GetDetailSeriesEvent {
  final int id;

  const LoadSeriesWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}
