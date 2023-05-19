import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';

ClipRRect addPhotoButton(
    {required String text, required void Function()? onPressed}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(250.0).w,
    child: Container(
      width: 150.w,
      height: 50.0.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.greenAccent.withOpacity(0.9),
            AppColor.backgroundColor
          ],
        ),
      ),
      child: RawMaterialButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 11.0.sp,
          ),
        ),
      ),
    ),
  );
}
