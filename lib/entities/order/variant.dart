import 'package:equatable/equatable.dart';

class Variant extends Equatable {
  final int id;
  final String productSlug;
  final String sku;
  final String consumerCategoryName;
  final int productId;
  final String productName;
  final String validityCategoryName;
  final String productCategoryName;
  final String productCategoryShortName;

  Variant(
      {required this.id,
      required this.productSlug,
      required this.sku,
      required this.productCategoryName,
      required this.productCategoryShortName,
      required this.productId,
      required this.productName,
      required this.consumerCategoryName,
      required this.validityCategoryName});
  @override
  List<Object?> get props => [id];

  factory Variant.fromJson({required Map<String, dynamic> json}) {
    var id = json['id'];
    var productSlug = json['product_slug'];
    var sku = json['sku'];
    var consumerCategoryName = json['consumer_category_name'];
    var productId = json['product_id'];
    var productName = json['product_name'];
    var validityCategoryName = json['validity_category_name'];
    var productCategoryName = json['product_category_name'];
    var productCategoryShortName = json['product_category_shortname'];

    return Variant(
        id: id,
        productSlug: productSlug,
        sku: sku,
        productCategoryName: productCategoryName,
        productId: productId,
        productName: productName,
        consumerCategoryName: consumerCategoryName,
        validityCategoryName: validityCategoryName,
        productCategoryShortName: productCategoryShortName);
  }
}
