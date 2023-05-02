import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/news/entities/news.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/news/news_details.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key, required this.news});
  final List<News> news;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BackgroundWidget(
          widget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: AllNewsWidget(news: news),
            ),
          ),
        ),
      ),
    );
  }
}

class AllNewsWidget extends StatelessWidget {
  const AllNewsWidget({super.key, required this.news});
  final List<News> news;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: news.length,
        itemBuilder: (BuildContext context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: SizedBox(
              // height: MediaQuery.of(context).size.height * 0.44,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          width: 35.w,
                          height: 35.h,
                          fit: BoxFit.cover,
                          imageUrl: news[index].ownerImage,
                        ),
                      ),
                      SizedBox(
                        width: 6.w,
                      ),
                      Text(
                        news[index].ownerName,
                        style: TextStyle(
                          color: AppColor.backgroundColor,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 240.h,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return NewsDetails(
                              news: news[index],
                            );
                          }),
                        );
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: Card(
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  bottom: 0,
                                  top: 0,
                                  right: 0,
                                  child: CachedNetworkImage(
                                    imageUrl: news[index].imgUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    color: AppColor.backgroundColor,
                                    child: Column(
                                      children: [
                                        Text(
                                          news[index].date,
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.white),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          height: 50.h,
                                          child: Text(
                                            news[index].title,
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          height: 30.h,
                                          child: Text(
                                            news[index].description,
                                            style: const TextStyle(
                                                color: AppColor.white),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.favorite_border),
                        SizedBox(
                          width: 5.w,
                        ),
                        const Icon(
                          Feather.message_circle,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        const Icon(
                          Feather.send,
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: 5.h,
                  // ),
                  // // Row(
                  // //   children: [
                  // //     Text(
                  // //       news[index].ownerName,
                  // //       style: TextStyle(
                  // //         color: AppColor.black,
                  // //         fontWeight: FontWeight.bold,
                  // //         fontSize: 16.sp,
                  // //       ),
                  // //     ),
                  // //     SizedBox(
                  // //       width: 5.w,
                  // //     ),
                  // //     Text(
                  // //       'بعض التفاصيل',
                  // //       style: TextStyle(
                  // //         color: AppColor.black,
                  // //         fontSize: 13.sp,
                  // //       ),
                  // //     ),
                  // //   ],
                  // // ),
                  SizedBox(
                    height: 5.h,
                  ),
                  const Text(
                    'لا يوجد تعليقات على هذا الخبر ..',
                    style: TextStyle(
                      color: AppColor.secondGrey,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  const Text(
                    '12/04/2023',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
