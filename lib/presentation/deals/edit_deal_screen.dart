import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netzoon/domain/deals/entities/dealsItems/deals_items.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/deals/blocs/dealsItems/deals_items_bloc.dart';

import '../../injection_container.dart';
import '../core/constant/colors.dart';
import '../utils/app_localizations.dart';

class EditDealScreen extends StatefulWidget {
  final DealsItems deal;
  const EditDealScreen({super.key, required this.deal});

  @override
  State<EditDealScreen> createState() => _EditDealScreenState();
}

class _EditDealScreenState extends State<EditDealScreen>
    with ScreenLoader<EditDealScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController nameController = TextEditingController();
  late TextEditingController companyNameController = TextEditingController();
  late TextEditingController prevPriceController = TextEditingController();
  late TextEditingController currentPriceController = TextEditingController();

  late TextEditingController locationController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _updatedImage;

  final dealBloc = sl<DealsItemsBloc>();
  late DateTime _selectedStartDate;
  late DateTime _selectedEndDate;
  @override
  void initState() {
    nameController.text = widget.deal.name;
    companyNameController.text = widget.deal.companyName;
    prevPriceController.text = widget.deal.prevPrice.toString();
    currentPriceController.text = widget.deal.currentPrice.toString();
    locationController.text = widget.deal.location;
    _selectedStartDate = DateTime.parse(widget.deal.startDate);
    _selectedEndDate = DateTime.parse(widget.deal.endDate);

    super.initState();
  }

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Deal',
        ),
        // leading: Icon(Icons.arrow_back_ios_new),
        backgroundColor: AppColor.backgroundColor,
      ),
      body: BlocListener<DealsItemsBloc, DealsItemsState>(
        bloc: dealBloc,
        listener: (context, state) {
          if (state is EditDealInProgress) {
            startLoading();
          } else if (state is EditDealFailure) {
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
          } else if (state is EditDealSuccess) {
            stopLoading();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                AppLocalizations.of(context).translate('success'),
              ),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ));
            Navigator.of(context).pop();
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: _updatedImage != null
                              ? FileImage(_updatedImage!)
                              // ignore: unnecessary_null_comparison
                              : widget.deal.imgUrl != null
                                  ? CachedNetworkImageProvider(
                                      widget.deal.imgUrl)
                                  : Image.network(
                                          'https://static.vecteezy.com/system/resources/previews/005/544/718/original/profile-icon-design-free-vector.jpg')
                                      .image,
                          fit: BoxFit.cover),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        final image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        _updatedImage = image == null ? null : File(image.path);
                        setState(() {});
                      },
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          height: 35,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            // borderRadius: const BorderRadius.only(
                            //   bottomRight: Radius.circular(80),
                            //   bottomLeft: Radius.circular(80),
                            // ),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: AppColor.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  TextFormField(
                    controller: nameController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'name',
                      label: Text('name'),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'field_required_message';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 25.h),
                  TextFormField(
                    controller: companyNameController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'companyName',
                      label: Text('companyName'),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'field_required_message';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 25.h),
                  TextFormField(
                    controller: prevPriceController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'prev_price',
                      label: Text('prev_price'),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'field_required_message';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 25.h),
                  TextFormField(
                    controller: currentPriceController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'curr_price',
                      label: Text('curr_price'),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'field_required_message';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 25.h),
                  TextFormField(
                    controller: locationController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'location',
                      label: Text('location'),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'field_required_message';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 25.h),
                  // Text(
                  //   '${AppLocalizations.of(context).translate('start_date')} :',
                  //   style: TextStyle(
                  //     color: AppColor.backgroundColor,
                  //     fontSize: 16.sp,
                  //   ),
                  // ),
                  DateTimePicker(
                    initialValue: widget.deal.startDate,
                    decoration: const InputDecoration(
                      hintText: 'start_date',
                      label: Text('start_date'),
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
                        _selectedStartDate = DateTime.parse(selectedDate);
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

                  DateTimePicker(
                    initialValue: widget.deal.endDate,
                    decoration: const InputDecoration(
                      hintText: 'end_date',
                      label: Text('end_date'),
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
                    height: 20.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        dealBloc.add(EditDealEvent(
                            id: widget.deal.id ?? '',
                            name: nameController.text,
                            companyName: companyNameController.text,
                            dealImage: _updatedImage,
                            prevPrice: int.parse(prevPriceController.text),
                            currentPrice:
                                int.parse(currentPriceController.text),
                            startDate: _selectedStartDate,
                            endDate: _selectedEndDate,
                            location: locationController.text,
                            category: widget.deal.category,
                            country: widget.deal.country));
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          AppColor.backgroundColor,
                        ),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                        fixedSize: const MaterialStatePropertyAll(
                          Size.fromWidth(200),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'save_changes',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
