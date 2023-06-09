import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/electronic_devices/entities/device_list.dart';

class WatchesList extends Equatable {
  final String name;
  final String imgUrl;
  final List<ItemList> deviceList;

  const WatchesList(
      {required this.name, required this.imgUrl, required this.deviceList});
  @override
  List<Object?> get props => [name, imgUrl, deviceList];
}
