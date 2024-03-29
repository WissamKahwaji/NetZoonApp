import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/otp_login_response.dart';
import 'package:netzoon/domain/auth/entities/user.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signUp({
    required String username,
    required String email,
    required String password,
    required String userType,
    required String firstMobile,
    required bool isFreeZoon,
    bool? isService,
    bool? isSelectable,
    String? freezoneCity,
    required String country,
    String? secondMobile,
    String? thirdMobile,
    String? subcategory,
    String? address,
    int? companyProductsNumbe,
    String? sellType,
    String? toCountry,
    bool? deliverable,
    File? profilePhoto,
    File? coverPhoto,
    File? banerPhoto,
    File? frontIdPhoto,
    File? backIdPhoto,
    String? bio,
    String? description,
    String? website,
    String? slogn,
    String? link,
    String? title,
    File? tradeLicensePhoto,
    File? deliveryPermitPhoto,
    bool? isThereWarehouse,
    bool? isThereFoodsDelivery,
    String? deliveryType,
    int? deliveryCarsNum,
    int? deliveryMotorsNum,
    double? profitRatio,
    String? city,
    String? addressDetails,
    int? floorNum,
    String? locationType,
  });

  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> changeAccount({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserInfo>> getUserById({
    required String userId,
  });

  Future<Either<Failure, User?>> getSignedInUser();

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, String>> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  });

  Future<Either<Failure, bool>> getIsFirstTimeLogged();
  Future<Either<Failure, void>> setFirstTimeLogged(bool firstTimeLogged);

  Future<Either<Failure, OtpLoginResponse>> getOtpCode({
    required String mobileNumber,
  });
  Future<Either<Failure, OtpLoginResponse>> verifyOtpCode({
    required String phone,
    required String otp,
    required String hash,
  });

  Future<Either<Failure, String>> editProfile({
    required String userId,
    required String username,
    required String email,
    required String firstMobile,
    required String secondeMobile,
    required String thirdMobile,
    required File? profilePhoto,
    String? bio,
    String? description,
    String? website,
    String? link,
    String? slogn,
  });

  Future<Either<Failure, UserInfo>> addAcccess({
    required String email,
    required String username,
    required String password,
  });

  Future<Either<Failure, List<UserInfo>>> getUserAccounts({
    required String email,
  });

  Future<Either<Failure, List<UserInfo>>> getUserFollowings({
    required String userId,
  });

  Future<Either<Failure, List<UserInfo>>> getUserFollowers({
    required String userId,
  });
  Future<Either<Failure, String>> toggleFollow({
    required String currentUserId,
    required String otherUserId,
  });

  // Future<Either<Failure, RatingResponse>> getUserTotalRating({
  //   required String id,
  // });

  Future<Either<Failure, String>> rateUser({
    required String id,
    required double rating,
    required String userId,
  });

  Future<Either<Failure, String>> addVisitor({
    required String userId,
    required String viewerUserId,
  });

  Future<Either<Failure, List<UserInfo>>> getVisitors({
    required String id,
  });

  Future<Either<Failure, List<UserInfo>>> getAllUsers();
}
