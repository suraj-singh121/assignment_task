import 'package:equatable/equatable.dart';
import '../../models/picsum_image.dart';
import 'package:assignment_task/src/models/picsum_image.dart';


abstract class ImagesState extends Equatable {
  const ImagesState();
  @override
  List<Object?> get props => [];
}

class ImagesInitial extends ImagesState {}
class ImagesLoading extends ImagesState {}
class ImagesLoaded extends ImagesState {
  final List<PicsumImage> images;
  const ImagesLoaded(this.images);
  @override
  List<Object?> get props => [images];
}
class ImagesError extends ImagesState {
  final String message;
  const ImagesError(this.message);
  @override
  List<Object?> get props => [message];
}
