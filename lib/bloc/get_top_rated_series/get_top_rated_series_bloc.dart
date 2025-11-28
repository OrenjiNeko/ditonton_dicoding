import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "get_top_rated_series_event.dart";
part "get_top_rated_series_state.dart";

class GetTopRatedSeriesBloc
    extends Bloc<GetTopRatedSeriesEvent, GetTopRatedSeriesState> {
  final GetTopRatedSeries _getPopularSeries;

  GetTopRatedSeriesBloc(this._getPopularSeries)
      : super(GetTopRatedSeriesEmpty()) {
    on<FetchTopRatedSeries>(
      (event, emit) async {
        emit(GetTopRatedSeriesLoading());
        final result = await _getPopularSeries.execute();

        result.fold(
          (failure) {
            emit(GetTopRatedSeriesError(failure.message));
          },
          (data) {
            emit(GetTopRatedSeriesHasData(data));
          },
        );
      },
    );
  }
}
