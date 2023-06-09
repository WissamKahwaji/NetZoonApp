import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/categories/entities/factories/factory_companies.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';

class ViewFactoriesWidget extends StatelessWidget {
  const ViewFactoriesWidget({super.key, required this.factory});
  final List<FactoryCompanies> factory;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: factory.length,
        itemBuilder: (context, index) {
          return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: FactoriesCategories(
                  factory: factory[index],
                ),
              ));
        },
      ),
    );
  }
}

class FactoriesCategories extends StatelessWidget {
  const FactoriesCategories({super.key, required this.factory});
  final FactoryCompanies factory;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // controller.getData(factoryCategoriesModel.factoryCategoriesId);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
          child: SizedBox(
            height: 210.h,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: CachedNetworkImage(
                    imageUrl: factory.imgurl,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    height: 60.h,
                    width: MediaQuery.of(context).size.width,
                    color: AppColor.backgroundColor.withOpacity(0.8),
                    child: Text(
                      factory.name,
                      style: TextStyle(color: Colors.white, fontSize: 20.sp),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
