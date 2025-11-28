import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/usecases/get_watchlist_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_watchlist_series_event.dart';
part 'get_watchlist_series_state.dart';

class GetWatchlistSeriesBloc
    extends Bloc<GetWatchlistSeriesEvent, GetWatchlistSeriesState> {
  final GetWatchlistSeries _getWatchlistSeries;

  GetWatchlistSeriesBloc(this._getWatchlistSeries)
      : super(GetWatchlistSeriesEmpty()) {
    on<FetchWatchlistSeries>(
      (event, emit) async {
        emit(GetWatchlistSeriesLoading());
        final result = await _getWatchlistSeries.execute();

        result.fold(
          (failure) {
            emit(GetWatchlistSeriesError(failure.message));
          },
          (data) {
            emit(GetWatchlistSeriesHasData(data));
          },
        );
      },
    );
  }
}
