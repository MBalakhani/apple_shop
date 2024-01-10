import 'dart:ui';
import 'package:apple_shop/bloc/basket/baset_event.dart';
import 'package:apple_shop/bloc/basket/basket_bloc.dart';
import 'package:apple_shop/bloc/comment/comment_bloc.dart';
import 'package:apple_shop/bloc/product/product_bloc.dart';
import 'package:apple_shop/bloc/product/product_event.dart';
import 'package:apple_shop/bloc/product/product_state.dart';
import 'package:apple_shop/colors.dart';

import 'package:apple_shop/data/model/product.dart';
import 'package:apple_shop/data/model/product_image.dart';
import 'package:apple_shop/data/model/product_peroperty.dart';
import 'package:apple_shop/data/model/product_variant.dart';
import 'package:apple_shop/data/model/variant.dart';
import 'package:apple_shop/data/model/variant_type.dart';
import 'package:apple_shop/di/di.dart';
import 'package:apple_shop/util/extenstions/double_extenstions.dart';
import 'package:apple_shop/widgets/cached_image.dart';
import 'package:apple_shop/widgets/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class productDitailScreen extends StatefulWidget {
  final Product product;
  productDitailScreen(this.product, {super.key});

  @override
  State<productDitailScreen> createState() => _productDitailScreenState();
}

class _productDitailScreenState extends State<productDitailScreen> {
  @override
  void initState() {
    BlocProvider.of<ProductBloc>(context).add(
        ProductInitializeEvent(widget.product.id, widget.product.categoryId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) {
        var bloc = ProductBloc();
        bloc.add(ProductInitializeEvent(
            widget.product.id, widget.product.categoryId));
        return bloc;
      }),
      child: DetailScreenContent(
        ParentWidget: widget,
      ),
    );
  }
}

class DetailScreenContent extends StatelessWidget {
  final productDitailScreen ParentWidget;
  const DetailScreenContent({
    super.key,
    required this.ParentWidget,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEEEEE),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: ((context, State) {
          if (State is ProductDetailLoadingState) {
            return const Center(
              child: LoadingAnimation(),
            );
          } else if (State is ProductDetailResponseState) {
            return SafeArea(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 10, left: 44, right: 44, bottom: 32),
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
                              Image.asset('assets/images/icon_apple_blue.png'),
                              Expanded(
                                  child: State.productCategory.fold((l) {
                                return Text(
                                  'مشخصات محصول',
                                  style: TextStyle(
                                    fontFamily: 'SM',
                                    fontSize: 16,
                                    color: CustomColor.blue,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              }, (r) {
                                return Text(
                                  r.title!,
                                  style: TextStyle(
                                    fontFamily: 'SM',
                                    fontSize: 16,
                                    color: CustomColor.blue,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              })),
                              Image.asset('assets/images/icon_back.png'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        ParentWidget.product.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'sb',
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  State.productImages.fold((l) {
                    return SliverToBoxAdapter(
                      child: Text(l),
                    );
                  }, (r) {
                    return GalleryWidget(ParentWidget.product.thumbnail, r);
                  }),
                  State.productVariant.fold((l) {
                    return SliverToBoxAdapter(
                      child: Text(l),
                    );
                  }, (variantList) {
                    return VariantContainerGenerator(variantList);
                  }),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 44),
                      child: Column(
                        children: [
                          State.productProperties.fold((l) {
                            return SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.only(top: 24),
                                child: Container(
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 1,
                                      color: CustomColor.grey,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            'assets/images/icon_left_categroy.png'),
                                        SizedBox(width: 6),
                                        Text(
                                          'مشاهده',
                                          style: TextStyle(
                                            fontFamily: 'sm',
                                            fontSize: 13,
                                            color: CustomColor.blue,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          ':مشخصات فنی',
                                          style: TextStyle(
                                            fontFamily: 'sm',
                                            fontSize: 13,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }, (r) {
                            return productProperties(r);
                          }),
                          ProductDescription(ParentWidget.product.description),
                          ProductComments(ParentWidget.product.id),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AddtobasketBotton(ParentWidget.product),
                        Pricetag(ParentWidget.product),
                      ],
                    ),
                  ),
                  SliverPadding(padding: EdgeInsets.only(bottom: 25)),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('خطایی در دریافت اطلاعات به وجود آمده!'),
            );
          }
        }),
      ),
    );
  }
}

class ProductComments extends StatelessWidget {
  final String productID;

  ProductComments(
    this.productID, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24, bottom: 30),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            useSafeArea: true,
            showDragHandle: true,
            backgroundColor: CustomColor.backgroundColor,
            builder: (context) {
              return BlocProvider(
                create: (context) {
                  final bloc = CommentBloc(locator.get());
                  bloc.add(CommentInitilzeEvent(productID));
                  return bloc;
                },
                child: CommentBottomSheet(productID),
              );
            },
          );
        },
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1,
              color: CustomColor.grey,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Image.asset('assets/images/icon_left_categroy.png'),
                SizedBox(width: 6),
                Text(
                  'مشاهده',
                  style: TextStyle(
                    fontFamily: 'sm',
                    fontSize: 13,
                    color: CustomColor.blue,
                  ),
                ),
                Spacer(),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 26,
                      width: 26,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Image.asset('assets/images/avatar.png'),
                    ),
                    Positioned(
                      right: 15,
                      child: Container(
                        height: 26,
                        width: 26,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Image.asset('assets/images/avatar.png'),
                      ),
                    ),
                    Positioned(
                      right: 30,
                      child: Container(
                        height: 26,
                        width: 26,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Image.asset('assets/images/avatar.png'),
                      ),
                    ),
                    Positioned(
                      right: 45,
                      child: Container(
                        height: 26,
                        width: 26,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Image.asset('assets/images/avatar.png'),
                      ),
                    ),
                    Positioned(
                      right: 60,
                      child: Container(
                        height: 26,
                        width: 26,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Center(
                          child: Text(
                            '+10',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'sb',
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Text(
                  ':نظرات کاربران',
                  style: TextStyle(
                    fontFamily: 'sm',
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CommentBottomSheet extends StatelessWidget {
  CommentBottomSheet(
    this.productId, {
    super.key,
  });
  final String productId;
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        if (state is CommentLoading) {
          return Center(
            child: LoadingAnimation(),
          );
        }
        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  if (state is CommentResponse) ...{
                    state.response.fold(
                      (l) {
                        return SliverToBoxAdapter(
                          child: Text('خطایی در نمایش نظرات به وجود آمده'),
                        );
                      },
                      (r) {
                        if (r.isEmpty) {
                          return SliverToBoxAdapter(
                            child: Center(
                              child: Text(
                                'نظری برای این محصول ثبت نشده',
                                style:
                                    TextStyle(fontFamily: 'sm', fontSize: 14),
                              ),
                            ),
                          );
                        }
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            (r[index].username.isEmpty)
                                                ? 'کاربر'
                                                : r[index].username,
                                            style: const TextStyle(
                                                fontFamily: 'sm', fontSize: 16),
                                            textAlign: TextAlign.end,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            r[index].text,
                                            style: TextStyle(
                                                fontFamily: 'sm', fontSize: 14),
                                            textAlign: TextAlign.end,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: (r[index].avatar.isNotEmpty)
                                          ? CachedImage(
                                              imageUrl:
                                                  r[index].userThumbnailUrl,
                                            )
                                          : Image.asset(
                                              'assets/images/avatar.png'),
                                    )
                                  ],
                                ),
                              );
                            },
                            childCount: r.length,
                          ),
                        );
                      },
                    ),
                  }
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        labelText: 'نظر خود را وارد کنید',
                        labelStyle: TextStyle(
                          fontSize: 15,
                          fontFamily: 'sm',
                          color: Colors.black45,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                            color: Colors.black45,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                            width: 3,
                            color: CustomColor.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      height: 55,
                      width: 195,
                      decoration: BoxDecoration(
                        color: CustomColor.blue,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: GestureDetector(
                          onTap: () {
                            if (textController.text.isEmpty) {
                              return;
                              //show error
                              //dialog
                              //snackbar
                              //toast
                            }
                            context.read<CommentBloc>().add(
                                  CommentPostEvent(
                                      productId, textController.text),
                                );

                            textController.text = '';
                          },
                          child: Container(
                            height: 53,
                            width: 200,
                            child: Center(
                              child: Text(
                                'افزودن نظر به محصول',
                                style: TextStyle(
                                  fontFamily: 'sb',
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class productProperties extends StatefulWidget {
  final List<Property> propertyList;
  productProperties(
    this.propertyList, {
    super.key,
  });

  @override
  State<productProperties> createState() => _productPropertiesState();
}

class _productPropertiesState extends State<productProperties> {
  bool _isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isVisible = !_isVisible;
          });
        },
        child: Column(
          children: [
            Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1,
                  color: CustomColor.grey,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Image.asset('assets/images/icon_left_categroy.png'),
                    SizedBox(width: 6),
                    Text(
                      'مشاهده',
                      style: TextStyle(
                        fontFamily: 'sm',
                        fontSize: 13,
                        color: CustomColor.blue,
                      ),
                    ),
                    Spacer(),
                    Text(
                      ':مشخصات فنی',
                      style: TextStyle(
                        fontFamily: 'sm',
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Visibility(
              visible: _isVisible,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 1,
                    color: CustomColor.grey,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.propertyList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var property = widget.propertyList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Flexible(
                        child: Text(
                          '${property.value} : ${property.title}',
                          style: TextStyle(
                            fontFamily: 'sm',
                            fontSize: 16,
                            color: Colors.black,
                            height: 1.8,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDescription extends StatefulWidget {
  final String productDescription;
  ProductDescription(
    this.productDescription, {
    super.key,
  });

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool _isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isVisible = !_isVisible;
          });
        },
        child: Column(
          children: [
            Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1,
                  color: CustomColor.grey,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Image.asset('assets/images/icon_left_categroy.png'),
                    SizedBox(width: 6),
                    Text(
                      'مشاهده',
                      style: TextStyle(
                        fontFamily: 'sm',
                        fontSize: 13,
                        color: CustomColor.blue,
                      ),
                    ),
                    Spacer(),
                    Text(
                      ':توضیحات محصول',
                      style: TextStyle(
                        fontFamily: 'sm',
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Visibility(
              visible: _isVisible,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 1,
                    color: CustomColor.grey,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    widget.productDescription,
                    style: TextStyle(
                      fontFamily: 'sm',
                      fontSize: 16,
                      color: Colors.black,
                      height: 1.8,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VariantContainerGenerator extends StatelessWidget {
  final List<ProductVarint> ProductVarintList;
  VariantContainerGenerator(
    this.ProductVarintList, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Column(
      children: [
        for (var productVariant in ProductVarintList) ...{
          if (productVariant.variantList.isNotEmpty) ...{
            VariantGeneratorChild(productVariant),
          }
        }
      ],
    ));
  }
}

class VariantGeneratorChild extends StatelessWidget {
  final ProductVarint productVarint;
  VariantGeneratorChild(this.productVarint, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 44, right: 44, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            productVarint.variantType.title!,
            style: TextStyle(
              fontFamily: 'sm',
              fontSize: 14,
            ),
          ),
          SizedBox(height: 10),
          if (productVarint.variantType.type == VariantTypeEnum.COLOR) ...{
            ColorVariantList(productVarint.variantList),
          },
          if (productVarint.variantType.type == VariantTypeEnum.STORAGE) ...{
            StorageVariantList(productVarint.variantList),
          },
        ],
      ),
    );
  }
}

class GalleryWidget extends StatefulWidget {
  final List<ProductImage> productImagesList;
  String? DefaultProductThumbnail;
  int selectedItem = 0;
  GalleryWidget(
    this.DefaultProductThumbnail,
    this.productImagesList, {
    super.key,
  });

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 44),
        child: Container(
          height: 264,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/icon_star.png'),
                      Text(
                        '4.6',
                        style: TextStyle(
                          fontFamily: 'sm',
                          fontSize: 14,
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: CachedImage(
                          imageUrl: (widget.productImagesList.isEmpty)
                              ? widget.DefaultProductThumbnail
                              : widget.productImagesList[widget.selectedItem]
                                  .imageUrl,
                          radius: 15,
                        ),
                      ),
                      Spacer(),
                      Image.asset('assets/images/icon_favorite_deactive.png'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (widget.productImagesList.isNotEmpty) ...{
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.productImagesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.selectedItem = index;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 20),
                          height: 80,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 1,
                              color: CustomColor.grey,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: CachedImage(
                              imageUrl:
                                  widget.productImagesList[index].imageUrl,
                              radius: 10,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              },
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AddtobasketBotton extends StatelessWidget {
  final Product product;
  AddtobasketBotton(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 55,
          width: 155,
          decoration: BoxDecoration(
              color: CustomColor.blue,
              borderRadius: BorderRadius.all(Radius.circular(15))),
        ),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: GestureDetector(
              onTap: () {
                context.read<ProductBloc>().add(ProductAddToBasket(product));
                context.read<BasketBloc>().add(BasketFetchFromHiveEvent());
              },
              child: Container(
                height: 53,
                width: 160,
                child: Center(
                  child: Text(
                    'افزودن به سبد خرید',
                    style: TextStyle(
                      fontFamily: 'sb',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class Pricetag extends StatelessWidget {
  final Product product;
  const Pricetag(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 55,
          width: 155,
          decoration: BoxDecoration(
              color: CustomColor.green,
              borderRadius: BorderRadius.all(Radius.circular(15))),
        ),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 53,
              width: 160,
              child: Center(
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Text(
                      'تومان',
                      style: TextStyle(
                        fontFamily: 'SM',
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.price.convertToPrice(),
                          style: TextStyle(
                            fontFamily: 'SM',
                            fontSize: 12,
                            color: Colors.white,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Text(
                          product.realPrice.convertToPrice(),
                          style: TextStyle(
                            fontFamily: 'SM',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        color: Colors.red,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        child: Text(
                          '%${product.persent!.round().toString()}',
                          style: TextStyle(
                            fontFamily: 'SB',
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ColorVariantList extends StatefulWidget {
  final List<Variant> variantList;

  ColorVariantList(this.variantList, {super.key});

  @override
  State<ColorVariantList> createState() => _ColorVariantListState();
}

class _ColorVariantListState extends State<ColorVariantList> {
  int selectedindex = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 26,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.variantList.length,
          itemBuilder: (BuildContext context, int index) {
            String colors = 'ff${widget.variantList[index].value}';
            int hexcolor = int.parse(colors, radix: 16);
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedindex = index;
                });
              },
              child: AnimatedContainer(
                duration: Duration(microseconds: 500),
                margin: EdgeInsets.only(left: 10),
                height: 26,
                width: (index == selectedindex) ? 65 : 26,
                decoration: BoxDecoration(
                  color: Color(hexcolor),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: AnimatedScale(
                  scale: (index == selectedindex) ? 1 : 0,
                  duration: Duration(microseconds: 500),
                  child: Center(
                    child: Text(
                      widget.variantList[index].name!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'sm',
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class StorageVariantList extends StatefulWidget {
  List<Variant> storageVariantList;
  StorageVariantList(this.storageVariantList, {super.key});

  @override
  State<StorageVariantList> createState() => _StorageVariantListState();
}

class _StorageVariantListState extends State<StorageVariantList> {
  int selectedindex = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 26,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.storageVariantList.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedindex = index;
                });
              },
              child: Container(
                margin: EdgeInsets.only(left: 10),
                height: 26,
                width: 74,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: (selectedindex == index)
                      ? Border.all(
                          width: 2,
                          color: CustomColor.blue,
                        )
                      : Border.all(
                          width: 1,
                          color: CustomColor.grey,
                        ),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    widget.storageVariantList[index].value!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'sm',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
