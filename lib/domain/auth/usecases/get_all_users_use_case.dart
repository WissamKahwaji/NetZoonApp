import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../entities/user_info.dart';

class GetAllUsersUseCase extends UseCase<List<UserInfo>, NoParams> {
  final AuthRepository authRepository;

  GetAllUsersUseCase({required this.authRepository});
  @override
  Future<Either<Failure, List<UserInfo>>> call(NoParams params) {
    return authRepository.getAllUsers();
  }
}
