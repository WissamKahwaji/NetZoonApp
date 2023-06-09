part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class NewsInProgress extends NewsState {}

class NewsSuccess extends NewsState {
  final List<News> news;
  final User? currentUser;
  const NewsSuccess({
    required this.news,
    this.currentUser,
  });

  @override
  List<Object> get props => [news, currentUser!];
}

class NewsFailure extends NewsState {
  final String message;

  const NewsFailure({required this.message});
}

class ToggleonlikeSuccess extends NewsState {}

class GetNewsByIdSuccess extends NewsState {
  final News news;

  const GetNewsByIdSuccess({required this.news});
}

class GetCompanyNewsSuccess extends NewsState {
  final List<News> news;

  const GetCompanyNewsSuccess({required this.news});
}
