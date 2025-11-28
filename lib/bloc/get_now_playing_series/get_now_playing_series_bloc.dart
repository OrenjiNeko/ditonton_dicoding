import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_now_playing_series_event.dart';
part 'get_now_playing_series_state.dart';

class GetNowPlayingSeriesBloc
    extends Bloc<GetNowPlayingSeriesEvent, GetNowPlayingSeriesState> {
  final GetNowPlayingSeries _getNowPlayingSeries;

  GetNowPlayingSeriesBloc(this._getNowPlayingSeries)
      : super(GetNowPlayingSeriesEmpty()) {
    on<FetchNowPlayingSeries>(
      (event, emit) async {
        emit(GetNowPlayingSeriesLoading());
        final result = await _getNowPlayingSeries.execute();

        result.fold(
          (failure) {
            emit(GetNowPlayingSeriesError(failure.message));
          },
          (data) {
            emit(GetNowPlayingSeriesHasData(data));
          },
        );
      },
    );
  }
}
