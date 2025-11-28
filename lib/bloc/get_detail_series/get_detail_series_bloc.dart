import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/entities/series_detail.dart';
import 'package:ditonton/domain/usecases/get_series_detail.dart';
import 'package:ditonton/domain/usecases/get_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_series_status.dart';
import 'package:ditonton/domain/usecases/remove_series_watchlist.dart';
import 'package:ditonton/domain/usecases/save_series_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_detail_series_state.dart';
part 'get_detail_series_event.dart';

class GetDetailSeriesBloc
    extends Bloc<GetDetailSeriesEvent, GetDetailSeriesState> {
  static const watchlistAddSuccessMessage = 'Added Series to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed Series from Watchlist';

  final GetSeriesDetail _getSeriesDetail;
  final GetSeriesRecommendations _getSeriesRecommendations;
  final GetWatchlistSeriesStatus _getWatchListStatus;
  final SaveSeriesWatchList _saveWatchlist;
  final RemoveSeriesWatchList _removeWatchlist;

  GetDetailSeriesBloc({
    required GetSeriesDetail getSeriesDetail,
    required GetSeriesRecommendations getSeriesRecommendations,
    required GetWatchlistSeriesStatus getWatchListStatus,
    required SaveSeriesWatchList saveWatchlist,
    required RemoveSeriesWatchList removeWatchlist,
  })  : _getSeriesDetail = getSeriesDetail,
        _getSeriesRecommendations = getSeriesRecommendations,
        _getWatchListStatus = getWatchListStatus,
        _saveWatchlist = saveWatchlist,
        _removeWatchlist = removeWatchlist,
        super(GetDetailSeriesInitial()) {
    on<FetchSeriesDetail>(_onFetchSeriesDetail);
    on<AddToSeriesWatchlist>(_onAddToWatchlist);
    on<RemoveFromSeriesWatchlist>(_onRemoveFromWatchlist);
    on<LoadSeriesWatchlistStatus>(_onLoadWatchlistStatus);
  }

  void _onFetchSeriesDetail(
    FetchSeriesDetail event,
    Emitter<GetDetailSeriesState> emit,
  ) async {
    emit(GetDetailSeriesLoading());

    final detailResult = await _getSeriesDetail.execute(event.id);
    await detailResult.fold(
      (failure) async {
        emit(GetDetailSeriesError(failure.message));
      },
      (seriesDetail) async {
        final recommendationResult =
            await _getSeriesRecommendations.execute(event.id);
        final watchlistStatus = await _getWatchListStatus.execute(event.id);

        recommendationResult.fold(
          (failure) {
            emit(GetDetailSeriesError(failure.message));
          },
          (recommendations) {
            emit(GetDetailSeriesHasData(
              seriesDetail: seriesDetail,
              recommendations: recommendations,
              isAddedToSeriesWatchlist: watchlistStatus,
            ));
          },
        );
      },
    );
  }

  void _onAddToWatchlist(
    AddToSeriesWatchlist event,
    Emitter<GetDetailSeriesState> emit,
  ) async {
    final previousState = state;

    final result = await _saveWatchlist.execute(event.seriesDetail);

    await result.fold(
      (failure) async {
        emit(GetDetailSeriesWatchlistSuccess(
          message: failure.message,
          isAddedToSeriesWatchlist: false,
        ));
      },
      (successMessage) async {
        emit(GetDetailSeriesWatchlistSuccess(
          message: successMessage,
          isAddedToSeriesWatchlist: true,
        ));
      },
    );

    if (previousState is GetDetailSeriesHasData) {
      final newWatchlistStatus =
          await _getWatchListStatus.execute(event.seriesDetail.id);
      emit(previousState.copyWith(
        isAddedToSeriesWatchlist: newWatchlistStatus,
        watchlistMessage: result.fold((l) => l.message, (r) => r),
      ));
    }
  }

  void _onRemoveFromWatchlist(
    RemoveFromSeriesWatchlist event,
    Emitter<GetDetailSeriesState> emit,
  ) async {
    final previousState = state;

    final result = await _removeWatchlist.execute(event.seriesDetail);

    await result.fold(
      (failure) async {
        emit(GetDetailSeriesWatchlistSuccess(
          message: failure.message,
          isAddedToSeriesWatchlist: true,
        ));
      },
      (successMessage) async {
        emit(GetDetailSeriesWatchlistSuccess(
          message: successMessage,
          isAddedToSeriesWatchlist: false,
        ));
      },
    );

    if (previousState is GetDetailSeriesHasData) {
      final newWatchlistStatus =
          await _getWatchListStatus.execute(event.seriesDetail.id);
      emit(previousState.copyWith(
        isAddedToSeriesWatchlist: newWatchlistStatus,
        watchlistMessage: result.fold((l) => l.message, (r) => r),
      ));
    }
  }

  void _onLoadWatchlistStatus(
    LoadSeriesWatchlistStatus event,
    Emitter<GetDetailSeriesState> emit,
  ) async {
    final result = await _getWatchListStatus.execute(event.id);

    if (state is GetDetailSeriesHasData) {
      final currentState = state as GetDetailSeriesHasData;
      emit(currentState.copyWith(isAddedToSeriesWatchlist: result));
    }
  }
}
