import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/news/entities/news_info.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/news/add_new_page.dart';
import 'package:netzoon/presentation/news/blocs/news/news_bloc.dart';
import 'package:netzoon/presentation/news/news_details.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:netzoon/presentation/utils/convert_date_to_string.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key, required this.news});
  final List<News> news;

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final newsBloc = sl<NewsBloc>();

  @override
  void initState() {
    newsBloc.add(GetAllNewsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BackgroundWidget(
          widget: BlocBuilder<NewsBloc, NewsState>(
            bloc: newsBloc,
            builder: (context, state) {
              if (state is NewsInProgress) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.backgroundColor,
                  ),
                );
              } else if (state is NewsFailure) {
                final failure = state.message;
                return Center(
                  child: Text(
                    failure,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                );
              } else if (state is NewsSuccess) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: AllNewsWidget(news: state.news),
                  ),
                );
              }
              return Container();
            },
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const AddNewScreen();
                  },
                ),
              );
            },
            backgroundColor: AppColor.backgroundColor,
            tooltip: 'إضافة خبر',
            child: const Icon(
              Icons.add,
              size: 30,
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
                                          convertDateToString(
                                              news[index].createdAt ?? ''),
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
