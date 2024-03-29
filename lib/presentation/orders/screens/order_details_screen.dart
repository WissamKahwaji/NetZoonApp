import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';

import '../../../domain/order/entities/my_order.dart';
import '../../utils/convert_date_to_string.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.order});
  final MyOrder order;
  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Details',
        ),
        backgroundColor: AppColor.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      'ORDER ID - ${widget.order.id}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.sp),
                    ),
                    Text(
                      'placed On ${formatDateTime(widget.order.createdAt ?? '')}',
                      style: TextStyle(
                          color: AppColor.secondGrey,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Text(
                'Shipping Address',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: AppColor.secondGrey,
                  ),
                  Text(
                    '${widget.order.shippingAddress}',
                    style: TextStyle(
                        color: AppColor.secondGrey,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                'Mobile Number',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.mobile_friendly_outlined,
                    color: Colors.greenAccent,
                  ),
                  Text(
                    '${widget.order.mobile}',
                    style: TextStyle(
                        color: AppColor.black,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              const Divider(),
              // Container(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Share your Experience',
              //         style: TextStyle(
              //             fontWeight: FontWeight.bold, fontSize: 15.sp),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(4.0),
              //         child: ListTile(
              //           title: const Text('Rate Seller Experience'),
              //           trailing: const Icon(Icons.arrow_forward_ios_sharp),
              //           tileColor: AppColor.backgroundColor.withOpacity(0.3),
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(4.0),
              //         child: ListTile(
              //           title: const Text('Rate delivery Experience'),
              //           trailing: const Icon(Icons.arrow_forward_ios_sharp),
              //           tileColor: AppColor.backgroundColor.withOpacity(0.3),
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(4.0),
              //         child: ListTile(
              //           title: const Text('Rate product Experience'),
              //           trailing: const Icon(Icons.arrow_forward_ios_sharp),
              //           tileColor: AppColor.backgroundColor.withOpacity(0.3),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // const Divider(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Products',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.order.products.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, indexx) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Card(
                          child: ListTile(
                            title: Text(
                              widget.order.products[indexx].product.name,
                              style: TextStyle(
                                  color: AppColor.backgroundColor,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 6.0),
                            subtitle: Text(
                              widget.order.products[indexx].product.description,
                              style: const TextStyle(
                                color: AppColor.secondGrey,
                              ),
                            ),
                            tileColor: AppColor.white,
                            leading: Container(
                              width: 100.w,
                              height: 300.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(widget
                                        .order
                                        .products[indexx]
                                        .product
                                        .imageUrl),
                                    fit: BoxFit.contain),
                              ),
                            ),
                            onTap: () {},
                            splashColor:
                                AppColor.backgroundColor.withOpacity(0.2),
                            trailing: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // if (state.categoryProducts[index].owner
                                      //         .userType ==
                                      //     'user') {
                                      //   Navigator.of(context).push(
                                      //       MaterialPageRoute(
                                      //           builder: (context) {
                                      //     return UsersProfileScreen(
                                      //         user: state
                                      //             .categoryProducts[index]
                                      //             .owner);
                                      //   }));
                                      // } else if (state.categoryProducts[index]
                                      //         .owner.userType ==
                                      //     'local_company') {
                                      //   Navigator.of(context).push(
                                      //       MaterialPageRoute(
                                      //           builder: (context) {
                                      //     return LocalCompanyProfileScreen(
                                      //         localCompany: state
                                      //             .categoryProducts[index]
                                      //             .owner);
                                      //   }));
                                      // }
                                    },
                                    child: Text(
                                      widget.order.products[indexx].product
                                              .owner.username ??
                                          '',
                                      style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: AppColor.colorOne),
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: AppColor.backgroundColor),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                ' ${widget.order.products[indexx].qty} * ${widget.order.products[indexx].product.priceAfterDiscount ?? widget.order.products[indexx].product.price}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: AppColor.red,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'AED',
                                            style: TextStyle(
                                                color: AppColor.red,
                                                fontSize: 12.sp),
                                          )
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Divider(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Summery',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                  ),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('subtotal'),
                              Text('${widget.order.subTotal}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('Service fee'),
                              Text('${widget.order.serviceFee}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Total ',
                                style: TextStyle(
                                  color: AppColor.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${widget.order.grandTotal}',
                                style: const TextStyle(
                                  color: AppColor.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
