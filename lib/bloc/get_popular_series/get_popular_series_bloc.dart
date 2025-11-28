import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/usecases/get_popular_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "get_popular_series_event.dart";
part "get_popular_series_state.dart";

class GetPopularSeriesBloc
    extends Bloc<GetPopularSeriesEvent, GetPopularSeriesState> {
  final GetPopularSeries _getPopularSeries;

  GetPopularSeriesBloc(this._getPopularSeries)
      : super(GetPopularSeriesEmpty()) {
    on<FetchPopularSeries>(
      (event, emit) async {
        emit(GetPopularSeriesLoading());
        final result = await _getPopularSeries.execute();

        result.fold(
          (failure) {
            emit(GetPopularSeriesError(failure.message));
          },
          (data) {
            emit(GetPopularSeriesHasData(data));
          },
        );
      },
    );
  }
}
