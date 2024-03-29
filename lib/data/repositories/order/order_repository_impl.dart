import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:netzoon/data/models/order/my_order_model.dart';
import 'package:netzoon/domain/order/repositories/order_repository.dart';

import '../../../domain/core/error/failures.dart';
import '../../../domain/order/entities/my_order.dart';
import '../../../domain/order/entities/order_input.dart';
import '../../core/utils/network/network_info.dart';
import '../../datasource/remote/order/order_remote_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final NetworkInfo networkInfo;
  final OrderRemoteDataSource orderRemoteDataSource;

  OrderRepositoryImpl(
      {required this.networkInfo, required this.orderRemoteDataSource});
  @override
  Future<Either<Failure, List<MyOrder>>> getUserOrders(
      {required String userId}) async {
    try {
      if (await networkInfo.isConnected) {
        final orders = await orderRemoteDataSource.getUserOrders(userId);

        return Right(orders.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      print(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, MyOrder>> saveOrder({
    required String userId,
    required List<OrderInput> products,
    required String orderStatus,
    required double grandTotal,
    required final String? shippingAddress,
    required final String? mobile,
    required final double? subTotal,
    required final double? serviceFee,
  }) async {
    try {
      Dio dio = Dio();
      if (await networkInfo.isConnected) {
        // final requestData = {
        //   "products": [
        //     {"product": "64536be8bd73ddb6a0826902", "amount": 25, "qty": 2}
        //   ],
        //   "orderStatus": "pending",
        //   "grandTotal": 80
        // };
        final requestData = {
          "products": products.map((product) {
            return {
              "product": product.product,
              "amount": product.amount,
              "qty": product.qty,
            };
          }).toList(),
          "orderStatus": orderStatus,
          "grandTotal": grandTotal,
          'shippingAddress': shippingAddress,
          'mobile': mobile,
          'subTotal': subTotal,
          'serviceFee': serviceFee,
        };
        final requestDataJson = jsonEncode(requestData);
        final response = await dio.post(
            'https://net-zoon.onrender.com/order/save/$userId',
            data: requestDataJson);
        // Handle the response as needed
        if (response.statusCode == 200) {
          // Request was successful
          print("Order saved successfully!");
          final MyOrder order = MyOrder(
            id: response.data['_id'],
            userId: response.data['userId'],
            products: response.data['products'],
            grandTotal: grandTotal,
          );
          print(response.data);
          return Right(order);
        } else {
          print("Request failed with status code: ${response.statusCode}");
          return Left(response.data);
          // Handle other status codes if necessary
        }
        // final productsModelList = products
        //     .map(
        //       (input) => OrderInputModel(
        //         product: input.product,
        //         amount: input.amount,
        //         qty: input.qty,
        //       ),
        //     )
        //     .toList();
        // final result = await orderRemoteDataSource.saveOrder(
        //   userId,
        //   productsModelList,
        //   orderStatus,
        //   grandTotal,
        // );
        // return Right(result.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      print(e);
      return Left(ServerFailure());
    }
  }
}
