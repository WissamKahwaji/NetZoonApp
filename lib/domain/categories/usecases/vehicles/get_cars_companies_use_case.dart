import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/categories/repositories/vehicle_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetCarsCompaniesUseCase extends UseCase<List<UserInfo>, String> {
  final VehicleRepository vehicleRepository;

  GetCarsCompaniesUseCase({required this.vehicleRepository});
  @override
  Future<Either<Failure, List<UserInfo>>> call(String params) {
    return vehicleRepository.getCarsCompanies(country: params);
  }
}
