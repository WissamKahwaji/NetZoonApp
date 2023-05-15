import 'package:equatable/equatable.dart';

class CategoryProducts extends Equatable {
  final String? id;
  final String owner;
  final String name;
  final String imageUrl;
  final String category;
  final String description;
  final int price;
  final List<String>? images;
  final String? vedioUrl;
  final bool? guarantee;
  final String? propert;
  final String? madeIn;
  final String? year;

  const CategoryProducts({
    this.id,
    required this.owner,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.description,
    required this.price,
    this.images,
    this.vedioUrl,
    this.guarantee,
    this.propert,
    this.madeIn,
    this.year,
  });
  @override
  List<Object?> get props => [
        owner,
        name,
        imageUrl,
        category,
        description,
        price,
        images,
        guarantee,
        propert,
        madeIn,
        year,
      ];
}