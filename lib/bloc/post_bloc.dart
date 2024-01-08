// blocs/post_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ayna_bloc/models/post.dart';
import 'package:ayna_bloc/services/api_service.dart';

abstract class PostEvent {}

class FetchPosts extends PostEvent {}

abstract class PostState {}

class PostsInitial extends PostState {}

class PostsLoading extends PostState {}

class PostsLoaded extends PostState {
  final List<Post> posts;
  PostsLoaded(this.posts);
}

class PostsError extends PostState {}

class PostBloc extends Bloc<PostEvent, PostState> {
  final ApiService apiService;

  PostBloc({required this.apiService}) : super(PostsInitial()) {
    on<FetchPosts>(_onFetchPosts);
  }

  Future<void> _onFetchPosts(FetchPosts event, Emitter<PostState> emit) async {
    emit(PostsLoading());
    try {
      final posts = await apiService.fetchPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError());
    }
  }
}
