import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../injection_container.dart';
import '../../categories/vehicles/blocs/bloc/vehicle_bloc.dart';
import '../../chat/screens/chat_home_screen.dart';
import '../../core/constant/colors.dart';
import '../../core/widgets/on_failure_widget.dart';
import '../../core/widgets/screen_loader.dart';
import '../../core/widgets/vehicle_details.dart';
import '../../home/test.dart';
import '../../utils/app_localizations.dart';
import '../blocs/add_account/add_account_bloc.dart';
import '../blocs/get_user/get_user_bloc.dart';
import '../widgets/rounded_icon_text.dart';
import 'add_account_screen.dart';
import 'edit_local_company_profile_screen.dart';
import 'followings_list_screen.dart';

class MyVehicleProfileScreen extends StatefulWidget {
  final String userId;
  final String type;
  const MyVehicleProfileScreen(
      {super.key, required this.userId, required this.type});

  @override
  State<MyVehicleProfileScreen> createState() => _MyVehicleProfileScreenState();
}

class _MyVehicleProfileScreenState extends State<MyVehicleProfileScreen>
    with TickerProviderStateMixin, ScreenLoader<MyVehicleProfileScreen> {
  final double coverHeight = 240.h;
  final double profileHeight = 104.h;
  final userBloc = sl<GetUserBloc>();
  final getAccountsBloc = sl<AddAccountBloc>();
  final bloc = sl<VehicleBloc>();

  @override
  void initState() {
    userBloc.add(GetUserByIdEvent(userId: widget.userId));
    bloc.add(GetCompanyVehiclesEvent(type: widget.type, id: widget.userId));
    super.initState();
  }

  @override
  Widget screen(BuildContext context) {
    final TabController tabController = TabController(length: 2, vsync: this);
    final top = 80.h;
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            userBloc.add(GetUserByIdEvent(userId: widget.userId));
            bloc.add(
                GetCompanyVehiclesEvent(type: widget.type, id: widget.userId));
          },
          color: AppColor.white,
          backgroundColor: AppColor.backgroundColor,
          child: BlocBuilder<GetUserBloc, GetUserState>(
            bloc: userBloc,
            builder: (context, state) {
              if (state is GetUserInProgress) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.backgroundColor,
                  ),
                );
              } else if (state is GetUserFailure) {
                final failure = state.message;
                return Center(
                  child: Text(
                    failure,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                );
              } else if (state is GetUserSuccess) {
                return BlocListener<AddAccountBloc, AddAccountState>(
                  bloc: getAccountsBloc,
                  listener: (context, changeAccountstate) {
                    if (changeAccountstate is OnChangeAccountInProgress) {
                      startLoading();
                    } else if (changeAccountstate is OnChangeAccountFailure) {
                      stopLoading();

                      final failure = changeAccountstate.message;
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
                    } else if (changeAccountstate is OnChangeAccountSuccess) {
                      stopLoading();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          AppLocalizations.of(context).translate('success'),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ));
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                              CupertinoPageRoute(builder: (context) {
                        return const TestScreen();
                      }), (route) => false);
                    }
                  },
                  child: DefaultTabController(
                    length: 2,
                    child: NestedScrollView(
                      headerSliverBuilder: (context, _) {
                        return [
                          SliverList(
                            delegate: SliverChildListDelegate([
                              Column(
                                children: [
                                  buildTop(top, state.userInfo.coverPhoto ?? '',
                                      state.userInfo.profilePhoto ?? ''),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          state.userInfo.username ?? '',
                                          style: TextStyle(
                                            fontSize: 22.sp,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.black,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            getAccountsBloc
                                                .add(GetUserAccountsEvent());
                                            showModalBottomSheet(
                                              context: context,
                                              backgroundColor:
                                                  AppColor.backgroundColor,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(30),
                                                ),
                                              ),
                                              builder: (context) {
                                                return SizedBox(
                                                  height: 300.h,
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          top: 24.0,
                                                          bottom: 4.0,
                                                        ),
                                                        child: Container(
                                                          width: 75,
                                                          height: 7,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Color(
                                                                0xFFC6E2DD),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 6.0,
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: BlocBuilder<
                                                              AddAccountBloc,
                                                              AddAccountState>(
                                                            bloc:
                                                                getAccountsBloc,
                                                            builder: (context,
                                                                accountstate) {
                                                              if (accountstate
                                                                  is GetUserAccountsInProgress) {
                                                                return const Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    color: AppColor
                                                                        .white,
                                                                  ),
                                                                );
                                                              } else if (accountstate
                                                                  is GetUserAccountsFailure) {
                                                                final failure =
                                                                    accountstate
                                                                        .message;
                                                                return FailureWidget(
                                                                  failure:
                                                                      failure,
                                                                  onPressed:
                                                                      () {
                                                                    getAccountsBloc
                                                                        .add(
                                                                            GetUserAccountsEvent());
                                                                  },
                                                                );
                                                              } else if (accountstate
                                                                  is GetUserAccountsSuccess) {
                                                                return SingleChildScrollView(
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            height:
                                                                                40,
                                                                            width:
                                                                                40,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: AppColor.backgroundColor,
                                                                              image: DecorationImage(
                                                                                image: CachedNetworkImageProvider(
                                                                                  // ignore: unnecessary_type_check
                                                                                  state.userInfo.profilePhoto!,
                                                                                ),
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(100),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10.w,
                                                                          ),
                                                                          Text(
                                                                            state.userInfo.username ??
                                                                                '',
                                                                            style:
                                                                                const TextStyle(
                                                                              color: AppColor.white,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                          const Spacer(),
                                                                          Radio<
                                                                              int>(
                                                                            value:
                                                                                0,
                                                                            groupValue:
                                                                                0,
                                                                            onChanged:
                                                                                (int? value) {
                                                                              // Handle radio button selection
                                                                            },
                                                                            activeColor:
                                                                                AppColor.white,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20.h,
                                                                      ),
                                                                      ListView
                                                                          .builder(
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount: accountstate
                                                                            .users
                                                                            .length,
                                                                        scrollDirection:
                                                                            Axis.vertical,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(vertical: 4.0),
                                                                            child:
                                                                                accountWidget(
                                                                              accountstate: accountstate,
                                                                              index: index,
                                                                              onTap: () {
                                                                                getAccountsBloc.add(
                                                                                  OnChangeAccountEvent(
                                                                                    email: accountstate.users[index].email!,
                                                                                    password: accountstate.users[index].password!,
                                                                                  ),
                                                                                );
                                                                              },
                                                                              onChanged: (int? val) {
                                                                                getAccountsBloc.add(
                                                                                  OnChangeAccountEvent(
                                                                                    email: accountstate.users[index].email!,
                                                                                    password: accountstate.users[index].password!,
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20.h,
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .push(
                                                                            MaterialPageRoute(
                                                                              builder: (context) {
                                                                                return const AddAccountScreen();
                                                                              },
                                                                            ),
                                                                          );
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Container(
                                                                              height: 40,
                                                                              width: 40,
                                                                              decoration: BoxDecoration(
                                                                                color: AppColor.white,
                                                                                borderRadius: BorderRadius.circular(100),
                                                                              ),
                                                                              child: const Icon(
                                                                                Icons.add,
                                                                                color: AppColor.backgroundColor,
                                                                                size: 30,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10.w,
                                                                            ),
                                                                            Text(
                                                                              AppLocalizations.of(context).translate('add_account'),
                                                                              style: const TextStyle(
                                                                                color: AppColor.white,
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              }
                                                              return Container();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: const Icon(
                                              Icons.keyboard_arrow_down_sharp),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  const Divider(),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        roundedIconText(
                                          context: context,
                                          text: state.userInfo.userType == 'car'
                                              ? 'sold_cars'
                                              : 'sold_airplanes',
                                          icon:
                                              Icons.production_quantity_limits,
                                        ),
                                        // roundedIconText(
                                        //   context: context,
                                        //   text: 'Recovered products',
                                        //   icon: Icons.reset_tv_rounded,
                                        // ),
                                        roundedIconText(
                                            context: context,
                                            text: 'chat',
                                            icon: Icons.chat,
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return const ChatHomeScreen();
                                              }));
                                            }),
                                        roundedIconText(
                                            context: context,
                                            text: 'edit_profile',
                                            icon: Icons.edit,
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return EditLocalCompanyprofileScreen(
                                                    userInfo: state.userInfo);
                                              }));
                                            }),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return const FollowingsListScreen(
                                                type: 'followings',
                                              );
                                            }));
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${state.userInfo.followings?.length}',
                                                style: TextStyle(
                                                  color: AppColor.mainGrey,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)
                                                    .translate('Followings'),
                                                style: TextStyle(
                                                    color: AppColor.secondGrey,
                                                    fontSize: 15.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return const FollowingsListScreen(
                                                type: 'followers',
                                              );
                                            }));
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${state.userInfo.followers?.length}',
                                                style: TextStyle(
                                                  color: AppColor.mainGrey,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)
                                                    .translate('Followers'),
                                                style: TextStyle(
                                                    color: AppColor.secondGrey,
                                                    fontSize: 15.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    color: AppColor.secondGrey,
                                    thickness: 0.2,
                                    indent: 30,
                                    endIndent: 30,
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        ];
                      },
                      body: Column(
                        children: [
                          TabBar(
                            controller: tabController,
                            labelColor: AppColor.backgroundColor,
                            unselectedLabelColor: AppColor.secondGrey,
                            // isScrollable: true,

                            tabs: [
                              Tab(
                                text: AppLocalizations.of(context)
                                    .translate('about_us'),
                              ),
                              Tab(
                                text: state.userInfo.userType == 'car'
                                    ? AppLocalizations.of(context)
                                        .translate('cars')
                                    : AppLocalizations.of(context)
                                        .translate('planes'),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: tabController,
                              children: [
                                RefreshIndicator(
                                  onRefresh: () async {
                                    userBloc.add(GetUserByIdEvent(
                                        userId: widget.userId));
                                    bloc.add(GetCompanyVehiclesEvent(
                                        type: widget.type, id: widget.userId));
                                  },
                                  color: AppColor.white,
                                  backgroundColor: AppColor.backgroundColor,
                                  child: ListView(
                                    children: [
                                      Column(
                                        children: [
                                          titleAndInput(
                                              title: AppLocalizations.of(
                                                      context)
                                                  .translate('company_name'),
                                              input: state.userInfo.username ??
                                                  ''),
                                          titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate('email'),
                                              input:
                                                  state.userInfo.email ?? ''),
                                          titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate('mobile'),
                                              input:
                                                  state.userInfo.firstMobile ??
                                                      ''),
                                          // titleAndInput(
                                          //   title: AppLocalizations.of(context)
                                          //       .translate('Is there delivery'),
                                          //   input: state.userInfo.deliverable!
                                          //       ? AppLocalizations.of(context)
                                          //           .translate('Yes')
                                          //       : AppLocalizations.of(context)
                                          //           .translate('No'),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                RefreshIndicator(
                                  onRefresh: () async {
                                    bloc.add(GetCompanyVehiclesEvent(
                                        type: widget.type, id: widget.userId));
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
                                      } else if (state
                                          is GetCompanyVehiclesSuccess) {
                                        return state.companyVehicles.isNotEmpty
                                            ? GridView.builder(
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2,
                                                        childAspectRatio: 0.95,
                                                        crossAxisSpacing: 10.w,
                                                        mainAxisSpacing: 10.h),
                                                shrinkWrap: true,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemCount: state
                                                    .companyVehicles.length,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 8),
                                                    decoration: BoxDecoration(
                                                        color: AppColor.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: AppColor
                                                                .secondGrey
                                                                .withOpacity(
                                                                    0.5),
                                                            blurRadius: 10,
                                                            spreadRadius: 2,
                                                            offset:
                                                                const Offset(
                                                                    0, 3),
                                                          ),
                                                        ]),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  20)),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) {
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
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            CachedNetworkImage(
                                                              imageUrl: state
                                                                  .companyVehicles[
                                                                      index]
                                                                  .imageUrl,
                                                              height: 120.h,
                                                              width: 200.w,
                                                              fit: BoxFit.cover,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          9.0,
                                                                      left: 9.0,
                                                                      bottom:
                                                                          8.0),
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
                                                        color: AppColor
                                                            .backgroundColor)),
                                              );
                                      }
                                      return Container();
                                    },
                                  ),
                                ),
                              ],
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
              return Container();
            },
          )),
    );
  }

  Stack buildTop(double top, String coverUrl, String profileUrl) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: profileHeight / 2),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              // color: AppColor.backgroundColor,
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    coverUrl,
                  ),
                  fit: BoxFit.contain),
            ),
          ),
        ),
        Positioned(
          top: top,
          child: CircleAvatar(
            radius: profileHeight / 2,
            backgroundColor: Colors.grey.shade800,
            backgroundImage: CachedNetworkImageProvider(profileUrl),
          ),
        ),
      ],
    );
  }

  Widget accountWidget(
      {required GetUserAccountsSuccess accountstate,
      required int index,
      void Function()? onTap,
      required void Function(int?)? onChanged}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: AppColor.backgroundColor,
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      accountstate.users[index].profilePhoto ??
                          'https://pbs.twimg.com/media/FjU2lkcWYAgNG6d.jpg',
                    ),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(100)),
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            accountstate.users[index].username ?? '',
            style: const TextStyle(
                color: AppColor.white,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Radio<int>(
            value: 1,
            groupValue: 0,
            onChanged: onChanged,
            activeColor: AppColor.white,
          ),
        ],
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
