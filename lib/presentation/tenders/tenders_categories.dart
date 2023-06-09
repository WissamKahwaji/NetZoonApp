import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/tenders/view_all_tenders_screen.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class TendersCategoriesScreen extends StatefulWidget {
  const TendersCategoriesScreen({
    super.key,
    required this.category,
  });
  final String category;
  // final List<Tender> tenders;

  @override
  State<TendersCategoriesScreen> createState() =>
      _TendersCategoriesScreenState();
}

class _TendersCategoriesScreenState extends State<TendersCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: BackgroundWidget(
          widget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context).translate('tender_categories'),
                  style: TextStyle(fontSize: 18.sp, color: Colors.black),
                ),
              ),
              tendersCategory(
                name: AppLocalizations.of(context)
                    .translate('from_minimum_price'),
                sort: 'min',
                category: widget.category,
              ),
              SizedBox(
                height: 20.h,
              ),
              tendersCategory(
                name: AppLocalizations.of(context)
                    .translate('from_maximum_price'),
                sort: 'max',
                category: widget.category,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Center tendersCategory(
      {required String name,
      required final String sort,
      required String category}) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ViewAllTendersScreen(
                      sort: sort,
                      category: category,
                      // tenders: widget.tenders,
                    );
                  },
                ),
              );
            },
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 60.h,
              width: 200.w,
              color: AppColor.backgroundColor,
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(
                      fontSize: 17.sp,
                      color: AppColor.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )),
      ),
    );
  }
}
