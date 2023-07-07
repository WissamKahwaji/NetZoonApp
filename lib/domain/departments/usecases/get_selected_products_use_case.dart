import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';

import '../repositories/departments_repository.dart';

class GetSelectedProductsUseCase
    extends UseCase<List<CategoryProducts>, String> {
  final DepartmentRepository departmentRepository;

  GetSelectedProductsUseCase({required this.departmentRepository});

  @override
  Future<Either<Failure, List<CategoryProducts>>> call(String params) {
    return departmentRepository.getSelectedProducts(userId: params);
  }
}
