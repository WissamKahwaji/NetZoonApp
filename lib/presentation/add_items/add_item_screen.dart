import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/add_items/add_product_screen.dart';
import 'package:netzoon/presentation/auth/screens/signin.dart';

import '../../injection_container.dart';
import '../advertising/add_ads_page.dart';
import '../auth/blocs/auth_bloc/auth_bloc.dart';
import '../categories/delivery_company/screens/add_service_screen.dart';
import '../categories/real_estate/screens/add_real_estate_screen.dart';
import '../categories/vehicles/screens/add_vehicle_screen.dart';
import '../core/constant/colors.dart';
import '../deals/add_deals_screen.dart';
import '../news/add_new_page.dart';
import '../profile/screens/all_product_screen.dart';
import '../utils/app_localizations.dart';
import 'add_company_service_screen.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final authBloc = sl<AuthBloc>();

  @override
  void initState() {
    authBloc.add(AuthCheckRequested());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.only(
              top: 20.0, bottom: 20, right: 8.0, left: 8.0),
          child: BlocBuilder<AuthBloc, AuthState>(
            bloc: authBloc,
            builder: (context, state) {
              if (state is AuthInProgress) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.backgroundColor,
                  ),
                );
              }
              if (state is Authenticated) {
                return Column(
                  children: [
                    Text(
                      AppLocalizations.of(context).translate(
                          'Choose the category you want to add to it'),
                      style: TextStyle(
                          color: AppColor.backgroundColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    state.user.userInfo.userType == 'user'
                        ? addWidget(
                            title: AppLocalizations.of(context)
                                .translate('select_from_our_products'),
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const AllProductsScreen();
                              }));
                            })
                        : const SizedBox(),

                    state.user.userInfo.userType == 'user'
                        ? const SizedBox()
                        : state.user.userInfo.userType == 'factory' ||
                                state.user.userInfo.userType ==
                                        'local_company' &&
                                    state.user.userInfo.isService == false ||
                                state.user.userInfo.isService == null
                            ? addWidget(
                                title: AppLocalizations.of(context)
                                    .translate('add_product'),
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return const AddProductScreen();
                                  }));
                                })
                            : const SizedBox(),
                    state.user.userInfo.userType == 'local_company' &&
                                state.user.userInfo.isService == true ||
                            state.user.userInfo.userType == 'factory'
                        // state.user.userInfo.userType == 'factory' &&
                        //     state.user.userInfo.isService == true
                        ? addWidget(
                            title: AppLocalizations.of(context)
                                .translate('add_service'),
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const AddCompanyServiceScreen();
                              }));
                            })
                        : const SizedBox(),

                    addWidget(
                        title:
                            AppLocalizations.of(context).translate('add_ads'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return const AddAdsPage();
                              },
                            ),
                          );
                        }),

                    addWidget(
                        title:
                            AppLocalizations.of(context).translate('add_deals'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return const AddDealScreen();
                              },
                            ),
                          );
                        }),

                    state.user.userInfo.userType == 'car'
                        ? addWidget(
                            title: AppLocalizations.of(context)
                                .translate('add_car'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const AddVehicleScreen(
                                      category: 'cars',
                                    );
                                  },
                                ),
                              );
                            })
                        : const SizedBox(),
                    state.user.userInfo.userType == 'planes'
                        ? addWidget(
                            title: AppLocalizations.of(context)
                                .translate('add_airplane'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const AddVehicleScreen(
                                      category: 'planes',
                                    );
                                  },
                                ),
                              );
                            })
                        : const SizedBox(),
                    state.user.userInfo.userType == 'real_estate'
                        ? addWidget(
                            title: AppLocalizations.of(context)
                                .translate('add_real_estate'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const AddRealEstateScreen();
                                  },
                                ),
                              );
                            })
                        : const SizedBox(),
                    // SizedBox(
                    //   height: 10.h,
                    // ),
                    // addWidget(
                    //     title: AppLocalizations.of(context)
                    //         .translate('add_tender'),
                    //     onTap: () {
                    //       Navigator.of(context)
                    //           .push(MaterialPageRoute(builder: (context) {
                    //         return const AddTenderScreen();
                    //       }));
                    //     }),

                    state.user.userInfo.userType == 'news_agency'
                        ? addWidget(
                            title: AppLocalizations.of(context)
                                .translate('add_news'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const AddNewScreen();
                                  },
                                ),
                              );
                            })
                        : const SizedBox(),
                    state.user.userInfo.userType == 'delivery_company'
                        ? addWidget(
                            title: AppLocalizations.of(context)
                                .translate('add_delivery_service'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const AddServiceScreen();
                                  },
                                ),
                              );
                            })
                        : const SizedBox(),
                  ],
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)
                          .translate('You must log in first'),
                      style: TextStyle(
                        color: AppColor.mainGrey,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            AppColor.backgroundColor,
                          ),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )),
                        ),
                        child: Text(
                            AppLocalizations.of(context).translate('login')),
                        onPressed: () async {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return const SignInScreen();
                          }));
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          )),
    );
  }

  Widget addWidget({required String title, void Function()? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: InkWell(
            onTap: onTap,
            child: Container(
              // alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),

              height: 60.h,
              width: double.infinity,
              color: AppColor.backgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 15.sp, color: AppColor.white),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: AppColor.white,
                    size: 20.sp,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
