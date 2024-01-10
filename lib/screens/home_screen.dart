import 'package:apple_shop/bloc/categoryProduct/category_product_bloc.dart';
import 'package:apple_shop/bloc/home/home_bloc.dart';
import 'package:apple_shop/bloc/home/home_event.dart';
import 'package:apple_shop/bloc/home/home_state.dart';
import 'package:apple_shop/colors.dart';
import 'package:apple_shop/data/model/banner.dart';
import 'package:apple_shop/data/model/category.dart';
import 'package:apple_shop/data/model/product.dart';
import 'package:apple_shop/screens/product_list_screen.dart';
import 'package:apple_shop/widgets/banner_slider.dart';
import 'package:apple_shop/widgets/cached_image.dart';
import 'package:apple_shop/widgets/loading_animation.dart';
import 'package:apple_shop/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEEEEE),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return _getHomeScreenContent(state, context);
            },
          ),
        ),
      ),
    );
  }

  Widget _getHomeScreenContent(HomeState state, BuildContext context) {
    if (state is HomeLoadingState) {
      return const Center(
        child: LoadingAnimation(),
      );
    } else if (state is HomeResponseState) {
      return RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(HomeRequestList());
        },
        child: CustomScrollView(
          slivers: [
            const SliverPadding(padding: EdgeInsets.only(top: 24)),
            const _getSearchBox(),
            state.bannerList.fold((exceptionMessage) {
              return SliverToBoxAdapter(child: Text(exceptionMessage));
            }, (listBanners) {
              return _getBannerSlider(listBanners);
            }),
            const _getCategoryTitle(),
            state.categoryList.fold((exceptionMessage) {
              return SliverToBoxAdapter(child: Text(exceptionMessage));
            }, (categoryList) {
              return _getCategoryList(categoryList);
            }),
            const _getbestSellerTitle(),
            state.bestSellerProductList.fold((exceptionMessage) {
              return SliverToBoxAdapter(child: Text(exceptionMessage));
            }, (productList) {
              return _getbestSellerProducts(productList);
            }),
            const _getMostViewedTitle(),
            state.hotestProductList.fold((exceptionMessage) {
              return SliverToBoxAdapter(child: Text(exceptionMessage));
            }, (productList) {
              return _getMostViewedProducts(productList);
            }),
            const SliverPadding(padding: EdgeInsets.only(top: 24)),
          ],
        ),
      );
    } else {
      return const Center(
        child: Text('خطایی در دریافت اطلاعات به وجود آمده!'),
      );
    }
  }
}

class _getMostViewedProducts extends StatelessWidget {
  final List<Product> productList;
  _getMostViewedProducts(
    this.productList, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 250,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: productList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Productitem(productList[index]),
            );
          },
        ),
      ),
    );
  }
}

class _getMostViewedTitle extends StatelessWidget {
  const _getMostViewedTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 44, right: 44),
        child: Row(
          children: [
            Text(
              'پربازدید ترین ها',
              style: TextStyle(
                fontFamily: 'SB',
                fontSize: 12,
                color: CustomColor.grey,
              ),
            ),
            Spacer(),
            Text(
              'مشاهده همه',
              style: TextStyle(
                fontFamily: 'SB',
                fontSize: 12,
                color: CustomColor.blue,
              ),
            ),
            SizedBox(width: 10),
            Image.asset('assets/images/icon_left_categroy.png'),
          ],
        ),
      ),
    );
  }
}

class _getbestSellerProducts extends StatelessWidget {
  final List<Product> productList;
  _getbestSellerProducts(
    this.productList, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 250,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: productList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Productitem(productList[index]),
            );
          },
        ),
      ),
    );
  }
}

class _getbestSellerTitle extends StatelessWidget {
  const _getbestSellerTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 44, right: 44),
        child: Row(
          children: [
            Text(
              'پرفروش ترین ها',
              style: TextStyle(
                fontFamily: 'SB',
                fontSize: 12,
                color: CustomColor.grey,
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {},
              child: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'مشاهده همه',
                      style: TextStyle(
                        fontFamily: 'SB',
                        fontSize: 12,
                        color: CustomColor.blue,
                      ),
                    ),
                    SizedBox(width: 10),
                    Image.asset('assets/images/icon_left_categroy.png'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _getCategoryList extends StatelessWidget {
  final List<Category> categorylist;
  _getCategoryList(
    this.categorylist, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categorylist.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: CategoryHorizontalitemList(categorylist[index]),
            );
          },
        ),
      ),
    );
  }
}

class _getCategoryTitle extends StatelessWidget {
  const _getCategoryTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, bottom: 20, left: 44, right: 44),
        child: Row(
          children: [
            Text(
              'دسته بندی ها',
              style: TextStyle(
                fontFamily: 'SB',
                fontSize: 12,
                color: CustomColor.grey,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class _getBannerSlider extends StatelessWidget {
  final List<BannerCamper> bannercamper;
  _getBannerSlider(this.bannercamper, {super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BannerSlider(bannercamper),
    );
  }
}

class _getSearchBox extends StatelessWidget {
  const _getSearchBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(top: 10, left: 44, right: 44, bottom: 32),
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Image.asset('assets/images/icon_search.png'),
                SizedBox(width: 10),
                Text(
                  'جستجوی محصول',
                  style: TextStyle(
                    fontFamily: 'SM',
                    fontSize: 16,
                    color: CustomColor.grey,
                  ),
                ),
                Spacer(),
                Image.asset('assets/images/icon_apple_blue.png'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryHorizontalitemList extends StatelessWidget {
  final Category categort;
  //List<Product> productList;
  CategoryHorizontalitemList(
    this.categort,
    //this.productList,
    {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String categoryColor = 'ff${categort.color}';
    int hexColer = int.parse(categoryColor, radix: 16);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: ((contex) => CategoryProductBloc()),
              child: ProductListScreen(categort),
            ),
          ),
        );
      },
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: ShapeDecoration(
                    color: Color(hexColer),
                    shadows: [
                      BoxShadow(
                        color: Color(hexColer),
                        blurRadius: 30,
                        spreadRadius: -10,
                        offset: Offset(0, 15),
                      )
                    ],
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    )),
              ),
              SizedBox(
                height: 24,
                width: 24,
                child: Center(
                  child: CachedImage(imageUrl: categort.icon),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            categort.title ?? '',
            style: TextStyle(
              fontFamily: 'SB',
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
