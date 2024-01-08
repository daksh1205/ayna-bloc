import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ayna_bloc/bloc/dog_image_bloc.dart';
import 'package:dio/dio.dart';

// Mock Dio for network requests
class MockDio extends Mock implements Dio {}

void main() {
  group('DogImageBloc', () {
    late Dio mockDio;

    setUp(() {
      mockDio = MockDio();
    });

    blocTest<DogImageBloc, DogImageState>(
      'emits [DogImageLoading, DogImageLoaded] when FetchDogImage is added and API call is successful',
      build: () {
        // Mock successful Dio response
        when(() => mockDio.get(any())).thenAnswer((_) async => Response(
              requestOptions:
                  RequestOptions(path: 'https://random.dog/woof.json'),
              statusCode: 200,
              data: {'url': 'testImageUrl'},
            ));
        return DogImageBloc();
      },
      act: (bloc) => bloc.add(FetchDogImage()),
      expect: () => [DogImageLoading(), isA<DogImageLoaded>()],
    );

    blocTest<DogImageBloc, DogImageState>(
      'emits [DogImageLoading, DogImageError] when FetchDogImage is added and API call fails',
      build: () {
        // Mock Dio error
        when(() => mockDio.get(any())).thenThrow(DioError(
          requestOptions: RequestOptions(path: 'https://random.dog/woof.json'),
          error: 'Error',
        ));
        return DogImageBloc();
      },
      act: (bloc) => bloc.add(FetchDogImage()),
      expect: () => [DogImageLoading(), DogImageError()],
    );
  });
}
