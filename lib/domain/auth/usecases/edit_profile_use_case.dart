import 'dart:io';

import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class EditProfileUseCase extends UseCase<String, EditProfileParams> {
  final AuthRepository authRepository;

  EditProfileUseCase({required this.authRepository});
  @override
  Future<Either<Failure, String>> call(EditProfileParams params) {
    return authRepository.editProfile(
      userId: params.userId,
      username: params.username,
      email: params.email,
      firstMobile: params.firstMobile,
      secondeMobile: params.secondeMobile,
      thirdMobile: params.thirdMobile,
      profilePhoto: params.profilePhoto,
      bio: params.bio,
      description: params.description,
      link: params.link,
      slogn: params.slogn,
      website: params.website,
    );
  }
}

class EditProfileParams {
  final String userId;
  final String username;
  final String email;
  final String firstMobile;
  final String secondeMobile;
  final String thirdMobile;
  final File? profilePhoto;
  final String? bio;
  final String? description;
  final String? website;
  final String? link;
  final String? slogn;
  EditProfileParams({
    required this.userId,
    required this.username,
    required this.email,
    required this.firstMobile,
    required this.secondeMobile,
    required this.thirdMobile,
    this.profilePhoto,
    this.bio,
    this.description,
    this.website,
    this.link,
    this.slogn,
  });
}
