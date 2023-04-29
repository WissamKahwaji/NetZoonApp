import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/contact/widgets/questionformfield.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';

class OpinionScreen extends StatelessWidget {
  const OpinionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BackgroundWidget(
        widget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 13.sp,
                    color: AppColor.backgroundColor,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    'الآراء',
                    style: TextStyle(
                      color: AppColor.backgroundColor,
                      fontSize: 20.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              QuestionFormField(
                textController: textController,
                hintText: 'أخبرنا برأيك ...',
                maxLines: 5,
              ),
              SizedBox(
                height: 10.h,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 40.h,
                    width: double.infinity,
                    color: AppColor.backgroundColor,
                    child: Center(
                      child: Text(
                        'إرسال',
                        style:
                            TextStyle(fontSize: 15.sp, color: AppColor.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
