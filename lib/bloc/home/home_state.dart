import 'package:apple_shop/data/model/category.dart';
import 'package:apple_shop/data/model/product.dart';

import 'package:dartz/dartz.dart';

import '../../data/model/banner.dart';

abstract class HomeState {}

class HomeInitState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeResponseState extends HomeState {
  Either<String, List<BannerCamper>> bannerList;
  Either<String, List<Category>> categoryList;
  Either<String, List<Product>> productList;
  Either<String, List<Product>> hotestProductList;
  Either<String, List<Product>> bestSellerProductList;

  HomeResponseState(
    this.bannerList,
    this.categoryList,
    this.productList,
    this.hotestProductList,
    this.bestSellerProductList,
  );
}
