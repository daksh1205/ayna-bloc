import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

// Define the events
abstract class DogImageEvent {}

class FetchDogImage extends DogImageEvent {}

// Define the states
abstract class DogImageState {}

class DogImageInitial extends DogImageState {}

class DogImageLoading extends DogImageState {}

class DogImageLoaded extends DogImageState {
  final String imageUrl;
  DogImageLoaded(this.imageUrl);
}

class DogImageError extends DogImageState {}

class DogImageBloc extends Bloc<DogImageEvent, DogImageState> {
  DogImageBloc() : super(DogImageInitial()) {
    // Register event handler
    on<FetchDogImage>(_onFetchDogImage);
  }

  // Event handler for FetchDogImage
  void _onFetchDogImage(
      FetchDogImage event, Emitter<DogImageState> emit) async {
    emit(DogImageLoading());
    try {
      var response = await Dio().get('https://random.dog/woof.json');
      if (response.statusCode == 200 && response.data is Map) {
        var imageUrl = response.data['url'];
        emit(DogImageLoaded(imageUrl));
      } else {
        emit(DogImageError());
      }
    } catch (e) {
      emit(DogImageError());
    }
  }
}
