import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingSeries usecase;
  late MockSeriesRepository mockSeriesRepository;

  setUp(() {
    mockSeriesRepository = MockSeriesRepository();
    usecase = GetNowPlayingSeries(mockSeriesRepository);
  });

  final tSeries = <Series>[];

  test(
    "should get list of series from the repository when execute function is called",
    () async {
      // arrange
      when(mockSeriesRepository.getNowPlayingTVSeries())
          .thenAnswer((_) async => Right(tSeries));
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Right(tSeries));
    },
  );
}
