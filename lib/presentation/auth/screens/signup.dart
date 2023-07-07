import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netzoon/presentation/auth/blocs/sign_up/sign_up_bloc.dart';
import 'package:netzoon/presentation/auth/widgets/background_auth_widget.dart';
import 'package:netzoon/presentation/auth/widgets/text_form_signup_widget.dart';
import 'package:netzoon/presentation/auth/widgets/text_signup_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/add_photo_button.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/injection_container.dart' as di;
import 'package:netzoon/presentation/home/test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.accountTitle});
  final String accountTitle;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with ScreenLoader<SignUpPage> {
  final SignUpBloc bloc = di.sl<SignUpBloc>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailSignup = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController passwordSignup = TextEditingController();
  final TextEditingController aboutSignup = TextEditingController();

  final TextEditingController numberPhoneOne = TextEditingController();
  final TextEditingController numberPhoneTow = TextEditingController();
  final TextEditingController numberPhoneThree = TextEditingController();
  final TextEditingController subcategory = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController isFreeZoon = TextEditingController();
  final TextEditingController companyProductsNumber = TextEditingController();
  final TextEditingController sellType = TextEditingController();
  final TextEditingController toCountry = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();

  File? profileImage;
  File? coverImage;
  final GlobalKey<FormFieldState> _emailFormFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> passwordFormFieldKey =
      GlobalKey<FormFieldState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget screen(BuildContext context) {
    return BlocListener(
      bloc: bloc,
      listener: (context, state) {
        if (state is SignUpInProgress) {
          startLoading();
        } else if (state is SignUpFailure) {
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
        } else if (state is SignUpSuccess) {
          stopLoading();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              AppLocalizations.of(context).translate('success'),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ));
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              CupertinoPageRoute(builder: (context) {
            return const TestScreen();
          }), (route) => false);
        }
      },
      child: SignUpWidget(
        formKey: formKey,
        accountTitle: widget.accountTitle,
        emailSignup: emailSignup,
        username: username,
        passwordSignup: passwordSignup,
        passwordFormFieldKey: passwordFormFieldKey,
        aboutSignup: aboutSignup,
        numberPhoneOne: numberPhoneOne,
        numberPhoneTow: numberPhoneTow,
        numberPhoneThree: numberPhoneThree,
        rememberMe: true,
        bloc: bloc,
        emailFormFieldKey: _emailFormFieldKey,
        address: address,
        subcategory: subcategory,
        companyProductsNumber: companyProductsNumber,
        sellType: sellType,
        toCountry: toCountry,
        bioController: bioController,
        descriptionController: descriptionController,
        websiteController: websiteController,
      ),
    );
  }
}

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({
    super.key,
    required this.formKey,
    required this.accountTitle,
    required this.emailSignup,
    required this.username,
    required this.passwordSignup,
    required this.aboutSignup,
    required this.numberPhoneOne,
    required this.numberPhoneTow,
    required this.numberPhoneThree,
    required this.rememberMe,
    required this.bloc,
    required this.emailFormFieldKey,
    required this.passwordFormFieldKey,
    required this.subcategory,
    required this.address,
    required this.companyProductsNumber,
    required this.sellType,
    required this.toCountry,
    required this.bioController,
    required this.descriptionController,
    required this.websiteController,
  });
  final GlobalKey<FormState> formKey;
  final GlobalKey<FormFieldState> emailFormFieldKey;
  final GlobalKey<FormFieldState> passwordFormFieldKey;
  final String accountTitle;
  final TextEditingController emailSignup;
  final TextEditingController username;
  final TextEditingController passwordSignup;
  final TextEditingController aboutSignup;
  final TextEditingController numberPhoneOne;
  final TextEditingController numberPhoneTow;
  final TextEditingController numberPhoneThree;
  final TextEditingController subcategory;
  final TextEditingController address;
  final TextEditingController companyProductsNumber;
  final TextEditingController sellType;
  final TextEditingController toCountry;
  final TextEditingController bioController;
  final TextEditingController descriptionController;
  final TextEditingController websiteController;

  final bool rememberMe;
  final SignUpBloc bloc;

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

bool showPass = true;

class _SignUpWidgetState extends State<SignUpWidget> {
  File? profileImage;
  File? coverImage;
  File? banerImage;
  File? frontIdPhoto;
  File? backIdPhoto;
  bool _isDeliverable = false;

  Future getProfileImage(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    if (image == null) return;
    final imageTemporary = File(image.path);

    setState(() {
      profileImage = imageTemporary;
    });
  }

  Future getCoverImage(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    if (image == null) return;
    final imageTemporary = File(image.path);

    setState(() {
      coverImage = imageTemporary;
    });
  }

  Future getBanerImage(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    if (image == null) return;
    final imageTemporary = File(image.path);

    setState(() {
      banerImage = imageTemporary;
    });
  }

  Future getFrontIdImage(
    ImageSource imageSource,
  ) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    if (image == null) return;
    final imageTemporary = File(image.path);

    setState(() {
      frontIdPhoto = imageTemporary;
    });
  }

  Future getBackIdImage(
    ImageSource imageSource,
  ) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    if (image == null) return;
    final imageTemporary = File(image.path);

    setState(() {
      backIdPhoto = imageTemporary;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundAuthWidget(
      topLogo: 0.2,
      onTap: () {
        Navigator.of(context).pop();
      },
      topBack: 150.h,
      topWidget: 160.h,
      topTitle: 110.h,
      n: 0.25.h,
      title: AppLocalizations.of(context).translate(widget.accountTitle),
      widget: Form(
        key: widget.formKey,
        child: Container(
          height: MediaQuery.of(context).size.height - 155.h,
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 10, vertical: 10),
          color: Colors.grey.withOpacity(0.1),
          child: ListView(
            children: [
              TextSignup(text: AppLocalizations.of(context).translate('email')),
              TextFormField(
                key: widget.emailFormFieldKey,
                controller: widget.emailSignup,
                style: const TextStyle(color: Colors.black),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return AppLocalizations.of(context)
                        .translate('email_condition');
                  }

                  if (!EmailValidator(
                          errorText: AppLocalizations.of(context)
                              .translate('email_not_valid'))
                      .isValid(text.toLowerCase())) {
                    return AppLocalizations.of(context)
                        .translate('input_valid_email');
                  }

                  return null;
                },
                onChanged: (text) {
                  widget.emailFormFieldKey.currentState!.validate();
                },
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
              TextSignup(
                  text: AppLocalizations.of(context).translate('username')),
              TextFormField(
                controller: widget.username,
                style: const TextStyle(color: Colors.black),
                validator: (val) {
                  if (val!.isEmpty) {
                    return AppLocalizations.of(context)
                        .translate('username_required');
                  }
                  if (val.length < 5) {
                    return AppLocalizations.of(context)
                        .translate('username_condition');
                  }
                  return null;
                },
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
              TextSignup(
                  text: AppLocalizations.of(context).translate('password')),
              TextFormField(
                key: widget.passwordFormFieldKey,
                controller: widget.passwordSignup,
                style: const TextStyle(color: AppColor.black),
                decoration: InputDecoration(
                  filled: true,
                  //<-- SEE HERE
                  fillColor: Colors.green.withOpacity(0.1),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 30)
                          .flipped,
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        showPass = !showPass;
                      });
                    },
                    child: showPass
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: showPass,
                // textInputAction: widget.textInputAction ?? TextInputAction.done,
                validator: MultiValidator([
                  RequiredValidator(
                      errorText: AppLocalizations.of(context)
                          .translate('password_required')),
                  MinLengthValidator(8,
                      errorText: AppLocalizations.of(context)
                          .translate('password_condition')),
                ]),
                onChanged: (text) {
                  widget.passwordFormFieldKey.currentState!.validate();
                },
              ),
              TextSignup(
                  text: AppLocalizations.of(context)
                      .translate('contact_numbers')),
              Row(
                children: [
                  Expanded(
                    child: TextFormSignupWidget(
                      password: false,
                      isNumber: false,
                      valid: (val) {
                        if (val!.isEmpty) {
                          return AppLocalizations.of(context)
                              .translate('required');
                        }

                        return null;
                      },
                      myController: widget.numberPhoneOne,
                    ),
                  ),
                  Expanded(
                    child: TextFormSignupWidget(
                      password: false,
                      isNumber: false,
                      valid: (val) {
                        return null;

                        // return validInput(val!, 5, 100, "phone");
                      },
                      myController: widget.numberPhoneTow,
                    ),
                  ),
                  Expanded(
                    child: TextFormSignupWidget(
                      password: false,
                      isNumber: false,
                      valid: (val) {
                        return null;

                        // return validInput(val!, 5, 100, "phone");
                      },
                      myController: widget.numberPhoneThree,
                    ),
                  )
                ],
              ),
              TextSignup(text: AppLocalizations.of(context).translate('Bio')),
              TextFormField(
                controller: widget.bioController,
                style: const TextStyle(color: AppColor.black),
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
                keyboardType: TextInputType.text,

                // textInputAction: widget.textInputAction ?? TextInputAction.done,

                onChanged: (text) {
                  widget.passwordFormFieldKey.currentState!.validate();
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              TextSignup(text: AppLocalizations.of(context).translate('desc')),
              TextFormField(
                controller: widget.descriptionController,
                style: const TextStyle(color: AppColor.black),
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
                keyboardType: TextInputType.text,

                // textInputAction: widget.textInputAction ?? TextInputAction.done,

                onChanged: (text) {
                  widget.passwordFormFieldKey.currentState!.validate();
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              CheckboxListTile(
                title: Text(
                  AppLocalizations.of(context).translate('Is there delivery'),
                  style: TextStyle(
                    color: AppColor.backgroundColor,
                    fontSize: 15.sp,
                  ),
                ),
                activeColor: AppColor.backgroundColor,
                value: _isDeliverable,
                onChanged: (bool? value) {
                  setState(() {
                    _isDeliverable = value ?? false;
                  });
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              widget.accountTitle == 'المستهلك' ||
                      widget.accountTitle == 'جهة إخبارية'
                  ? Container()
                  : TextSignup(
                      text: AppLocalizations.of(context)
                          .translate('subcategory')),
              widget.accountTitle == 'المستهلك' ||
                      widget.accountTitle == 'جهة إخبارية'
                  ? Container()
                  : TextFormSignupWidget(
                      password: false,
                      isNumber: false,
                      valid: (val) {
                        return null;

                        // return validInput(val!, 5, 100, "password");
                      },
                      myController: widget.subcategory,
                    ),
              widget.accountTitle == 'المستهلك'
                  ? Container()
                  : TextSignup(
                      text: AppLocalizations.of(context)
                          .translate('address_and_other_branches')),
              widget.accountTitle == 'المستهلك'
                  ? Container()
                  : TextFormSignupWidget(
                      password: false,
                      isNumber: false,
                      valid: (val) {
                        return null;

                        // return validInput(val!, 5, 100, "password");
                      },
                      myController: widget.address,
                    ),
              widget.accountTitle == 'المستهلك'
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: TextSignup(
                                text: AppLocalizations.of(context)
                                    .translate('affiliated_to_a_free_zone'))),
                        SizedBox(
                          width: 20.w,
                          child: CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (val) {
                              // print("object");
                              // controller.checkbox(val!);
                            },
                            value: widget.rememberMe,
                          ),
                        )
                      ],
                    ),
              widget.accountTitle == 'المستهلك'
                  ? Container()
                  : TextSignup(
                      text: AppLocalizations.of(context)
                          .translate('copy_of_trade_license')),
              widget.accountTitle == 'المستهلك'
                  ? Container()
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          image: const DecorationImage(
                              image: AssetImage("assets/images/logo.png"),
                              fit: BoxFit.cover)),
                    ),
              widget.accountTitle == 'المستهلك' ||
                      widget.accountTitle == 'جهة إخبارية'
                  ? Container()
                  : TextSignup(
                      text: AppLocalizations.of(context)
                          .translate('number_of_company_products')),
              widget.accountTitle == 'المستهلك' ||
                      widget.accountTitle == 'جهة إخبارية'
                  ? Container()
                  : TextFormSignupWidget(
                      password: false,
                      isNumber: false,
                      valid: (val) {
                        return null;

                        // return validInput(val!, 5, 100, "password");
                      },
                      myController: widget.companyProductsNumber,
                    ),
              widget.accountTitle == 'المستهلك' ||
                      widget.accountTitle == 'جهة إخبارية'
                  ? Container()
                  : TextSignup(
                      text:
                          AppLocalizations.of(context).translate('sell_method'),
                    ),
              widget.accountTitle == 'المستهلك' ||
                      widget.accountTitle == 'جهة إخبارية'
                  ? Container()
                  : TextFormSignupWidget(
                      password: false,
                      isNumber: false,
                      valid: (val) {
                        return null;

                        // return validInput(val!, 5, 100, "password");
                      },
                      myController: widget.sellType,
                    ),
              widget.accountTitle == 'المستهلك' ||
                      widget.accountTitle == 'جهة إخبارية'
                  ? Container()
                  : TextSignup(
                      text: AppLocalizations.of(context)
                          .translate('where_to_sell'),
                    ),
              widget.accountTitle == 'المستهلك' ||
                      widget.accountTitle == 'جهة إخبارية'
                  ? Container()
                  : TextFormSignupWidget(
                      password: false,
                      isNumber: false,
                      valid: (val) {
                        return null;

                        // return validInput(val!, 5, 100, "password");
                      },
                      myController: widget.toCountry,
                    ),
              TextSignup(
                text: AppLocalizations.of(context).translate('profile_photo'),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  addPhotoButton(
                      context: context,
                      text: 'add_from_camera',
                      onPressed: () {
                        getProfileImage(ImageSource.camera);
                      }),
                  addPhotoButton(
                      context: context,
                      text: 'add_from_gallery',
                      onPressed: () {
                        getProfileImage(ImageSource.gallery);
                      }),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              profileImage != null
                  ? Center(
                      child: Image.file(
                        profileImage!,
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
                height: 10.h,
              ),
              TextSignup(
                text: AppLocalizations.of(context).translate('cover_photo'),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  addPhotoButton(
                      context: context,
                      text: 'add_from_camera',
                      onPressed: () {
                        getCoverImage(ImageSource.camera);
                      }),
                  addPhotoButton(
                      context: context,
                      text: 'add_from_gallery',
                      onPressed: () {
                        getCoverImage(ImageSource.gallery);
                      }),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              coverImage != null
                  ? Center(
                      child: Image.file(
                        coverImage!,
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
              widget.accountTitle == 'المستهلك' ||
                      widget.accountTitle == 'جهة إخبارية'
                  ? Container()
                  : TextSignup(
                      text: AppLocalizations.of(context)
                          .translate('banner_photo'),
                    ),
              widget.accountTitle == 'المستهلك' ||
                      widget.accountTitle == 'جهة إخبارية'
                  ? Container()
                  : Column(
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            addPhotoButton(
                                context: context,
                                text: 'add_from_camera',
                                onPressed: () {
                                  getBanerImage(ImageSource.camera);
                                }),
                            addPhotoButton(
                                context: context,
                                text: 'add_from_gallery',
                                onPressed: () {
                                  getBanerImage(ImageSource.gallery);
                                }),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        banerImage != null
                            ? Center(
                                child: Image.file(
                                  banerImage!,
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
                      ],
                    ),
              SizedBox(
                height: 10.h,
              ),
              widget.accountTitle == 'المستهلك' ||
                      widget.accountTitle == 'جهة إخبارية'
                  ? Container()
                  : TextSignup(
                      text: AppLocalizations.of(context)
                          .translate('front_id_photo'),
                    ),
              widget.accountTitle == 'المستهلك' ||
                      widget.accountTitle == 'جهة إخبارية'
                  ? Container()
                  : Column(
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            addPhotoButton(
                                context: context,
                                text: 'add_from_camera',
                                onPressed: () {
                                  getFrontIdImage(
                                    ImageSource.camera,
                                  );
                                }),
                            addPhotoButton(
                                context: context,
                                text: 'add_from_gallery',
                                onPressed: () {
                                  getFrontIdImage(
                                    ImageSource.gallery,
                                  );
                                }),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        frontIdPhoto != null
                            ? Center(
                                child: Image.file(
                                  frontIdPhoto!,
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
                      ],
                    ),
              SizedBox(
                height: 10.h,
              ),
              widget.accountTitle == 'المستهلك' ||
                      widget.accountTitle == 'جهة إخبارية'
                  ? Container()
                  : TextSignup(
                      text: AppLocalizations.of(context)
                          .translate('back_id_photo'),
                    ),
              widget.accountTitle == 'المستهلك' ||
                      widget.accountTitle == 'جهة إخبارية'
                  ? Container()
                  : Column(
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            addPhotoButton(
                                context: context,
                                text: 'add_from_camera',
                                onPressed: () {
                                  getBackIdImage(
                                    ImageSource.camera,
                                  );
                                }),
                            addPhotoButton(
                                context: context,
                                text: 'add_from_gallery',
                                onPressed: () {
                                  getBackIdImage(
                                    ImageSource.gallery,
                                  );
                                }),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        backIdPhoto != null
                            ? Center(
                                child: Image.file(
                                  backIdPhoto!,
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
                      ],
                    ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                width: 100.w,
                // margin: EdgeInsets.symmetric(horizontal: 60, vertical: 10).r,
                margin:
                    const EdgeInsets.only(left: 60, right: 60, bottom: 20).r,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(250.0).w,
                  child: Container(
                    width: 100.w,
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
                      onPressed: () {
                        if (profileImage == null || coverImage == null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  AppLocalizations.of(context)
                                      .translate('no_image_selected'),
                                  style: const TextStyle(color: AppColor.red),
                                ),
                                content: Text(
                                  AppLocalizations.of(context).translate(
                                      'please_select_an_image_before_uploading'),
                                  style: const TextStyle(color: AppColor.red),
                                ),
                                actions: [
                                  ElevatedButton(
                                    child: Text(AppLocalizations.of(context)
                                        .translate('ok')),
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
                        final String userType = getUserType();
                        if (userType == 'local_company') {
                          if (frontIdPhoto == null || backIdPhoto == null) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    AppLocalizations.of(context)
                                        .translate('no_image_selected'),
                                    style: const TextStyle(color: AppColor.red),
                                  ),
                                  content: Text(
                                    AppLocalizations.of(context).translate(
                                        'please_select_an_front_and_back_Id_image_before_uploading'),
                                    style: const TextStyle(color: AppColor.red),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      child: Text(AppLocalizations.of(context)
                                          .translate('ok')),
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
                        }
                        if (!widget.formKey.currentState!.validate()) return;
                        widget.bloc.add(SignUpRequested(
                          username: widget.username.text,
                          email: widget.emailSignup.text,
                          password: widget.passwordSignup.text,
                          userType: userType,
                          firstMobile: widget.numberPhoneOne.text,
                          isFreeZoon: true,
                          deliverable: true,
                          profilePhoto: profileImage,
                          coverPhoto: coverImage,
                          banerPhoto: banerImage,
                          frontIdPhoto: frontIdPhoto,
                          backIdPhoto: backIdPhoto,
                          bio: widget.bioController.text,
                          description: widget.descriptionController.text,
                          website: widget.websiteController.text,
                        ));
                      },
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('create_new_account'),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 80.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getUserType() {
    switch (widget.accountTitle) {
      case 'المستهلك':
        return 'user';
      case 'الشركات المحلية':
        return 'local_company';
      case 'السيارات':
        return 'car';
      case 'الشركات البحرية':
        return 'sea_companies';
      case 'منطقة حرة':
        return 'freezoon';
      case 'المصانع':
        return 'factory';

      case 'جهة إخبارية':
        return 'news_agency';

      default:
        return 'user';
    }
  }
}
