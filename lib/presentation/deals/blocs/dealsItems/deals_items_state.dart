part of 'deals_items_bloc.dart';

abstract class DealsItemsState extends Equatable {
  const DealsItemsState();

  @override
  List<Object> get props => [];
}

class DealsItemsInitial extends DealsItemsState {}

class DealsItemsInProgress extends DealsItemsState {}

class DealsItemsSuccess extends DealsItemsState {
  final List<DealsItems> dealsItems;

  const DealsItemsSuccess({required this.dealsItems});
}

class DealsItemsFailure extends DealsItemsState {
  final String message;

  const DealsItemsFailure({required this.message});
}

class AddDealSuccess extends DealsItemsState {
  final String message;

  const AddDealSuccess({required this.message});
}

class GetDealByIdSuccess extends DealsItemsState {
  final DealsItems deal;

  const GetDealByIdSuccess({required this.deal});
}
