import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/auth/user_info/user_info_model.dart';
import 'package:netzoon/domain/advertisements/entities/advertisement.dart';

part 'advertiement_model.g.dart';

@JsonSerializable()
class AdvertisemenetModel {
  @JsonKey(name: '_id')
  final String id;
  final UserInfoModel owner;
  final String advertisingTitle;
  final String advertisingStartDate;
  final String advertisingEndDate;
  final String advertisingDescription;
  final String advertisingImage;
  final int? advertisingViews;
  final String advertisingYear;
  final String advertisingLocation;
  final int advertisingPrice;
  final List<String>? advertisingImageList;
  final String? advertisingVedio;
  final String advertisingType;
  final bool purchasable;
  final String? type;
  final String? category;
  final String? color;
  final bool? guarantee;
  final String? contactNumber;
  final int? adsViews;
  AdvertisemenetModel({
    required this.id,
    required this.owner,
    required this.advertisingTitle,
    required this.advertisingStartDate,
    required this.advertisingEndDate,
    required this.advertisingDescription,
    required this.advertisingImage,
    required this.advertisingViews,
    required this.advertisingYear,
    required this.advertisingLocation,
    required this.advertisingPrice,
    this.advertisingImageList,
    this.advertisingVedio,
    required this.advertisingType,
    required this.purchasable,
    this.type,
    this.category,
    this.color,
    this.guarantee,
    this.contactNumber,
    this.adsViews,
  });

  factory AdvertisemenetModel.fromJson(Map<String, dynamic> json) =>
      _$AdvertisemenetModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdvertisemenetModelToJson(this);
}

extension MapToDomain on AdvertisemenetModel {
  Advertisement toDomain() => Advertisement(
        id: id,
        owner: owner.toDomain(),
        name: advertisingTitle,
        advertisingStartDate: advertisingStartDate,
        advertisingEndDate: advertisingEndDate,
        advertisingDescription: advertisingDescription,
        advertisingImage: advertisingImage,
        advertisingViews: advertisingViews,
        advertisingYear: advertisingYear,
        advertisingLocation: advertisingLocation,
        advertisingPrice: advertisingPrice.toString(),
        advertisingImageList: advertisingImageList,
        advertisingVedio: advertisingVedio,
        advertisingType: advertisingType,
        purchasable: purchasable,
        type: type,
        category: category,
        color: color,
        guarantee: guarantee,
        contactNumber: contactNumber,
        adsViews: adsViews,
      );
}
