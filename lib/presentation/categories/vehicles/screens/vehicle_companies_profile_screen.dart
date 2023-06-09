import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/categories/vehicles/blocs/bloc/vehicle_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/core/constants/constants.dart';
import '../../../../data/models/auth/user/user_model.dart';
import '../../../../domain/auth/entities/user_info.dart';
import '../../../../injection_container.dart';
import '../../../auth/blocs/auth_bloc/auth_bloc.dart';
import '../../../core/constant/colors.dart';
import '../../../core/widgets/vehicle_details.dart';
import '../../../profile/blocs/get_user/get_user_bloc.dart';
import '../../../utils/app_localizations.dart';
import '../../widgets/build_rating.dart';

class VehicleCompaniesProfileScreen extends StatefulWidget {
  const VehicleCompaniesProfileScreen(
      {super.key, required this.vehiclesCompany});
  final UserInfo vehiclesCompany;
  @override
  State<VehicleCompaniesProfileScreen> createState() =>
      _VehicleCompaniesProfileScreenState();
}

class _VehicleCompaniesProfileScreenState
    extends State<VehicleCompaniesProfileScreen> {
  final bloc = sl<VehicleBloc>();
  final authBloc = sl<AuthBloc>();
  final userBloc = sl<GetUserBloc>();

  bool isFollowing = false;

  @override
  void initState() {
    bloc.add(GetCompanyVehiclesEvent(
        type: widget.vehiclesCompany.userType ?? '',
        id: widget.vehiclesCompany.id));
    authBloc.add(AuthCheckRequested());
    checkFollowStatus();
    super.initState();
  }

  void checkFollowStatus() async {
    bool followStatus = await isFollow(widget.vehiclesCompany.id);
    setState(() {
      isFollowing = followStatus;
    });
  }

  Future<bool> isFollow(element) async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(SharedPreferencesKeys.user)) {
      return false;
    }

    final user = UserModel.fromJson(
      json.decode(prefs.getString(SharedPreferencesKeys.user)!)
          as Map<String, dynamic>,
    );
    final isFollow = user.userInfo.followings?.contains(element);
    return isFollow ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.vehiclesCompany.username ?? '',
          style: const TextStyle(color: AppColor.backgroundColor),
        ),
        backgroundColor: AppColor.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColor.backgroundColor,
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 160.h,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppColor.secondGrey.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.vehiclesCompany.coverPhoto ??
                                'https://img.freepik.com/free-vector/hand-painted-watercolor-pastel-sky-background_23-2148902771.jpg?w=2000',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        widget.vehiclesCompany.profilePhoto ??
                                            '',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.vehiclesCompany.username ?? '',
                                    style: TextStyle(
                                      color: AppColor.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  GestureDetector(
                                    onTap: () => showRating(context),
                                    child: RatingBar.builder(
                                      minRating: 1,
                                      maxRating: 5,
                                      initialRating: 4,
                                      itemSize: 25,
                                      ignoreGestures: true,
                                      itemBuilder: (context, _) {
                                        return const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        );
                                      },
                                      allowHalfRating: true,
                                      updateOnDrag: true,
                                      onRatingUpdate: (rating) {},
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  BlocBuilder<AuthBloc, AuthState>(
                                    bloc: authBloc,
                                    builder: (context, state) {
                                      if (state is AuthInProgress) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColor.backgroundColor,
                                          ),
                                        );
                                      } else if (state is Authenticated) {
                                        // isFollowing = state.user
                                        //         .userInfo.followings!
                                        //         .contains(widget
                                        //             .localCompany.id)
                                        //     ? true
                                        //     : false;
                                        return ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    AppColor.backgroundColor),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                            )),
                                          ),
                                          child: Text(
                                            isFollowing
                                                ? AppLocalizations.of(context)
                                                    .translate('unfollow')
                                                : AppLocalizations.of(context)
                                                    .translate('follow'),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              isFollowing = !isFollowing;
                                            });
                                            userBloc.add(ToggleFollowEvent(
                                                otherUserId:
                                                    widget.vehiclesCompany.id));
                                          },
                                        );
                                      }
                                      return Container();
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 14.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            widget.vehiclesCompany.bio ?? '',
                            style: const TextStyle(color: AppColor.mainGrey),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Material(
                  color: AppColor.white,
                  child: TabBar(
                    labelColor: AppColor.backgroundColor,
                    unselectedLabelColor: AppColor.secondGrey.withOpacity(0.4),
                    indicatorWeight: 1,
                    indicatorColor: AppColor.backgroundColor,
                    tabs: [
                      Tab(
                        icon: Text(
                          AppLocalizations.of(context)
                              .translate(widget.vehiclesCompany.userType ?? ''),
                        ),
                      ),
                      Tab(
                        icon: Text(
                            AppLocalizations.of(context).translate('about_us')),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      RefreshIndicator(
                        onRefresh: () async {
                          bloc.add(GetCompanyVehiclesEvent(
                              type: widget.vehiclesCompany.userType ?? '',
                              id: widget.vehiclesCompany.id));
                        },
                        color: AppColor.white,
                        backgroundColor: AppColor.backgroundColor,
                        child: BlocBuilder<VehicleBloc, VehicleState>(
                          bloc: bloc,
                          builder: (context, state) {
                            if (state is VehicleInProgress) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.backgroundColor,
                                ),
                              );
                            } else if (state is VehicleFailure) {
                              final failure = state.message;
                              return Center(
                                child: Text(
                                  failure,
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              );
                            } else if (state is GetCompanyVehiclesSuccess) {
                              return state.companyVehicles.isNotEmpty
                                  ? GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 0.95,
                                              crossAxisSpacing: 10.w,
                                              mainAxisSpacing: 10.h),
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: state.companyVehicles.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          decoration: BoxDecoration(
                                              color: AppColor.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColor.secondGrey
                                                      .withOpacity(0.5),
                                                  blurRadius: 10,
                                                  spreadRadius: 2,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ]),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return VehicleDetailsScreen(
                                                          vehicle: state
                                                                  .companyVehicles[
                                                              index]);
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: state
                                                        .companyVehicles[index]
                                                        .imageUrl,
                                                    height: 120.h,
                                                    width: 200.w,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 9.0,
                                                            left: 9.0,
                                                            bottom: 8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          state
                                                              .companyVehicles[
                                                                  index]
                                                              .name,
                                                          style:
                                                              const TextStyle(
                                                            color: AppColor
                                                                .backgroundColor,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${state.companyVehicles[index].price} \$',
                                                          style:
                                                              const TextStyle(
                                                            color: AppColor
                                                                .colorTwo,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Center(
                                      child: Text(
                                          AppLocalizations.of(context)
                                              .translate('no_items'),
                                          style: const TextStyle(
                                              color: AppColor.backgroundColor)),
                                    );
                            }
                            return Container();
                          },
                        ),
                      ),
                      ListView(
                        children: [
                          Column(
                            children: [
                              titleAndInput(
                                  title: AppLocalizations.of(context)
                                      .translate('company_name'),
                                  input: widget.vehiclesCompany.username ?? ''),
                              titleAndInput(
                                  title: AppLocalizations.of(context)
                                      .translate('desc'),
                                  input:
                                      widget.vehiclesCompany.description ?? ''),
                              titleAndInput(
                                  title: AppLocalizations.of(context)
                                      .translate('Bio'),
                                  input: widget.vehiclesCompany.bio ?? ''),
                              titleAndInput(
                                  title: AppLocalizations.of(context)
                                      .translate('mobile'),
                                  input: widget.vehiclesCompany.firstMobile ??
                                      ';'),
                              titleAndInput(
                                  title: AppLocalizations.of(context)
                                      .translate('email'),
                                  input: widget.vehiclesCompany.email ?? ''),
                              titleAndInput(
                                  title: AppLocalizations.of(context)
                                      .translate('website'),
                                  input: widget.vehiclesCompany.website ?? ''),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding titleAndInput({required String title, required String input}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // height: 40.h,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.4),
              width: 1.0,
            ),
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(
                width: 190,
                child: Text(
                  input,
                  style: TextStyle(
                    color: AppColor.mainGrey,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
