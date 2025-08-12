import 'package:flutter_bloc/flutter_bloc.dart';
import 'images_event.dart';
import 'images_state.dart';
import '../../repositories/picsum_repository.dart';


class ImagesBloc extends Bloc<ImagesEvent, ImagesState> {
  final PicsumRepository repository;
  ImagesBloc({required this.repository}) : super(ImagesInitial()) {
    on<FetchImages>((event, emit) async {
      emit(ImagesLoading());
      try {
        final images = await repository.fetchImages(limit: event.limit);
        emit(ImagesLoaded(images));
      } catch (e) {
        emit(ImagesError(e.toString()));
      }
    });
  }
}
