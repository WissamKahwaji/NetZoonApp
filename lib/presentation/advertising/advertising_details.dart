import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/advertisements/entities/advertisement.dart';
import 'package:netzoon/presentation/categories/widgets/free_zone_video_widget.dart';
import 'package:netzoon/presentation/categories/widgets/image_free_zone_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/price_suggestion_button.dart';

class AdvertismentDetalsScreen extends StatefulWidget {
  const AdvertismentDetalsScreen({super.key, required this.ads});

  final Advertisement ads;

  @override
  State<AdvertismentDetalsScreen> createState() =>
      _AdvertismentDetalsScreenState();
}

class _AdvertismentDetalsScreenState extends State<AdvertismentDetalsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController input = TextEditingController();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: BackgroundWidget(
            widget: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: 30.0.h),
                child: Column(
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
                            imageUrl: widget.ads.advertisingImage,
                            width: 700.w,
                            height: 200.h,
                            fit: BoxFit.cover,
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
                                    Text(
                                      '${widget.ads.advertisingPrice} درهم',
                                      style: TextStyle(
                                          color: AppColor.colorOne,
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Icon(
                                          Icons.share,
                                          color: AppColor.backgroundColor,
                                        ),
                                        Icon(
                                          Icons.favorite_border,
                                          color: AppColor.backgroundColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 7.h,
                                ),
                                Text(
                                  widget.ads.advertisingTitle,
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'عدد الزائرين :',
                                          style: TextStyle(
                                            color: AppColor.black,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8.0.w,
                                        ),
                                        Text(
                                          widget.ads.advertisingViews,
                                          style: TextStyle(
                                            color: AppColor.backgroundColor,
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
                              'تفاصيل',
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: 17.sp,
                              ),
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            titleAndInput(
                              title: 'الفئة',
                              input: widget.ads.advertisingBrand,
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            titleAndInput(
                              title: 'السنة',
                              input: widget.ads.advertisingYear,
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            titleAndInput(
                              title: 'كيلومترات',
                              input: '123',
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            titleAndInput(
                              title: 'المواصفات الاقليمية',
                              input: 'مواصفات خليجية',
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            titleAndInput(
                              title: 'الضمان',
                              input: 'لا ينطبق',
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            titleAndInput(
                              title: 'الموقع',
                              input: widget.ads.advertisingLocation,
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
                            'وصف',
                            style: TextStyle(
                              color: AppColor.black,
                              fontSize: 17.sp,
                            ),
                          ),
                          Text(
                            widget.ads.advertisingDescription,
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
                            'الصور :',
                            style: TextStyle(
                              color: AppColor.black,
                              fontSize: 17.sp,
                            ),
                          ),
                          widget.ads.advertisingImageList?.isNotEmpty == true
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      widget.ads.advertisingImageList?.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 0.94),
                                  itemBuilder: (BuildContext context, index) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(25.0),
                                      child: ListOfPictures(
                                        img: widget
                                            .ads.advertisingImageList![index],
                                      ),
                                    );
                                  })
                              : GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    'لا يوجد صور',
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
                      child: widget.ads.advertisingVedio != null &&
                              widget.ads.advertisingVedio != ''
                          ? VideoFreeZoneWidget(
                              title: "فيديو  : ",
                              vediourl: widget.ads.advertisingVedio ?? '',
                            )
                          : Text(
                              'لا يوجد فيديو',
                              style: TextStyle(
                                color: AppColor.mainGrey,
                                fontSize: 15.sp,
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 60.h,
                    ),
                  ],
                ),
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
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    AppColor.backgroundColor,
                  ),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  )),
                  fixedSize: const MaterialStatePropertyAll(
                    Size.fromWidth(200),
                  ),
                ),
                child: const Text('شراء المنتج'),
                onPressed: () {},
              ),
              PriceSuggestionButton(input: input),
            ],
          ),
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
 /*
 SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: CachedNetworkImage(
                        imageUrl: ads.advertisingImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.share,
                            color: AppColor.backgroundColor,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          const Icon(
                            Icons.favorite_border,
                            color: AppColor.backgroundColor,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'العنوان :',
                                  style: TextStyle(
                                    color: AppColor.backgroundColor,
                                    fontSize: 20.sp,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  ads.advertisingTitle,
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'تاريخ البدأ :',
                                  style: TextStyle(
                                    color: AppColor.backgroundColor,
                                    fontSize: 20.sp,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  ads.advertisingStartDate,
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'تاريخ الانتهاء',
                                  style: TextStyle(
                                    color: AppColor.backgroundColor,
                                    fontSize: 20.sp,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  ads.advertisingEndDate,
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الوصف :',
                                  style: TextStyle(
                                    color: AppColor.backgroundColor,
                                    fontSize: 20.sp,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Expanded(
                                  child: Text(
                                    ads.advertisingDescription,
                                    style: TextStyle(
                                      color: AppColor.black,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),*/