import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/departments/entities/departments_categories/departments_categories.dart';
import 'package:netzoon/presentation/ecommerce/screens/subsection_screen.dart';

class ListofItems extends StatefulWidget {
  const ListofItems({
    super.key,
    // required this.devices,
    required this.elec,
    required this.filter,
  });

  // final List<ElectronicDevice> devices;
  final List<DepartmentsCategories> elec;
  final String filter;
  @override
  State<ListofItems> createState() => _ListofItemsState();
}

class _ListofItemsState extends State<ListofItems> {
  String backendHost = 'http://10.0.2.2:5000';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: widget.elec.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.30,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(1000)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return SubSectionsScreen(
                          category: widget.elec[index].name,
                          filter: widget.filter,
                        );
                      }));
                    },
                    child: Container(
                      decoration:
                          const BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 151,
                            spreadRadius: 300,
                            offset: Offset(10, 30))
                      ]),
                      height: 300.h,
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: widget.elec[index].imageUrl,
                            fit: BoxFit.contain,
                            height: MediaQuery.of(context).size.height,
                            // placeholder: (context, url) =>
                            //     CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 35.h,
                              color: const Color(0xFF5776a5).withOpacity(0.8),
                              alignment: Alignment.center,
                              child: Text(
                                widget.elec[index].name,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
