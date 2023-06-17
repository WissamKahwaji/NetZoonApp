part of 'add_product_bloc.dart';

abstract class AddProductEvent extends Equatable {
  const AddProductEvent();

  @override
  List<Object> get props => [];
}

class AddProductRequestedEvent extends AddProductEvent {
  final String departmentName;
  final String categoryName;
  final String name;
  final String description;
  final int price;
  final List<String>? images;
  final File? video;
  final bool? guarantee;
  final String? address;
  final String? madeIn;
  final File image;
  final DateTime? year;

  const AddProductRequestedEvent({
    required this.departmentName,
    required this.categoryName,
    required this.name,
    required this.description,
    required this.price,
    this.images,
    this.video,
    this.guarantee,
    this.address,
    this.madeIn,
    required this.image,
    this.year,
  });
}
