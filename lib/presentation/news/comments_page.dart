import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/news/entities/news_comment.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/news/widgets/comment_bottom_sheet.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../injection_container.dart';
import '../auth/blocs/auth_bloc/auth_bloc.dart';
import '../core/widgets/on_failure_widget.dart';
import 'blocs/comments/comments_bloc.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key, required this.newsId});
  final String newsId;
  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final commentBloc = sl<CommentsBloc>();
  final authBloc = sl<AuthBloc>();

  @override
  void initState() {
    super.initState();
    commentBloc.add(GetCommentsEvent(newsId: widget.newsId));
    authBloc.add(AuthCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text(
          AppLocalizations.of(context).translate('comments'),
          style: const TextStyle(color: AppColor.backgroundColor),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          commentBloc.add(GetCommentsEvent(newsId: widget.newsId));
        },
        color: AppColor.white,
        backgroundColor: AppColor.backgroundColor,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: BlocBuilder<CommentsBloc, CommentsState>(
              bloc: commentBloc,
              builder: (context, state) {
                if (state is CommentsInProgress) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.backgroundColor,
                    ),
                  );
                } else if (state is CommentsFailure) {
                  final failure = state.message;
                  return FailureWidget(
                    failure: failure,
                    onPressed: () {
                      commentBloc.add(GetCommentsEvent(newsId: widget.newsId));
                    },
                  );
                } else if (state is CommentsSuccess) {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.comments.length,
                          itemBuilder: (BuildContext context, index) {
                            if (state.comments.isEmpty) {
                              return Center(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('no_comments'),
                                  style: TextStyle(
                                    color: AppColor.backgroundColor,
                                    fontSize: 22.sp,
                                  ),
                                ),
                              );
                            }
                            return CommentWidget(
                              comment: state.comments[index],
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                    ],
                  );
                }
                return Container();
              },
            )),
      ),
      bottomSheet: BlocBuilder<AuthBloc, AuthState>(
        bloc: authBloc,
        builder: (context, authState) {
          if (authState is AuthInProgress) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.backgroundColor,
              ),
            );
          } else if (authState is Authenticated) {
            return CommentBottomSheet(
              commentBloc: commentBloc,
              newsId: widget.newsId,
            );
          }
          return const SizedBox(
            height: 1,
            width: 1,
          );
        },
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  const CommentWidget({
    super.key,
    required this.comment,
  });
  final NewsComment comment;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          comment.user.username ?? '',
          style: TextStyle(
              color: AppColor.backgroundColor,
              fontSize: 17.sp,
              fontWeight: FontWeight.bold),
        ),
        Text(
          comment.text,
          style: TextStyle(
            color: AppColor.backgroundColor,
            fontSize: 15.sp,
          ),
        ),
        const Divider()
      ],
    );
  }
}
