import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../injection_container.dart';
import '../../../core/constant/colors.dart';
import '../../../core/widgets/add_photo_button.dart';
import '../../../core/widgets/background_widget.dart';
import '../../../notifications/blocs/notifications/notifications_bloc.dart';
import '../../../utils/app_localizations.dart';
import '../blocs/bloc/vehicle_bloc.dart';

class AddVehicleScreen extends StatefulWidget {
  final String category;
  const AddVehicleScreen({super.key, required this.category});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen>
    with ScreenLoader<AddVehicleScreen> {
  late TextEditingController nameController = TextEditingController();
  late TextEditingController descController = TextEditingController();
  late TextEditingController priceController = TextEditingController();
  late TextEditingController killometersController = TextEditingController();
  late TextEditingController yearController = TextEditingController();
  late TextEditingController locationController = TextEditingController();
  late TextEditingController typeController = TextEditingController();
  late TextEditingController categoryController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? _image;
  Future getImage(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    if (image == null) return;
    final imageTemporary = File(image.path);

    setState(() {
      _image = imageTemporary;
    });
  }

  File? _video;
  String videoName = '';
  String? _selectedDate;

  List<XFile> imageFileList = [];

  final ImagePicker imagePicker = ImagePicker();
  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    setState(() {});
  }

  String? _selectedCondition;

  final addBloc = sl<VehicleBloc>();
  final notifiBloc = sl<NotificationsBloc>();

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
          child: BlocListener<VehicleBloc, VehicleState>(
            bloc: addBloc,
            listener: (context, state) {
              if (state is AddVehicleInProgress) {
                startLoading();
              } else if (state is AddVehicleFailure) {
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
              } else if (state is AddVehicleSuccess) {
                stopLoading();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    AppLocalizations.of(context).translate('success'),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ));
                Navigator.of(context).pop();
                FirebaseMessaging.instance.getToken().then((value) {
                  notifiBloc.add(SendNotificationEvent(
                      fcmtoken: value ?? '',
                      text: nameController.text,
                      category: 'cars',
                      itemId: state.message));
                });
              }
            },
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        widget.category == 'cars'
                            ? AppLocalizations.of(context).translate('add_car')
                            : AppLocalizations.of(context)
                                .translate('add_airplane'),
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
                    SizedBox(
                      height: 10.h,
                    ),
                    addVehicleFormFeild(
                      context: context,
                      controller: nameController,
                      title: widget.category == 'cars'
                          ? 'car_name'
                          : 'airplane_name',
                      isNumber: false,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'هذا الحقل مطلوب';
                        }

                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    addVehicleFormFeild(
                      context: context,
                      controller: descController,
                      title: 'desc',
                      isNumber: false,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'هذا الحقل مطلوب';
                        }

                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    addVehicleFormFeild(
                      context: context,
                      controller: priceController,
                      title: 'price',
                      isNumber: true,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'هذا الحقل مطلوب';
                        }

                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    addVehicleFormFeild(
                      context: context,
                      controller: killometersController,
                      title: 'kilometers',
                      isNumber: false,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'هذا الحقل مطلوب';
                        }

                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      '${AppLocalizations.of(context).translate('year')} :',
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
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 30)
                            .flipped,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      type: DateTimePickerType.date,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Date',
                      style: const TextStyle(
                        color: AppColor.black,
                      ),
                      onChanged: (selectedDate) {
                        setState(() {
                          _selectedDate = selectedDate;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                      // onSaved: (val) => print(val),
                    ),
                    // SizedBox(
                    //   height: 10.h,
                    // ),
                    // addVehicleFormFeild(
                    //   context: context,
                    //   controller: yearController,
                    //   title: 'year',
                    //   isNumber: true,
                    //   validator: (val) {
                    //     if (val!.isEmpty) {
                    //       return 'هذا الحقل مطلوب';
                    //     }

                    //     return null;
                    //   },
                    // ),
                    SizedBox(
                      height: 10.h,
                    ),
                    addVehicleFormFeild(
                      context: context,
                      controller: locationController,
                      title: 'الموقع',
                      isNumber: false,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'هذا الحقل مطلوب';
                        }

                        return null;
                      },
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${AppLocalizations.of(context).translate('condition')} :',
                          style: TextStyle(
                            color: AppColor.backgroundColor,
                            fontSize: 15.sp,
                          ),
                        ),
                        SizedBox(
                          width: 40.w,
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Radio(
                                  value: 'new',
                                  groupValue: _selectedCondition,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCondition = value ?? '';
                                    });
                                  },
                                  activeColor: AppColor.backgroundColor,
                                ),
                                Text(AppLocalizations.of(context)
                                    .translate('new'))
                              ],
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: 'used',
                                  groupValue: _selectedCondition,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCondition = value ?? "";
                                    });
                                  },
                                  activeColor: AppColor.backgroundColor,
                                ),
                                Text(AppLocalizations.of(context)
                                    .translate('Used')),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    addPhotoButton(
                      context: context,
                      text: 'add_from_gallery',
                      onPressed: () {
                        getImage(ImageSource.gallery);
                      },
                    ),
                    SizedBox(
                      height: 10.h,
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
                            ),
                          ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)
                                  .translate('add_images'),
                              style: TextStyle(
                                color: AppColor.backgroundColor,
                                fontSize: 15.sp,
                              ),
                            ),
                            Text(
                              '${AppLocalizations.of(context).translate('maximum images')} : 6',
                              style: TextStyle(
                                color: AppColor.secondGrey,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                        addPhotoButton(
                            context: context,
                            text: 'Selecte Images',
                            onPressed: () {
                              selectImages();
                            }),
                      ],
                    ),
                    SizedBox(
                      height: imageFileList.isNotEmpty ? 200.h : 10.h,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: imageFileList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Card(
                              child: SizedBox(
                                height: 200.h,
                                width: MediaQuery.of(context).size.width.w - 85,
                                child: Image.file(
                                  File(imageFileList[index].path),
                                  fit: BoxFit.contain,
                                  // height: 100,
                                  // width: 100,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(250.0).w,
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
                            onPressed: () async {
                              final result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['mp4'],
                              );

                              if (result == null) return;
                              //Open Single File
                              final file = result.files.first;
                              // openFile(file);
                              setState(() {
                                videoName = file.name;
                              });
                              final newFile = await saveFilePermanently(file);

                              setState(() {
                                _video = newFile;
                              });
                            },
                            child: const Text(
                              'pick video',
                              style: TextStyle(color: AppColor.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          videoName,
                          style: const TextStyle(
                            color: AppColor.backgroundColor,
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: addPhotoButton(
                          context: context,
                          text: widget.category == 'cars'
                              ? 'add_car'
                              : 'add_airplane',
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) return;
                            if (_image == null) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'No Image Selected',
                                      style: TextStyle(color: AppColor.red),
                                    ),
                                    content: const Text(
                                      'Please select an image before uploading.',
                                      style: TextStyle(color: AppColor.red),
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
                            addBloc.add(AddVehicleEvent(
                              name: nameController.text,
                              description: descController.text,
                              price: int.parse(priceController.text),
                              kilometers: int.parse(killometersController.text),
                              year: DateTime.parse(_selectedDate ?? ''),
                              location: locationController.text,
                              type: _selectedCondition ?? 'new',
                              category: widget.category,
                              image: _image!,
                              carimages: imageFileList,
                              video: _video,
                            ));
                          }),
                    ),
                    SizedBox(
                      height: 80.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }

  Widget addVehicleFormFeild(
      {required BuildContext context,
      required String title,
      required bool isNumber,
      TextEditingController? controller,
      int? maxLines,
      String? Function(String?)? validator}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).translate(title),
          style: TextStyle(
            color: AppColor.backgroundColor,
            fontSize: 16.sp,
          ),
        ),
        TextFormField(
          controller: controller,
          style: const TextStyle(color: Colors.black),
          keyboardType: isNumber
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            //<-- SEE HERE
            fillColor: Colors.green.withOpacity(0.1),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 30).flipped,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
