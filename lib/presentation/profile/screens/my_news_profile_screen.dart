import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/profile/screens/visitors_screen.dart';

import '../../../domain/news/entities/news_comment.dart';
import '../../../injection_container.dart';
import '../../chat/screens/chat_home_screen.dart';
import '../../core/constant/colors.dart';
import '../../core/widgets/screen_loader.dart';
import '../../home/test.dart';
import '../../news/blocs/news/news_bloc.dart';
import '../../news/comments_page.dart';
import '../../news/news_details.dart';
import '../../utils/app_localizations.dart';
import '../../utils/convert_date_to_string.dart';
import '../blocs/add_account/add_account_bloc.dart';
import '../blocs/get_user/get_user_bloc.dart';
import '../methods/show_change_account_bottom_sheet.dart';
import '../widgets/rounded_icon_text.dart';
import '../widgets/top_profile.dart';
import 'credits_screen.dart';
import 'edit_local_company_profile_screen.dart';
import 'followings_list_screen.dart';

class MyNewsProfileScreen extends StatefulWidget {
  final String userId;
  const MyNewsProfileScreen({super.key, required this.userId});

  @override
  State<MyNewsProfileScreen> createState() => _MyNewsProfileScreenState();
}

class _MyNewsProfileScreenState extends State<MyNewsProfileScreen>
    with TickerProviderStateMixin, ScreenLoader<MyNewsProfileScreen> {
  final double coverHeight = 240.h;
  final double profileHeight = 104.h;
  final userBloc = sl<GetUserBloc>();
  final getAccountsBloc = sl<AddAccountBloc>();
  final newsBloc = sl<NewsBloc>();

  @override
  void initState() {
    userBloc.add(GetUserByIdEvent(userId: widget.userId));
    newsBloc.add(GetCompanyNewsEvent(id: widget.userId));
    super.initState();
  }

  @override
  Widget screen(BuildContext context) {
    final TabController tabController = TabController(length: 2, vsync: this);
    final top = 80.h;
    return RefreshIndicator(
      onRefresh: () async {
        userBloc.add(GetUserByIdEvent(userId: widget.userId));
        newsBloc.add(GetCompanyNewsEvent(id: widget.userId));
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
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ));
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
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
                              buildTop(
                                  top,
                                  state.userInfo.coverPhoto ?? '',
                                  state.userInfo.profilePhoto ?? '',
                                  profileHeight,
                                  context),
                              changeAccountText(
                                  context: context,
                                  state: state,
                                  getAccountsBloc: getAccountsBloc),
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
                                    // roundedIconText(
                                    //   context: context,
                                    //   text: state.userInfo.userType == 'car'
                                    //       ? 'sold_cars'
                                    //       : 'sold_airplanes',
                                    //   icon: Icons.production_quantity_limits,
                                    // ),
                                    // roundedIconText(
                                    //   context: context,
                                    //   text: 'Recovered products',
                                    //   icon: Icons.reset_tv_rounded,
                                    // ),
                                    roundedIconText(
                                        context: context,
                                        text: 'NetZoon Credits',
                                        icon: Icons.wallet_outlined,
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return const CreditScreen();
                                          }));
                                        }),
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
                                            who: 'me',
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
                                            who: 'me',
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
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return const VisitorsScreen();
                                        }));
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${state.userInfo.profileViews ?? 0}',
                                            style: TextStyle(
                                              color: AppColor.mainGrey,
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            AppLocalizations.of(context)
                                                .translate('visitors'),
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
                            text:
                                AppLocalizations.of(context).translate('news'),
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
                                userBloc.add(
                                    GetUserByIdEvent(userId: widget.userId));
                                newsBloc.add(
                                    GetCompanyNewsEvent(id: widget.userId));
                              },
                              color: AppColor.white,
                              backgroundColor: AppColor.backgroundColor,
                              child: ListView(
                                children: [
                                  Column(
                                    children: [
                                      titleAndInput(
                                          title: AppLocalizations.of(context)
                                              .translate('company_name'),
                                          input: state.userInfo.username ?? ''),
                                      titleAndInput(
                                          title: AppLocalizations.of(context)
                                              .translate('email'),
                                          input: state.userInfo.email ?? ''),
                                      titleAndInput(
                                          title: AppLocalizations.of(context)
                                              .translate('mobile'),
                                          input:
                                              state.userInfo.firstMobile ?? ''),
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
                                newsBloc.add(
                                    GetCompanyNewsEvent(id: widget.userId));
                              },
                              color: AppColor.white,
                              backgroundColor: AppColor.backgroundColor,
                              child: BlocBuilder<NewsBloc, NewsState>(
                                bloc: newsBloc,
                                builder: (context, state) {
                                  if (state is NewsInProgress) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColor.backgroundColor,
                                      ),
                                    );
                                  } else if (state is NewsFailure) {
                                    final failure = state.message;
                                    return Center(
                                      child: Text(
                                        failure,
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    );
                                  } else if (state is GetCompanyNewsSuccess) {
                                    return state.news.isNotEmpty
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: state.news.length,
                                            itemBuilder:
                                                (BuildContext context, index) {
                                              return SizedBox(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 240.h,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                              return NewsDetails(
                                                                news:
                                                                    state.news[
                                                                        index],
                                                              );
                                                            }),
                                                          );
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25.0),
                                                          child: Card(
                                                            child: Stack(
                                                              children: [
                                                                Positioned(
                                                                  left: 0,
                                                                  bottom: 0,
                                                                  top: 0,
                                                                  right: 0,
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl: state
                                                                        .news[
                                                                            index]
                                                                        .imgUrl,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    progressIndicatorBuilder: (context,
                                                                            url,
                                                                            downloadProgress) =>
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              70.0,
                                                                          vertical:
                                                                              50),
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        value: downloadProgress
                                                                            .progress,
                                                                        color: AppColor
                                                                            .backgroundColor,

                                                                        // strokeWidth: 10,
                                                                      ),
                                                                    ),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        const Icon(
                                                                            Icons.error),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  bottom: 0,
                                                                  left: 0,
                                                                  right: 0,
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    color: AppColor
                                                                        .backgroundColor,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Text(
                                                                          convertDateToString(state.news[index].createdAt ??
                                                                              ''),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                12.sp,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 5),
                                                                          height:
                                                                              50.h,
                                                                          child:
                                                                              Text(
                                                                            state.news[index].title,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 13.sp,
                                                                              color: Colors.white,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 5),
                                                                          height:
                                                                              30.h,
                                                                          child:
                                                                              Text(
                                                                            state.news[index].description,
                                                                            style:
                                                                                const TextStyle(
                                                                              color: AppColor.white,
                                                                            ),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            maxLines:
                                                                                1,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${state.news[index].likes?.length} Likes',
                                                            style:
                                                                const TextStyle(
                                                              color: AppColor
                                                                  .secondGrey,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5.h,
                                                          ),
                                                          Text(
                                                            getCommentText(state
                                                                .news[index]
                                                                .comments),
                                                            style:
                                                                const TextStyle(
                                                              color: AppColor
                                                                  .secondGrey,
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) {
                                                                  return CommentsPage(
                                                                    newsId: state
                                                                            .news[index]
                                                                            .id ??
                                                                        '',
                                                                  );
                                                                }),
                                                              );
                                                            },
                                                            child: Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .translate(
                                                                      'View All Comments'),
                                                              style:
                                                                  const TextStyle(
                                                                color: AppColor
                                                                    .secondGrey,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5.h,
                                                          ),
                                                          Text(
                                                            convertDateToString(state
                                                                    .news[index]
                                                                    .createdAt ??
                                                                ''),
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            })
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
                      const SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  String getCommentText(List<NewsComment>? comments) {
    if (comments == null || comments.isEmpty) {
      return 'No comments';
    } else if (comments.length == 1) {
      return AppLocalizations.of(context).translate('1 comment');
    } else {
      return '${comments.length} ${AppLocalizations.of(context).translate('comments')}';
    }
  }
}
