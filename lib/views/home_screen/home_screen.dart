//import 'dart:ui_web';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/category_screen/item_details.dart';
import 'package:ecommerce_app/views/home_screen/components/featured_button.dart';
import 'package:ecommerce_app/views/home_screen/search_screen.dart';
import 'package:ecommerce_app/widget_common/home_button.dart';
import 'package:ecommerce_app/widget_common/loading_indicator.dart';
import 'package:get/get.dart';

import '../../consts/lists.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();
    return Container(
      padding: const EdgeInsets.all(12),
      color: lightGrey,
      width: context.screenWidth,
      height: context.screenHeight,
      child: SafeArea(
          child: Column(children: [
        Container(
          alignment: Alignment.center,
          height: 60,
          color: lightGrey,
          child: TextFormField(
            controller: controller.searchController,
            decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: Icon(Icons.search).onTap(() {
                  if (controller.searchController.text.isNotEmptyAndNotNull) {
                    Get.to(() => SearchScreen(
                          title: controller.searchController.text,
                        ));
                  }
                }),
                filled: true,
                fillColor: whiteColor,
                hintText: searchanything,
                hintStyle: TextStyle(
                  color: textfieldGrey,
                )),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                //Swiper  brands
                VxSwiper.builder(
                    aspectRatio: 16 / 9,
                    autoPlay: true,
                    height: 160,
                    enlargeCenterPage: true,
                    itemCount: sliderList.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        sliderList[index],
                        fit: BoxFit.fill,
                      )
                          .box
                          .rounded
                          .clip(Clip.antiAlias)
                          .margin(EdgeInsets.symmetric(horizontal: 8))
                          .make();
                    }),
                20.heightBox,

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                      2,
                      (index) => homeButtos(
                            width: context.screenWidth / 2.5,
                            height: context.screenHeight * 0.12,
                            icon: index == 0 ? icTodaysDeal : icFlashDeal,
                            title: index == 0 ? todayDeal : flashsale,
                          )),
                ),
                20.heightBox,
                // 2nd Swiper  brands
                VxSwiper.builder(
                    aspectRatio: 16 / 9,
                    autoPlay: true,
                    height: 160,
                    enlargeCenterPage: true,
                    itemCount: SecondSliderList.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        SecondSliderList[index],
                        fit: BoxFit.fill,
                      )
                          .box
                          .rounded
                          .clip(Clip.antiAlias)
                          .margin(EdgeInsets.symmetric(horizontal: 8))
                          .make();
                    }),
                20.heightBox,

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                      3,
                      (index) => homeButtos(
                            width: context.screenWidth / 3.5,
                            height: context.screenHeight * 0.12,
                            icon: index == 0
                                ? icTopCategories
                                : index == 1
                                    ? icBrands
                                    : icTopCategories,
                            title: index == 0
                                ? topCategories
                                : index == 1
                                    ? brand
                                    : topSeller,
                          )),
                ),

                //feature Category
                20.heightBox,

                Align(
                  alignment: Alignment.centerLeft,
                  child: featuredCategories.text
                      .color(darkFontGrey)
                      .size(20)
                      .fontFamily(semibold)
                      .make(),
                ),
                20.heightBox,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                        3,
                        (index) => Column(
                              children: [
                                featuredButton(
                                    icon: featuredImages1[index],
                                    title: featuredTitiles1[index]),
                                10.heightBox,
                                featuredButton(
                                    icon: featuredImages2[index],
                                    title: featuredTitiles2[index]),
                              ],
                            )).toList(),
                  ),
                ),

                //feature product
                20.heightBox,
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: redColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      featuredProduct.text.white
                          .fontFamily(bold)
                          .size(18)
                          .make(),
                      10.heightBox,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: FutureBuilder(
                            future: FirestoreServices.getFeaturedProducts(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: loadingIndicator(),
                                );
                              } else if (snapshot.data!.docs.isEmpty) {
                                return "No featured products"
                                    .text
                                    .white
                                    .makeCentered();
                              } else {
                                var featuredData = snapshot.data!.docs;
                                return Row(
                                  children: List.generate(
                                      featuredData.length,
                                      (index) => Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.network(
                                                featuredData[index]['p_img'][0],
                                                width: 130,
                                                height: 130,
                                                fit: BoxFit.cover,
                                              ),
                                              10.heightBox,
                                              "${featuredData[index]['name']}"
                                                  .text
                                                  .fontFamily(semibold)
                                                  .color(darkFontGrey)
                                                  .make(),
                                              10.heightBox,
                                              "${featuredData[index]['p_price']} "
                                                  .numCurrency
                                                  .text
                                                  .color(redColor)
                                                  .size(16)
                                                  .make(),
                                            ],
                                          )
                                              .box
                                              .white
                                              .margin(EdgeInsets.symmetric(
                                                  horizontal: 6))
                                              .roundedSM
                                              .padding(EdgeInsets.all(8))
                                              .make()
                                              .onTap(() {
                                            Get.to(() => ItemDetails(
                                                  title:
                                                      "${featuredData[index]['name']}",
                                                  data: featuredData[index],
                                                ));
                                          })),
                                );
                              }
                            }),
                      )
                    ],
                  ),
                ),
                20.heightBox,
                //Third Soper
                VxSwiper.builder(
                    aspectRatio: 16 / 9,
                    autoPlay: true,
                    height: 160,
                    enlargeCenterPage: true,
                    itemCount: SecondSliderList.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        SecondSliderList[index],
                        fit: BoxFit.fill,
                      )
                          .box
                          .rounded
                          .clip(Clip.antiAlias)
                          .margin(EdgeInsets.symmetric(horizontal: 8))
                          .make();
                    }),
                20.heightBox,

                StreamBuilder(
                    stream: FirestoreServices.allproducts(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return loadingIndicator();
                      } else {
                        var allproductsdata = snapshot.data!.docs;
                        return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: allproductsdata.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    mainAxisExtent: 300),
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    allproductsdata[index]['p_img'][0],
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  const Spacer(),
                                  "${allproductsdata[index]['name']}"
                                      .text
                                      .fontFamily(semibold)
                                      .color(darkFontGrey)
                                      .make(),
                                  10.heightBox,
                                  "${allproductsdata[index]['p_price']} "
                                      .text
                                      .color(redColor)
                                      .size(16)
                                      .make(),
                                ],
                              )
                                  .box
                                  .white
                                  .margin(EdgeInsets.symmetric(horizontal: 6))
                                  .roundedSM
                                  .padding(EdgeInsets.all(8))
                                  .make()
                                  .onTap(() {
                                Get.to(() => ItemDetails(
                                      title:
                                          "${allproductsdata[index]['name']}",
                                      data: allproductsdata[index],
                                    ));
                              });
                            });
                      }
                    }),
              ],
            ),
          ),
        )
      ])),
    );
  }
}
