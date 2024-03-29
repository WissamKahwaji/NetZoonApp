import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
part 'user_info_model.g.dart';

@JsonSerializable()
class UserInfoModel {
  final String username;
  final String? email;
  final String? password;
  final String? userType;
  final String? firstMobile;
  final bool? isFreeZoon;
  final bool? isService;
  final String? freezoneCity;
  final bool? deliverable;

  final String? secondeMobile;

  final String? thirdMobile;

  final String? subcategory;

  final String? address;

  final String? businessLicense;
  final int? companyProductsNumber;

  final String? sellType;
  final String? country;

  final String? toCountry;
  final String? bio;
  final String? description;
  final String? website;
  final String? slogn;
  final String? link;
  final String? profilePhoto;
  final String? coverPhoto;
  final String? banerPhoto;

  final bool? isThereWarehouse;
  final bool? isThereFoodsDelivery;
  final String? deliveryType;
  final int? deliveryCarsNum;
  final int? deliveryMotorsNum;
  final List? vehicles;
  final List? products;
  final List<String>? followings;
  final List<String>? followers;
  @JsonKey(name: '_id')
  final String id;
  final double? averageRating;
  final int? totalRatings;
  final int? profileViews;
  final double? profitRatio;

  final DateTime? subscriptionExpireDate;
  final int? realEstateListingsRemaining;
  final int? advertisementsRemaining;
  final int? carsListingsRemaining;
  final int? planesListingsRemaining;
  final String? city;
  final String? addressDetails;
  final int? floorNum;
  final String? locationType;
  UserInfoModel({
    required this.username,
    required this.email,
    required this.password,
    required this.userType,
    required this.firstMobile,
    this.secondeMobile,
    this.thirdMobile,
    this.subcategory,
    this.address,
    required this.isFreeZoon,
    this.isService,
    this.freezoneCity,
    this.deliverable,
    this.businessLicense,
    this.companyProductsNumber,
    this.sellType,
    this.country,
    this.toCountry,
    this.bio,
    this.description,
    this.website,
    this.slogn,
    this.link,
    this.profilePhoto,
    this.coverPhoto,
    this.banerPhoto,
    this.vehicles,
    this.products,
    this.followings,
    this.followers,
    required this.id,
    this.isThereWarehouse,
    this.isThereFoodsDelivery,
    this.deliveryType,
    this.deliveryCarsNum,
    this.deliveryMotorsNum,
    this.averageRating,
    this.totalRatings,
    this.profileViews,
    this.profitRatio,
    this.subscriptionExpireDate,
    this.realEstateListingsRemaining,
    this.advertisementsRemaining,
    this.carsListingsRemaining,
    this.planesListingsRemaining,
    this.city,
    this.addressDetails,
    this.floorNum,
    this.locationType,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);
}

extension MapToDomain on UserInfoModel {
  UserInfo toDomain() => UserInfo(
        username: username,
        email: email,
        password: password,
        userType: userType,
        firstMobile: firstMobile,
        isFreeZoon: isFreeZoon,
        isService: isService,
        freezoneCity: freezoneCity,
        deliverable: deliverable,
        secondeMobile: secondeMobile,
        thirdMobile: thirdMobile,
        subcategory: subcategory,
        address: address,
        businessLicense: businessLicense,
        companyProductsNumber: companyProductsNumber,
        sellType: sellType,
        country: country,
        toCountry: toCountry,
        bio: bio,
        description: description,
        website: website,
        slogn: slogn,
        link: link,
        profilePhoto: profilePhoto,
        coverPhoto: coverPhoto,
        banerPhoto: banerPhoto,
        vehicles: vehicles,
        products: products,
        followings: followings,
        followers: followers,
        id: id,
        deliveryCarsNum: deliveryCarsNum,
        deliveryMotorsNum: deliveryMotorsNum,
        deliveryType: deliveryType,
        isThereFoodsDelivery: isThereFoodsDelivery,
        isThereWarehouse: isThereWarehouse,
        averageRating: averageRating,
        totalRatings: totalRatings,
        profileViews: profileViews,
        profitRatio: profitRatio,
        subscriptionExpireDate: subscriptionExpireDate,
        advertisementsRemaining: advertisementsRemaining,
        carsListingsRemaining: carsListingsRemaining,
        planesListingsRemaining: planesListingsRemaining,
        realEstateListingsRemaining: realEstateListingsRemaining,
        city: city,
        addressDetails: addressDetails,
        floorNum: floorNum,
        locationType: locationType,
      );
}
