import 'package:equatable/equatable.dart';

class FreeZone extends Equatable {
  final String id;
  final String name;
  final String imageUrl;

  const FreeZone(
      {required this.id, required this.name, required this.imageUrl});

  @override
  List<Object?> get props => [name, imageUrl];
}
