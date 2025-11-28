import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_series.dart';
import 'package:ditonton/domain/usecases/get_popular_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "get_list_series_event.dart";
part "get_list_series_state.dart";

class GetListSeriesBloc extends Bloc<GetListSeriesEvent, GetListSeriesState> {
  final GetNowPlayingSeries _getNowPlayingSeries;
  final GetPopularSeries _getPopularSeries;
  final GetTopRatedSeries _getTopRatedSeries;

  GetListSeriesBloc({
    required GetNowPlayingSeries getNowPlayingSeries,
    required GetPopularSeries getPopularSeries,
    required GetTopRatedSeries getTopRatedSeries,
  })  : _getNowPlayingSeries = getNowPlayingSeries,
        _getPopularSeries = getPopularSeries,
        _getTopRatedSeries = getTopRatedSeries,
        super(GetListSeriesEmpty()) {
    on<FetchNowPlayingSeries>(_onFetchNowPlayingSeries);
    on<FetchPopularSeries>(_onFetchPopularSeries);
    on<FetchTopRatedSeries>(_onFetchTopRatedSeries);
  }

  void _onFetchNowPlayingSeries(
    FetchNowPlayingSeries event,
    Emitter<GetListSeriesState> emit,
  ) async {
    emit(GetListSeriesLoading());

    final result = await _getNowPlayingSeries.execute();

    result.fold(
      (failure) => emit(GetListSeriesError(failure.message)),
      (series) {
        final currentState = state;
        if (currentState is GetListSeriesHasData) {
          emit(currentState.copyWith(nowPlayingSeries: series));
        } else {
          emit(GetListSeriesHasData(nowPlayingSeries: series));
        }
      },
    );
  }

  void _onFetchPopularSeries(
    FetchPopularSeries event,
    Emitter<GetListSeriesState> emit,
  ) async {
    emit(GetListSeriesLoading());

    final result = await _getPopularSeries.execute();

    result.fold(
      (failure) => emit(GetListSeriesError(failure.message)),
      (series) {
        final currentState = state;
        if (currentState is GetListSeriesHasData) {
          emit(currentState.copyWith(popularSeries: series));
        } else {
          emit(GetListSeriesHasData(popularSeries: series));
        }
      },
    );
  }

  void _onFetchTopRatedSeries(
    FetchTopRatedSeries event,
    Emitter<GetListSeriesState> emit,
  ) async {
    emit(GetListSeriesLoading());

    final result = await _getTopRatedSeries.execute();

    result.fold(
      (failure) => emit(GetListSeriesError(failure.message)),
      (series) {
        final currentState = state;
        if (currentState is GetListSeriesHasData) {
          emit(currentState.copyWith(topRatedSeries: series));
        } else {
          emit(GetListSeriesHasData(topRatedSeries: series));
        }
      },
    );
  }
}
