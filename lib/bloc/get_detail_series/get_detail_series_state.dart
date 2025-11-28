part of 'get_detail_series_bloc.dart';

abstract class GetDetailSeriesState extends Equatable {
  const GetDetailSeriesState();

  @override
  List<Object?> get props => [];
}

class GetDetailSeriesInitial extends GetDetailSeriesState {}

class GetDetailSeriesLoading extends GetDetailSeriesState {}

class GetDetailSeriesHasData extends GetDetailSeriesState {
  final SeriesDetail seriesDetail;
  final List<Series> recommendations;
  final bool isAddedToSeriesWatchlist;
  final String watchlistMessage;

  const GetDetailSeriesHasData({
    required this.seriesDetail,
    required this.recommendations,
    required this.isAddedToSeriesWatchlist,
    this.watchlistMessage = '',
  });

  GetDetailSeriesHasData copyWith({
    SeriesDetail? seriesDetail,
    List<Series>? recommendations,
    bool? isAddedToSeriesWatchlist,
    String? watchlistMessage,
  }) {
    return GetDetailSeriesHasData(
      seriesDetail: seriesDetail ?? this.seriesDetail,
      recommendations: recommendations ?? this.recommendations,
      isAddedToSeriesWatchlist:
          isAddedToSeriesWatchlist ?? this.isAddedToSeriesWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
        seriesDetail,
        recommendations,
        isAddedToSeriesWatchlist,
        watchlistMessage,
      ];
}

class GetDetailSeriesError extends GetDetailSeriesState {
  final String message;

  const GetDetailSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class GetDetailSeriesWatchlistSuccess extends GetDetailSeriesState {
  final String message;
  final bool isAddedToSeriesWatchlist;

  const GetDetailSeriesWatchlistSuccess({
    required this.message,
    required this.isAddedToSeriesWatchlist,
  });

  @override
  List<Object> get props => [message, isAddedToSeriesWatchlist];
}
