import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ayna_bloc/models/post.dart';
import 'package:ayna_bloc/services/api_service.dart';
import 'package:ayna_bloc/bloc/post_bloc.dart';

// Mock ApiService
class MockApiService extends Mock implements ApiService {}

void main() {
  group('PostBloc', () {
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
    });

    blocTest<PostBloc, PostState>(
      'emits [PostsLoading, PostsLoaded] when FetchPosts is added and API call is successful',
      build: () {
        // Mock successful API response
        when(mockApiService.fetchPosts).thenAnswer((_) async => [
              Post(id: 1, title: 'Test Post 1', body: 'Body 1'),
              Post(id: 2, title: 'Test Post 2', body: 'Body 2'),
            ]);
        return PostBloc(apiService: mockApiService);
      },
      act: (bloc) => bloc.add(FetchPosts()),
      expect: () => [PostsLoading(), isA<PostsLoaded>()],
    );

    blocTest<PostBloc, PostState>(
      'emits [PostsLoading, PostsError] when FetchPosts is added and API call fails',
      build: () {
        // Mock API error
        when(mockApiService.fetchPosts).thenThrow(Exception('API Error'));
        return PostBloc(apiService: mockApiService);
      },
      act: (bloc) => bloc.add(FetchPosts()),
      expect: () => [PostsLoading(), PostsError()],
    );
  });
}
