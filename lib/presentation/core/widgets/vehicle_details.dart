import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/categories/entities/vehicles/vehicle.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/helpers/map_to_date.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/phone_call_button.dart';
import 'package:netzoon/presentation/core/widgets/price_suggestion_button.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:video_player/video_player.dart';

import '../../categories/widgets/image_free_zone_widget.dart';
import '../blocs/country_bloc/country_bloc.dart';
import '../helpers/get_currency_of_country.dart';
import '../helpers/share_image_function.dart';

class VehicleDetailsScreen extends StatefulWidget {
  const VehicleDetailsScreen({super.key, required this.vehicle});

  final Vehicle vehicle;

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  late final CountryBloc countryBloc;

  @override
  void initState() {
    _videoPlayerController =
        VideoPlayerController.network(widget.vehicle.vedioUrl ?? '')
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            _videoPlayerController.play();
            setState(() {});
          });
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
    );
    _videoPlayerController.setLooping(true);
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController input = TextEditingController();
    return Scaffold(
      body: BackgroundWidget(
        widget: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: 30.0.h),
            child: BlocBuilder<CountryBloc, CountryState>(
              bloc: countryBloc,
              builder: (context, countryState) {
                if (countryState is CountryInitial) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 7,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl: widget.vehicle.imageUrl,
                              width: 700.w,
                              height: 200.h,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 70.0, vertical: 50),
                                child: CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                  color: AppColor.backgroundColor,

                                  // strokeWidth: 10,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Text(
                                      //   '${widget.vehicle.price.toString()} \$',
                                      //   style: TextStyle(
                                      //       color: AppColor.colorOne,
                                      //       fontSize: 17.sp,
                                      //       fontWeight: FontWeight.bold),
                                      // ),
                                      RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                color:
                                                    AppColor.backgroundColor),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: '${widget.vehicle.price}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              TextSpan(
                                                text: getCurrencyFromCountry(
                                                  countryState.selectedCountry,
                                                  context,
                                                ),
                                                style: TextStyle(
                                                    color: AppColor
                                                        .backgroundColor,
                                                    fontSize: 14.sp),
                                              )
                                            ]),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              await shareImageWithDescription(
                                                  imageUrl:
                                                      widget.vehicle.imageUrl,
                                                  description: widget
                                                      .vehicle.description);
                                            },
                                            icon: const Icon(
                                              Icons.share,
                                              color: AppColor.backgroundColor,
                                            ),
                                          ),
                                          // const Icon(
                                          //   Icons.favorite_border,
                                          //   color: AppColor.backgroundColor,
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 7.h,
                                  ),
                                  Text(
                                    widget.vehicle.name,
                                    style: TextStyle(
                                      color: AppColor.black,
                                      fontSize: 22.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 7,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   AppLocalizations.of(context).translate('details'),
                              //   style: TextStyle(
                              //     color: AppColor.black,
                              //     fontSize: 17.sp,
                              //   ),
                              // ),
                              SizedBox(
                                height: 7.h,
                              ),
                              titleAndInput(
                                title: AppLocalizations.of(context)
                                    .translate('owner'),
                                input: widget.vehicle.creator?.username ?? '',
                              ),
                              SizedBox(
                                height: 7.h,
                              ),
                              titleAndInput(
                                title: AppLocalizations.of(context)
                                    .translate('categ'),
                                input: widget.vehicle.category,
                              ),
                              SizedBox(
                                height: 7.h,
                              ),
                              titleAndInput(
                                title: AppLocalizations.of(context)
                                    .translate('contactNumber'),
                                input: widget.vehicle.contactNumber ?? '',
                              ),
                              SizedBox(
                                height: 7.h,
                              ),
                              titleAndInput(
                                title: AppLocalizations.of(context)
                                    .translate('year'),
                                input: formatDate(widget.vehicle.year),
                              ),
                              SizedBox(
                                height: 7.h,
                              ),
                              titleAndInput(
                                title: AppLocalizations.of(context)
                                    .translate('kilometers'),
                                input: widget.vehicle.kilometers.toString(),
                              ),
                              SizedBox(
                                height: 7.h,
                              ),
                              titleAndInput(
                                title: AppLocalizations.of(context)
                                    .translate('address'),
                                input: widget.vehicle.location,
                              ),

                              widget.vehicle.exteriorColor != null
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 7.0),
                                      child: titleAndInput(
                                        title: AppLocalizations.of(context)
                                            .translate('exterior_color'),
                                        input:
                                            widget.vehicle.exteriorColor ?? '',
                                      ),
                                    )
                                  : const SizedBox(),
                              widget.vehicle.interiorColor != null
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 7.0),
                                      child: titleAndInput(
                                        title: AppLocalizations.of(context)
                                            .translate('interior_color'),
                                        input:
                                            widget.vehicle.interiorColor ?? '',
                                      ),
                                    )
                                  : const SizedBox(),
                              widget.vehicle.doors != null
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 7.0),
                                      child: titleAndInput(
                                        title: AppLocalizations.of(context)
                                            .translate('doors'),
                                        input: '${widget.vehicle.doors} doors',
                                      ),
                                    )
                                  : const SizedBox(),
                              widget.vehicle.bodyCondition != null
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 7.0),
                                      child: titleAndInput(
                                        title: AppLocalizations.of(context)
                                            .translate('body_condition'),
                                        input:
                                            widget.vehicle.bodyCondition ?? '',
                                      ),
                                    )
                                  : const SizedBox(),
                              widget.vehicle.bodyType != null
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 7.0),
                                      child: titleAndInput(
                                        title: AppLocalizations.of(context)
                                            .translate('body_type'),
                                        input: widget.vehicle.bodyType ?? '',
                                      ),
                                    )
                                  : const SizedBox(),
                              widget.vehicle.mechanicalCondition != null
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 7.0),
                                      child: titleAndInput(
                                        title: AppLocalizations.of(context)
                                            .translate('mechanical_condition'),
                                        input: widget
                                                .vehicle.mechanicalCondition ??
                                            '',
                                      ),
                                    )
                                  : const SizedBox(),
                              widget.vehicle.seatingCapacity != null
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 7.0),
                                      child: titleAndInput(
                                        title: AppLocalizations.of(context)
                                            .translate('seating_capacity'),
                                        input:
                                            '${widget.vehicle.seatingCapacity} Seater',
                                      ),
                                    )
                                  : const SizedBox(),
                              widget.vehicle.numofCylinders != null
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 7.0),
                                      child: titleAndInput(
                                        title: AppLocalizations.of(context)
                                            .translate('num_of_cylinders'),
                                        input:
                                            '${widget.vehicle.numofCylinders}',
                                      ),
                                    )
                                  : const SizedBox(),
                              widget.vehicle.transmissionType != null
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 7.0),
                                      child: titleAndInput(
                                        title: AppLocalizations.of(context)
                                            .translate('transmission_type'),
                                        input:
                                            widget.vehicle.transmissionType ??
                                                "",
                                      ),
                                    )
                                  : const SizedBox(),
                              widget.vehicle.horsepower != null
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 7.0),
                                      child: titleAndInput(
                                        title: AppLocalizations.of(context)
                                            .translate('horsepower'),
                                        input: widget.vehicle.horsepower ?? "",
                                      ),
                                    )
                                  : const SizedBox(),
                              widget.vehicle.fuelType != null
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 7.0),
                                      child: titleAndInput(
                                        title: AppLocalizations.of(context)
                                            .translate('fuelType'),
                                        input: widget.vehicle.fuelType ?? "",
                                      ),
                                    )
                                  : const SizedBox(),
                              widget.vehicle.extras != null
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 7.0),
                                      child: titleAndInput(
                                        title: AppLocalizations.of(context)
                                            .translate('extras'),
                                        input: widget.vehicle.extras ?? "",
                                      ),
                                    )
                                  : const SizedBox(),
                              widget.vehicle.technicalFeatures != null
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 7.0),
                                      child: titleAndInput(
                                        title: AppLocalizations.of(context)
                                            .translate('technicalFeatures'),
                                        input:
                                            widget.vehicle.technicalFeatures ??
                                                "",
                                      ),
                                    )
                                  : const SizedBox(),
                              widget.vehicle.steeringSide != null
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 7.0),
                                      child: titleAndInput(
                                        title: AppLocalizations.of(context)
                                            .translate('steering_side'),
                                        input:
                                            widget.vehicle.steeringSide ?? "",
                                      ),
                                    )
                                  : const SizedBox(),
                              widget.vehicle.guarantee != null
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 7.0),
                                      child: titleAndInput(
                                        title: AppLocalizations.of(context)
                                            .translate('guarantee'),
                                        input: widget.vehicle.guarantee == true
                                            ? 'applies'
                                            : 'do not apply',
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 7,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context).translate('desc'),
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: 17.sp,
                              ),
                            ),
                            Text(
                              widget.vehicle.description,
                              style: TextStyle(
                                color: AppColor.mainGrey,
                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 7.h,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 7,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                        ),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppLocalizations.of(context).translate('images')} :',
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: 17.sp,
                              ),
                            ),
                            widget.vehicle.carImages?.isNotEmpty == true
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: widget.vehicle.carImages?.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 0.94),
                                    itemBuilder: (BuildContext context, index) {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        child: ListOfPictures(
                                          img: widget.vehicle.carImages![index],
                                        ),
                                      );
                                    })
                                : GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('no_images'),
                                      style: TextStyle(
                                        color: AppColor.mainGrey,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 7,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                        ),
                        child: widget.vehicle.vedioUrl != null &&
                                widget.vehicle.vedioUrl != ''
                            // ? VideoFreeZoneWidget(
                            //     title:
                            //         "${AppLocalizations.of(context).translate('vedio')}  : ",
                            //     vediourl: state.ads.advertisingVedio ?? '',
                            //   )
                            ? AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Chewie(
                                  controller: _chewieController,
                                ),
                              )
                            : Text(
                                AppLocalizations.of(context)
                                    .translate('no_vedio'),
                                style: TextStyle(
                                  color: AppColor.mainGrey,
                                  fontSize: 15.sp,
                                ),
                              ),
                      ),
                      SizedBox(
                        height: 110.h,
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PhoneCallWidget(
                phonePath: widget.vehicle.contactNumber ?? "",
                title: AppLocalizations.of(context).translate('call')),
            ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    AppColor.backgroundColor,
                  ),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  )),
                  fixedSize: const MaterialStatePropertyAll(
                    Size.fromWidth(100),
                  ),
                ),
                child: Text(AppLocalizations.of(context).translate('chat'))),
            PriceSuggestionButton(input: input),
          ],
        ),
      ),
    );
  }

  Container titleAndInput({
    required String title,
    required String input,
  }) {
    return Container(
      height: 40.h,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.4),
            width: 1.0,
          ),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColor.black,
                fontSize: 15.sp,
              ),
            ),
            Text(
              input,
              style: TextStyle(
                color: AppColor.mainGrey,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
