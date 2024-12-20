import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/controllers/auth_controller.dart';
import 'package:ecommerce_app/controllers/profile_controller.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/auth_screen/login_screen.dart';
import 'package:ecommerce_app/views/chat_screen/messaging_screen.dart';
import 'package:ecommerce_app/views/order_screen/orders_screen.dart';
import 'package:ecommerce_app/views/profice_screen/components/details-cart.dart';
import 'package:ecommerce_app/views/profice_screen/edit_profile_screen.dart';
import 'package:ecommerce_app/views/wishlist_screen/wishlist_screen.dart';
import 'package:ecommerce_app/widget_common/bg_widget.dart';
import 'package:ecommerce_app/widget_common/loading_indicator.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return bgWidget(
        child: Scaffold(
            body: StreamBuilder(
                stream: FirestoreServices.getUser(currentUser!.uid),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(redColor),
                      ),
                    );
                  } else {
                    var data = snapshot.data!.docs[0];
                    return SafeArea(
                        child: Column(
                      children: [
                        //Edit profile button
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                Icons.edit,
                                color: whiteColor,
                              )).onTap(() {
                            controller.nameController.text = data['name'];

                            Get.to(() => EditProfileScreen(data: data));
                          }),
                        ),
                        //user Section
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              data['imageUrl'] == ''
                                  ? Image.asset(
                                      imgProfile3,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    )
                                      .box
                                      .roundedFull
                                      .clip(Clip.antiAlias)
                                      .make()
                                  : Image.network(
                                      data['imageUrl'],
                                      width: 80,
                                      fit: BoxFit.cover,
                                    )
                                      .box
                                      .roundedFull
                                      .clip(Clip.antiAlias)
                                      .make(),
                              10.widthBox,
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  "${data['name']}"
                                      .text
                                      .fontFamily(semibold)
                                      .white
                                      .make(),
                                  "${data['email']}".text.white.make(),
                                ],
                              )),
                              OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      side:
                                          const BorderSide(color: whiteColor)),
                                  onPressed: () async {
                                    await Get.put(AuthController())
                                        .signoutMethod(context);
                                    Get.offAll(() => LoginScreen());
                                  },
                                  child: "Logout"
                                      .text
                                      .fontFamily(semibold)
                                      .white
                                      .make()),
                            ],
                          ),
                        ),
                        20.heightBox,

                        FutureBuilder(
                            future: FirestoreServices.getCounts(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return Center(child: loadingIndicator());
                              } else {
                                var countData = snapshot.data;
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    detailsCart(
                                        count: countData[0].toString(),
                                        title: "in your cart",
                                        width: context.screenWidth / 3.4),
                                    detailsCart(
                                        count: countData[1].toString(),
                                        title: "in your wishlist",
                                        width: context.screenWidth / 3.4),
                                    detailsCart(
                                        count: countData[2].toString(),
                                        title: " your orders",
                                        width: context.screenWidth / 3.4),
                                  ],
                                ).box.color(redColor).make();
                              }
                            }),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     detailsCart(
                        //         count: data['cart_count'],
                        //         title: "in your cart",
                        //         width: context.screenWidth / 3.4),
                        //     detailsCart(
                        //         count: data['wishlist_count'],
                        //         title: "in your wishlist",
                        //         width: context.screenWidth / 3.4),
                        //     detailsCart(
                        //         count: data['order_count'],
                        //         title: " your orders",
                        //         width: context.screenWidth / 3.4),
                        //   ],
                        // ).box.color(redColor).make(),

                        //button section

                        ListView.separated(
                                shrinkWrap: true,
                                separatorBuilder: (context, index) {
                                  return const Divider(
                                    color: lightGrey,
                                  );
                                },
                                itemCount: profileButtonsList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    onTap: () {
                                      switch (index) {
                                        case 0:
                                          Get.to(() => OrdersScreen());
                                          break;
                                        case 1:
                                          Get.to(() => WishlistScreen());
                                          break;
                                        case 2:
                                          Get.to(() => MessagingScreen());
                                          break;
                                      }
                                    },
                                    leading: Image.asset(
                                      profileButtonIcon[index],
                                      width: 22,
                                    ),
                                    title: profileButtonsList[index]
                                        .text
                                        .fontFamily(semibold)
                                        .color(darkFontGrey)
                                        .make(),
                                  );
                                })
                            .box
                            .white
                            .rounded
                            .margin(EdgeInsets.all(12))
                            .padding(EdgeInsets.symmetric(horizontal: 16))
                            .shadowSm
                            .make()
                            .box
                            .color(redColor)
                            .make(),
                      ],
                    ));
                  }
                })));
  }
}
