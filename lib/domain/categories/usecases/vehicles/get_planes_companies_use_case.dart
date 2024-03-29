import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/repositories/vehicle_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../../../auth/entities/user_info.dart';

class GetPlanesCompaniesUseCase extends UseCase<List<UserInfo>, String> {
  final VehicleRepository vehicleRepository;

  GetPlanesCompaniesUseCase({required this.vehicleRepository});
  @override
  Future<Either<Failure, List<UserInfo>>> call(String params) {
    return vehicleRepository.getPlanesCompanies(country: params);
  }
}
