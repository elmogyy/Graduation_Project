import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ennovation/models/product_model.dart';
import 'package:ennovation/services/firestore_services.dart';

import '../../../../consts/app_consts.dart';
import '../../../widgets/custom_background.dart';
import '../product/product_details_view.dart';

class SubCategoryDetailsView extends StatelessWidget {
  const SubCategoryDetailsView({Key? key, required this.title})
      : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      child: Scaffold(
        appBar: AppBar(
          title: title.tr.text.fontFamily(AppStyles.bold).make(),
          shadowColor: Colors.transparent,
          iconTheme: const IconThemeData(color: AppColors.whiteColor),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirestoreServices.getSubCategoryProducts(subCategory: title),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      mainAxisExtent: 230,
                    ),
                    itemBuilder: (context, index) {
                      ProductModel product = ProductModel.fromMap(
                          snapshot.data!.docs[index].data()
                              as Map<String, dynamic>);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: product.images[0],
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                              .box
                              .topRounded(value: 7.5)
                              .clip(Clip.antiAlias)
                              .make(),
                          const Spacer(),
                          product.name.text
                              .color(AppColors.darkFontGrey)
                              .fontFamily(AppStyles.semiBold)
                              .maxLines(2)
                              .ellipsis
                              .make(),
                          10.heightBox,
                          "${"EGP".tr} ${product.price}"
                              .text
                              .color(AppColors.redColor)
                              .fontFamily(AppStyles.bold)
                              .size(16)
                              .make(),
                        ],
                      )
                          .box
                          .white
                          .roundedSM
                          .shadowSm
                          .padding(const EdgeInsets.all(8))
                          .make()
                          .onInkTap(
                        () {
                          Get.to(() => ProductDetailsView(product: product));
                        },
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
    );
  }
}
