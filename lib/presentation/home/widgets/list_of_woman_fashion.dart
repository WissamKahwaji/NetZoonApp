import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/woman_fashion/entities/woman_fashion_list.dart';
import 'package:netzoon/presentation/ecommerce/screens/subsection_screen.dart';

import '../../core/constant/colors.dart';

class ListOfWomanFashion extends StatelessWidget {
  const ListOfWomanFashion({super.key, required this.womanFashion});

  final List<WomanFashionList> womanFashion;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: womanFashion.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.30,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(1000)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const SubSectionsScreen(
                          filter: '',
                          category: '',
                          // list: womanFashion[index].deviceList,
                        );
                      }));
                    },
                    child: Container(
                      decoration:
                          const BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 151,
                            spreadRadius: 300,
                            offset: Offset(10, 30))
                      ]),
                      height: 300.h,
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: womanFashion[index].imgUrl,
                            fit: BoxFit.contain,
                            height: MediaQuery.of(context).size.height,
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
                          // Image.network(
                          //   womanFashion[index].imgUrl,
                          //   fit: BoxFit.fill,
                          //   height: MediaQuery.of(context).size.height,
                          // ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 35.h,
                              color: const Color(0xFF5776a5).withOpacity(0.8),
                              alignment: Alignment.center,
                              child: Text(
                                womanFashion[index].name,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
