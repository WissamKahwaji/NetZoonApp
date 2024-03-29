import 'dart:io';

import 'package:dio/dio.dart';
import 'package:netzoon/data/models/news/add_news/add_news_model.dart';
import 'package:netzoon/data/models/news/news/news_model.dart';
import 'package:netzoon/data/models/news/news_comment/news_comment_model.dart';
import 'package:retrofit/http.dart';
import '../../../../injection_container.dart';
import '../../../models/news/news_info/news_info_model.dart';

part 'news_remote_data_source.g.dart';

abstract class NewsRemoteDataSourse {
  Future<NewsModel> getAllNews();

  Future<NewsInfoModel> getNewsById(String id);

  Future<AddNewsModel> addNews(
    final String title,
    final String description,
    final String imgUrl,
    final String ownerName,
    final String ownerImage,
    final String creator,
  );

  Future<NewsInfoModel> editNews(
    final String id,
    final String title,
    final String description,
    final File? image,
    final String creator,
  );

  Future<String> deleteNews(
    final String id,
  );
  Future<List<NewsCommentModel>> getComments(
    final String newsId,
  );

  Future<String> addComment(
    final String newsId,
    final String userId,
    final String text,
  );

  Future<String> toggleOnLike(
    final String newsId,
    final String userId,
  );
  Future<List<NewsInfoModel>> getCompanyNews(final String id);
}

@RestApi(baseUrl: baseUrl)
abstract class NewsRemoteDataSourseImpl implements NewsRemoteDataSourse {
  factory NewsRemoteDataSourseImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 20),
      connectTimeout: const Duration(seconds: 20),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _NewsRemoteDataSourseImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/news')
  Future<NewsModel> getAllNews();

  @override
  @POST('/news/createNews')
  Future<AddNewsModel> addNews(
    @Part() String title,
    @Part() String description,
    @Part() String imgUrl,
    @Part() String ownerName,
    @Part() String ownerImage,
    @Part() String creator,
  );

  @override
  @PUT('/news/{id}')
  Future<NewsInfoModel> editNews(
    @Path('id') String id,
    @Field() String title,
    @Field() String description,
    @MultiPart() File? image,
    @Field() String creator,
  );

  @override
  @DELETE('/news/{id}')
  Future<String> deleteNews(
    @Path('id') String id,
  );

  @override
  @GET('/news/{newsId}/comments')
  Future<List<NewsCommentModel>> getComments(
    @Path() String newsId,
  );

  @override
  @POST('/news/{newsId}/comment')
  Future<String> addComment(
    @Path() String newsId,
    @Part() String userId,
    @Part() String text,
  );

  @override
  @POST('/news/{newsId}/toggleonlike')
  Future<String> toggleOnLike(
    @Path() String newsId,
    @Part() String userId,
  );

  @override
  @GET('/news/{id}')
  Future<NewsInfoModel> getNewsById(
    @Path() String id,
  );

  @override
  @GET('/news/companyNews/{id}')
  Future<List<NewsInfoModel>> getCompanyNews(
    @Path() String id,
  );
}
