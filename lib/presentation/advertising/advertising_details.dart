import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/advertising/blocs/ads/ads_bloc_bloc.dart';
import 'package:netzoon/presentation/categories/widgets/image_free_zone_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/on_failure_widget.dart';
import 'package:netzoon/presentation/core/widgets/price_suggestion_button.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:video_player/video_player.dart';

import '../../injection_container.dart';
import '../core/helpers/share_image_function.dart';

class AdvertismentDetalsScreen extends StatefulWidget {
  const AdvertismentDetalsScreen({super.key, required this.adsId});

  final String adsId;

  @override
  State<AdvertismentDetalsScreen> createState() =>
      _AdvertismentDetalsScreenState();
}

class _AdvertismentDetalsScreenState extends State<AdvertismentDetalsScreen> {
  final adsBloc = sl<AdsBlocBloc>();
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    adsBloc.add(GetAdsByIdEvent(id: widget.adsId));

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
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: BackgroundWidget(
            widget: RefreshIndicator(
              onRefresh: () async {
                adsBloc.add(GetAdsByIdEvent(id: widget.adsId));
              },
              color: AppColor.white,
              backgroundColor: AppColor.backgroundColor,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 30.0.h),
                  child: BlocBuilder<AdsBlocBloc, AdsBlocState>(
                    bloc: adsBloc,
                    builder: (context, state) {
                      if (state is AdsBlocInProgress) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 120.h,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColor.backgroundColor,
                            ),
                          ),
                        );
                      } else if (state is AdsBlocFailure) {
                        final failure = state.message;
                        return FailureWidget(
                            failure: failure,
                            onPressed: () {
                              adsBloc.add(GetAdsByIdEvent(id: widget.adsId));
                            });
                      } else if (state is GetAdsByIdSuccess) {
                        _videoPlayerController = VideoPlayerController.network(
                            state.ads.advertisingVedio ?? '')
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
                                    imageUrl: state.ads.advertisingImage,
                                    width: 700.w,
                                    height: 200.h,
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${state.ads.advertisingPrice} ${AppLocalizations.of(context).translate('AED')}',
                                              style: TextStyle(
                                                  color: AppColor.colorOne,
                                                  fontSize: 17.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // const Icon(
                                                //   Icons.favorite_border,
                                                //   color: AppColor.backgroundColor,
                                                // ),
                                                IconButton(
                                                  onPressed: () async {
                                                    await shareImageWithDescription(
                                                        imageUrl: state.ads
                                                            .advertisingImage,
                                                        description:
                                                            state.ads.name);
                                                  },
                                                  icon: const Icon(
                                                    Icons.share,
                                                    color: AppColor
                                                        .backgroundColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 7.h,
                                        ),
                                        Text(
                                          state.ads.name,
                                          style: TextStyle(
                                            color: AppColor.black,
                                            fontSize: 20.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'num_of_viewers'),
                                                  style: TextStyle(
                                                    color: AppColor.black,
                                                    fontSize: 15.sp,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 8.0.w,
                                                ),
                                                Text(
                                                  state.ads.advertisingViews ==
                                                          null
                                                      ? "0"
                                                      : state
                                                          .ads.advertisingViews
                                                          .toString(),
                                                  style: TextStyle(
                                                    color: AppColor
                                                        .backgroundColor,
                                                    fontSize: 15.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
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
                                    Text(
                                      AppLocalizations.of(context)
                                          .translate('details'),
                                      style: TextStyle(
                                        color: AppColor.black,
                                        fontSize: 17.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    titleAndInput(
                                      title: 'owner',
                                      input: state.ads.owner.username ?? '',
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    titleAndInput(
                                      title: 'categ',
                                      input: state.ads.advertisingType,
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    titleAndInput(
                                      title: 'year',
                                      input: state.ads.advertisingYear,
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    titleAndInput(
                                      title: 'kilometers',
                                      input: '123',
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    titleAndInput(
                                      title: 'regional_specifications',
                                      input: 'مواصفات خليجية',
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    titleAndInput(
                                      title: 'guarantee',
                                      input: 'لا ينطبق',
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    titleAndInput(
                                      title: 'الموقع',
                                      input: state.ads.advertisingLocation,
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
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
                                    AppLocalizations.of(context)
                                        .translate('desc'),
                                    style: TextStyle(
                                      color: AppColor.black,
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                  Text(
                                    state.ads.advertisingDescription,
                                    style: TextStyle(
                                      color: AppColor.mainGrey,
                                      fontSize: 15.sp,
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
                                  state.ads.advertisingImageList?.isNotEmpty ==
                                          true
                                      ? GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: state
                                              .ads.advertisingImageList?.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 0.94),
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                              child: ListOfPictures(
                                                img: state.ads
                                                        .advertisingImageList![
                                                    index],
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
                              child: state.ads.advertisingVedio != null &&
                                      state.ads.advertisingVedio != ''
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
                              height: 120.h,
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
          ),
        ),
        bottomNavigationBar: BlocBuilder<AdsBlocBloc, AdsBlocState>(
          bloc: adsBloc,
          builder: (context, state) {
            if (state is GetAdsByIdSuccess) {
              return BottomAppBar(
                height: 60.h,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      state.ads.purchasable
                          ? ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  AppColor.backgroundColor,
                                ),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                                fixedSize: const MaterialStatePropertyAll(
                                  Size.fromWidth(200),
                                ),
                              ),
                              child: Text(AppLocalizations.of(context)
                                  .translate('شراء المنتج')),
                              onPressed: () {},
                            )
                          : Container(),
                      PriceSuggestionButton(input: input),
                    ],
                  ),
                ),
              );
            } else if (state is AdsBlocInProgress) {
              return SizedBox(
                height: MediaQuery.of(context).size.height - 120.h,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.backgroundColor,
                  ),
                ),
              );
            } else if (state is AdsBlocFailure) {
              final failure = state.message;
              return FailureWidget(
                  failure: failure,
                  onPressed: () {
                    adsBloc.add(GetAdsByIdEvent(id: widget.adsId));
                  });
            }
            return Container();
          },
        ));
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
              AppLocalizations.of(context).translate(title),
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
