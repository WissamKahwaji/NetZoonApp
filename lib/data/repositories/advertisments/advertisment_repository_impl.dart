import 'dart:io';

import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/advertisements/ads_remote_data_source.dart';
import 'package:netzoon/data/models/advertisements/advertisements/advertiement_model.dart';
import 'package:netzoon/data/models/advertisements/advertising/advertising_model.dart';
import 'package:netzoon/domain/advertisements/entities/advertisement.dart';
import 'package:netzoon/domain/advertisements/entities/advertising.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/advertisements/repositories/advertisment_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:share_plus/share_plus.dart';

class AdvertismentRepositoryImpl implements AdvertismentRepository {
  final AdvertismentRemotDataSource advertismentRemotDataSource;
  final NetworkInfo networkInfo;

  AdvertismentRepositoryImpl({
    required this.advertismentRemotDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Advertising>> getAllAds() async {
    try {
      if (await networkInfo.isConnected) {
        final ads = await advertismentRemotDataSource.getAllAdvertisment();

        return Right(ads.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Advertising>> getAdvertisementByType(
      {required String userAdvertisingType}) async {
    try {
      if (await networkInfo.isConnected) {
        final ads = await advertismentRemotDataSource
            .getAdvertisementByType(userAdvertisingType);

        return Right(ads.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      // print(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addAdvertisement({
    required String owner,
    required String advertisingTitle,
    required String advertisingStartDate,
    required String advertisingEndDate,
    required String advertisingDescription,
    required File image,
    required String advertisingCountryAlphaCode,
    required String advertisingBrand,
    required String advertisingYear,
    required String advertisingLocation,
    required double advertisingPrice,
    required String advertisingType,
    List<XFile>? advertisingImageList,
    File? video,
    required bool purchasable,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        // FormData formData = FormData.fromMap({
        //   'advertisingTitle': advertisingTitle,
        //   'advertisingStartDate': advertisingStartDate,
        //   'advertisingEndDate': advertisingEndDate,
        //   'advertisingDescription': advertisingDescription,
        //   'image': await MultipartFile.fromFile(image.path,
        //       filename: 'image.jpg', contentType: MediaType('image', 'jpeg')),
        //   'advertisingCountryAlphaCode': advertisingCountryAlphaCode,
        //   'advertisingBrand': advertisingBrand,
        //   'advertisingYear': advertisingYear,
        //   'advertisingLocation': advertisingLocation,
        //   'advertisingPrice': advertisingPrice,
        //   'advertisingType': advertisingType,
        // });
        Dio dio = Dio();
        FormData formData = FormData();
        formData.fields.addAll([
          MapEntry('owner', owner),
          MapEntry('advertisingTitle', advertisingTitle),
          MapEntry('advertisingStartDate', advertisingStartDate),
          MapEntry('advertisingEndDate', advertisingEndDate),
          MapEntry('advertisingDescription', advertisingDescription),
          MapEntry('advertisingCountryAlphaCode', advertisingCountryAlphaCode),
          MapEntry('advertisingBrand', advertisingBrand),
          MapEntry('advertisingYear', advertisingYear),
          MapEntry('advertisingLocation', advertisingLocation),
          MapEntry('advertisingPrice', advertisingPrice.toString()),
          MapEntry('advertisingType', advertisingType),
          MapEntry('purchasable', purchasable.toString()),
        ]);
        // ignore: unnecessary_null_comparison
        if (image != null) {
          String fileName = 'image.jpg';
          formData.files.add(MapEntry(
            'image',
            await MultipartFile.fromFile(
              image.path,
              filename: fileName,
              contentType: MediaType('image', 'jpeg'),
            ),
          ));
        }

        if (advertisingImageList != null && advertisingImageList.isNotEmpty) {
          for (int i = 0; i < advertisingImageList.length; i++) {
            String fileName = 'image$i.jpg';
            File file = File(advertisingImageList[i].path);
            formData.files.add(MapEntry(
              'advertisingImageList',
              await MultipartFile.fromFile(
                file.path,
                filename: fileName,
                contentType: MediaType('image', 'jpeg'),
              ),
            ));
          }
        }

        if (video != null) {
          String fileName = 'video.mp4';
          formData.files.add(MapEntry(
            'video',
            await MultipartFile.fromFile(
              video.path,
              filename: fileName,
              contentType: MediaType('video', 'mp4'),
            ),
          ));
        }

        Response response = await dio.post(
            'https://net-zoon.onrender.com/advertisements/createAds',
            data: formData);
        // Handle the response as needed
        if (response.statusCode == 201) {
          return Right(response.data);
        } else {
          return Left(ServerFailure());
        }
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Advertisement>> getAdsById(
      {required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        final ads = await advertismentRemotDataSource.getAdsById(id);

        return Right(ads.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Advertising>> getUserAds(
      {required String userId}) async {
    try {
      if (await networkInfo.isConnected) {
        final ads = await advertismentRemotDataSource.getUserAds(userId);

        return Right(ads.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
