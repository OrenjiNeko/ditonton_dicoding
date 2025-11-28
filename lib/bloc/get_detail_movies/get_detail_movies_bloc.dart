import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_detail_movies_state.dart';
part 'get_detail_movies_event.dart';

class GetDetailMovieBloc
    extends Bloc<GetDetailMovieEvent, GetDetailMovieState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail _getMovieDetail;
  final GetMovieRecommendations _getMovieRecommendations;
  final GetWatchListStatus _getWatchListStatus;
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;

  GetDetailMovieBloc({
    required GetMovieDetail getMovieDetail,
    required GetMovieRecommendations getMovieRecommendations,
    required GetWatchListStatus getWatchListStatus,
    required SaveWatchlist saveWatchlist,
    required RemoveWatchlist removeWatchlist,
  })  : _getMovieDetail = getMovieDetail,
        _getMovieRecommendations = getMovieRecommendations,
        _getWatchListStatus = getWatchListStatus,
        _saveWatchlist = saveWatchlist,
        _removeWatchlist = removeWatchlist,
        super(GetDetailMovieInitial()) {
    on<FetchMovieDetail>(_onFetchMovieDetail);
    on<AddToWatchlist>(_onAddToWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
  }

  void _onFetchMovieDetail(
    FetchMovieDetail event,
    Emitter<GetDetailMovieState> emit,
  ) async {
    emit(GetDetailMovieLoading());

    final detailResult = await _getMovieDetail.execute(event.id);

    await detailResult.fold(
      (failure) async {
        emit(GetDetailMovieError(failure.message));
      },
      (movieDetail) async {
        final recommendationResult =
            await _getMovieRecommendations.execute(event.id);
        final watchlistStatus = await _getWatchListStatus.execute(event.id);

        recommendationResult.fold(
          (failure) {
            emit(GetDetailMovieError(failure.message));
          },
          (recommendations) {
            emit(GetDetailMovieHasData(
              movieDetail: movieDetail,
              recommendations: recommendations,
              isAddedToWatchlist: watchlistStatus,
            ));
          },
        );
      },
    );
  }

  void _onAddToWatchlist(
    AddToWatchlist event,
    Emitter<GetDetailMovieState> emit,
  ) async {
    final previousState = state;

    final result = await _saveWatchlist.execute(event.movieDetail);

    await result.fold(
      (failure) async {
        emit(GetDetailMovieWatchlistSuccess(
          message: failure.message,
          isAddedToWatchlist: false,
        ));
      },
      (successMessage) async {
        emit(GetDetailMovieWatchlistSuccess(
          message: successMessage,
          isAddedToWatchlist: true,
        ));
      },
    );

    if (previousState is GetDetailMovieHasData) {
      final newWatchlistStatus =
          await _getWatchListStatus.execute(event.movieDetail.id);
      emit(previousState.copyWith(
        isAddedToWatchlist: newWatchlistStatus,
        watchlistMessage: result.fold((l) => l.message, (r) => r),
      ));
    }
  }

  void _onRemoveFromWatchlist(
    RemoveFromWatchlist event,
    Emitter<GetDetailMovieState> emit,
  ) async {
    final previousState = state;

    final result = await _removeWatchlist.execute(event.movieDetail);

    await result.fold(
      (failure) async {
        emit(GetDetailMovieWatchlistSuccess(
          message: failure.message,
          isAddedToWatchlist: true,
        ));
      },
      (successMessage) async {
        emit(GetDetailMovieWatchlistSuccess(
          message: successMessage,
          isAddedToWatchlist: false,
        ));
      },
    );

    if (previousState is GetDetailMovieHasData) {
      final newWatchlistStatus =
          await _getWatchListStatus.execute(event.movieDetail.id);
      emit(previousState.copyWith(
        isAddedToWatchlist: newWatchlistStatus,
        watchlistMessage: result.fold((l) => l.message, (r) => r),
      ));
    }
  }

  void _onLoadWatchlistStatus(
    LoadWatchlistStatus event,
    Emitter<GetDetailMovieState> emit,
  ) async {
    final result = await _getWatchListStatus.execute(event.id);

    if (state is GetDetailMovieHasData) {
      final currentState = state as GetDetailMovieHasData;
      emit(currentState.copyWith(isAddedToWatchlist: result));
    }
  }
}
