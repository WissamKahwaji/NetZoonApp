import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/user.dart';
import 'package:netzoon/domain/core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signUp({
    required String username,
    required String email,
    required String password,
    required String userType,
    required String firstMobile,
    required bool isFreeZoon,
  });
}
