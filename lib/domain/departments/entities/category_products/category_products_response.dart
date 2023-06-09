import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';

class CategoryProductsResponse extends Equatable {
  final String message;
  final String department;
  final String category;
  final List<CategoryProducts> products;

  const CategoryProductsResponse(
      {required this.department,
      required this.category,
      required this.message,
      required this.products});
  @override
  List<Object?> get props => [message, products];
}
