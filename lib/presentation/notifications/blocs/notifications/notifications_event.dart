part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class GetAllNotificationsEvent extends NotificationsEvent {}

class SendNotificationEvent extends NotificationsEvent {
  final String fcmtoken;
  final String text;
  final String category;
  final String itemId;

  const SendNotificationEvent({
    required this.fcmtoken,
    required this.text,
    required this.category,
    required this.itemId,
  });
}

class GetUnreadNotificationsEvent extends NotificationsEvent {}

class MarkAllNotificationsAsReadEvent extends NotificationsEvent {}
