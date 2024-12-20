import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/controllers/product_controller.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/category_screen/item_details.dart';
import 'package:ecommerce_app/widget_common/bg_widget.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/widget_common/loading_indicator.dart';
import 'package:get/get.dart';

class CategoryDetails extends StatefulWidget {
  final String? title;
  const CategoryDetails({super.key, required this.title});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    switchCategory(widget.title);
  }

  switchCategory(title) {
    if (controller.subcat.contains(title)) {
      productMethod = FirestoreServices.getSubCategoryProducts(title);
    } else {
      productMethod = FirestoreServices.getProducts(title);
    }
  }

  var controller = Get.find<ProductController>();

  dynamic productMethod;

  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
            appBar: AppBar(
              title: widget.title!.text.fontFamily(bold).white.make(),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                        controller.subcat.length,
                        (index) => "${controller.subcat[index]}"
                                .text
                                .size(14)
                                .fontFamily(semibold)
                                .color(darkFontGrey)
                                .makeCentered()
                                .box
                                .white
                                .roundedSM
                                .size(120, 60)
                                .margin(
                                    const EdgeInsets.symmetric(horizontal: 4))
                                .make()
                                .onTap(() {
                              switchCategory("${controller.subcat[index]}");
                            })),
                  ),
                ),
                20.heightBox,
                StreamBuilder(
                    stream: productMethod,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: loadingIndicator(),
                        );
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Expanded(
                          child: "No products found!"
                              .text
                              .color(darkFontGrey)
                              .makeCentered(),
                        );
                      } else {
                        var data = snapshot.data!.docs;
                        return
                            //item Container
                            Expanded(
                                child: GridView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: data.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisExtent: 250,
                                            mainAxisSpacing: 8,
                                            crossAxisSpacing: 8),
                                    itemBuilder: (context, index) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                            data[index]['p_img'][0],
                                            width: 200,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),
                                          "${data[index]['p_name']}"
                                              .text
                                              .fontFamily(semibold)
                                              .color(const Color.fromARGB(
                                                  255, 75, 189, 247))
                                              .make(),
                                          10.heightBox,
                                          "${data[index]['p_price']}"
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
                                          .outerShadowSm
                                          .padding(EdgeInsets.all(8))
                                          .make()
                                          .onTap(() {
                                        controller.checkIfFav(data[index]);
                                        Get.to(() => ItemDetails(
                                              title: "${data[index]['p_name']}",
                                              data: data[index],
                                            ));
                                      });
                                    }));
                      }
                    }),
              ],
            )));
  }
}
