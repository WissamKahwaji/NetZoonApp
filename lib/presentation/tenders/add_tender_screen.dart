import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netzoon/domain/tenders/entities/tender_result.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/tenders/blocs/tendersItem/tenders_item_bloc.dart';

import '../../injection_container.dart';
import '../core/constant/colors.dart';
import '../core/widgets/add_photo_button.dart';
import '../utils/app_localizations.dart';
import 'blocs/tendersCategory/tender_cat_bloc.dart';

class AddTenderScreen extends StatefulWidget {
  const AddTenderScreen({super.key});

  @override
  State<AddTenderScreen> createState() => _AddTenderScreenState();
}

class _AddTenderScreenState extends State<AddTenderScreen>
    with ScreenLoader<AddTenderScreen> {
  late TextEditingController nameArController = TextEditingController();
  late TextEditingController nameEnController = TextEditingController();

  late TextEditingController companyNameController = TextEditingController();
  late TextEditingController priceController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? _image;

  late DateTime _selectedStartDate;
  late DateTime _selectedEndDate;

  TenderResult? selectCat;

  Future getImage(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    if (image == null) return;
    final imageTemporary = File(image.path);

    setState(() {
      _image = imageTemporary;
    });
  }

  final tenderBloc = sl<TenderCatBloc>();
  final addBloc = sl<TendersItemBloc>();
  @override
  void initState() {
    tenderBloc.add(GetAllTendersCatEvent());
    super.initState();
  }

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        widget: Padding(
          padding: const EdgeInsets.only(
            top: 4.0,
            bottom: 20,
            right: 8.0,
            left: 8.0,
          ),
          child: BlocListener<TendersItemBloc, TendersItemState>(
            bloc: addBloc,
            listener: (context, state) {
              if (state is TendersItemInProgress) {
                startLoading();
              } else if (state is TendersItemFailure) {
                stopLoading();

                final failure = state.message;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      failure,
                      style: const TextStyle(
                        color: AppColor.white,
                      ),
                    ),
                    backgroundColor: AppColor.red,
                  ),
                );
              } else if (state is AddTenderSuccess) {
                stopLoading();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    AppLocalizations.of(context).translate('success'),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ));
              }
            },
            child: BlocBuilder<TenderCatBloc, TenderCatState>(
              bloc: tenderBloc,
              builder: (context, state) {
                if (state is TenderCatInProgress) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.backgroundColor,
                    ),
                  );
                } else if (state is TenderCatFailure) {
                  final failure = state.message;
                  return Center(
                    child: Text(
                      failure,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  );
                } else if (state is TenderCatSuccess) {
                  return Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('add_tender'),
                              style: TextStyle(
                                color: AppColor.backgroundColor,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Divider(
                            color: AppColor.secondGrey,
                            thickness: 0.2,
                            endIndent: 30,
                            indent: 30,
                          ),
                          Text(
                            AppLocalizations.of(context).translate('categ'),
                            style: TextStyle(
                              color: AppColor.backgroundColor,
                              fontSize: 16.sp,
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 10)
                                  .r,
                              // Add some padding and a background color
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColor.black,
                                  )),
                              // Create the dropdown button
                              child: DropdownButton<TenderResult>(
                                // Set the selected value
                                value: selectCat,
                                // // Handle the value change
                                onChanged: (TenderResult? newValue) {
                                  setState(() {
                                    selectCat = newValue!;
                                  });
                                },
                                // onChanged: (String? newValue) => setState(
                                //     () => selectedValue = newValue ?? ''),
                                // Map each option to a widget
                                items: state.tenderCat
                                    .map<DropdownMenuItem<TenderResult>>(
                                        (TenderResult value) {
                                  return DropdownMenuItem<TenderResult>(
                                    value: value,
                                    // Use a colored box to show the option
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate(value.name),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                              )),
                          SizedBox(
                            height: 7.h,
                          ),
                          addTenderField(
                            context: context,
                            title: AppLocalizations.of(context)
                                .translate('nameAr'),
                            isNumber: false,
                            controller: nameArController,
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          addTenderField(
                            context: context,
                            title: AppLocalizations.of(context)
                                .translate('nameEn'),
                            isNumber: false,
                            controller: nameEnController,
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          addTenderField(
                            context: context,
                            title: AppLocalizations.of(context)
                                .translate('companyName'),
                            isNumber: false,
                            controller: companyNameController,
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          addTenderField(
                            context: context,
                            title:
                                AppLocalizations.of(context).translate('price'),
                            isNumber: true,
                            controller: priceController,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            '${AppLocalizations.of(context).translate('start_date')} :',
                            style: TextStyle(
                              color: AppColor.backgroundColor,
                              fontSize: 16.sp,
                            ),
                          ),
                          DateTimePicker(
                            initialValue: '',
                            decoration: InputDecoration(
                              filled: true,
                              //<-- SEE HERE
                              fillColor: Colors.green.withOpacity(0.1),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 30)
                                  .flipped,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            type: DateTimePickerType.dateTime,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            dateLabelText: 'Date And Time',
                            style: const TextStyle(
                              color: AppColor.black,
                            ),
                            onChanged: (selectedDate) {
                              setState(() {
                                _selectedStartDate =
                                    DateTime.parse(selectedDate);
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a date and time';
                              }
                              return null;
                            },
                            // onSaved: (val) => print(val),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            '${AppLocalizations.of(context).translate('end_date')} :',
                            style: TextStyle(
                              color: AppColor.backgroundColor,
                              fontSize: 16.sp,
                            ),
                          ),
                          DateTimePicker(
                            initialValue: '',
                            decoration: InputDecoration(
                              filled: true,
                              //<-- SEE HERE
                              fillColor: Colors.green.withOpacity(0.1),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 30)
                                  .flipped,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            type: DateTimePickerType.dateTime,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            dateLabelText: 'Date And Time',
                            style: const TextStyle(
                              color: AppColor.black,
                            ),

                            onChanged: (selectedDate) {
                              setState(() {
                                _selectedEndDate = DateTime.parse(selectedDate);
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a date and time';
                              }
                              return null;
                            },
                            // onSaved: (val) => print(val),
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          _image != null
                              ? Center(
                                  child: Image.file(
                                    _image!,
                                    width: 250.w,
                                    height: 250.h,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Center(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://lh3.googleusercontent.com/EbXw8rOdYxOGdXEFjgNP8lh-YAuUxwhOAe2jhrz3sgqvPeMac6a6tHvT35V6YMbyNvkZL4R_a2hcYBrtfUhLvhf-N2X3OB9cvH4uMw=w1064-v0',
                                    width: 250.w,
                                    height: 250.h,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Padding(
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
                                ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Center(
                            child: addPhotoButton(
                              context: context,
                              text: 'add_from_gallery',
                              onPressed: () {
                                getImage(ImageSource.gallery);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Center(
                            child: addPhotoButton(
                                context: context,
                                text: 'add_tender',
                                onPressed: () {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  if (_image == null) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            AppLocalizations.of(context)
                                                .translate('no_image_selected'),
                                            style: const TextStyle(
                                                color: AppColor.red),
                                          ),
                                          content: Text(
                                            AppLocalizations.of(context).translate(
                                                'please_select_an_image_before_uploading'),
                                            style: const TextStyle(
                                                color: AppColor.red),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              child: const Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    return;
                                  }
                                  addBloc.add(AddTenderEvent(
                                      nameAr: nameArController.text,
                                      nameEn: nameEnController.text,
                                      companyName: companyNameController.text,
                                      startDate: _selectedStartDate,
                                      endDate: _selectedEndDate,
                                      price: int.parse(priceController.text),
                                      tenderImage: _image!,
                                      category: selectCat?.name ?? ''));
                                }),
                          ),
                          SizedBox(
                            height: 80.h,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  Column addTenderField({
    required BuildContext context,
    required String title,
    required bool isNumber,
    TextEditingController? controller,
    int? maxLine,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColor.backgroundColor,
            fontSize: 15.sp,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 10).r,
          child: TextFormField(
            style: const TextStyle(color: Colors.black),
            keyboardType: isNumber
                ? const TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
            validator: (val) {
              if (val!.isEmpty) {
                return AppLocalizations.of(context).translate('required');
              }

              return null;
            },
            controller: controller,
            maxLines: maxLine,
            decoration: InputDecoration(
              filled: true,
              //<-- SEE HERE
              fillColor: Colors.green.withOpacity(0.1),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 30)
                      .flipped,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
