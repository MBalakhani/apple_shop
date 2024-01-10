import 'package:apple_shop/bloc/basket/basket_bloc.dart';
import 'package:apple_shop/colors.dart';
import 'package:apple_shop/data/model/product.dart';
import 'package:apple_shop/di/di.dart';
import 'package:apple_shop/screens/product_ditail_screen.dart';
import 'package:apple_shop/util/extenstions/double_extenstions.dart';
import 'package:apple_shop/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Productitem extends StatelessWidget {
  final Product product;
  Productitem(
    this.product, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider<BasketBloc>.value(
              value: locator.get<BasketBloc>(),
              child: productDitailScreen(product),
            ),
          ),
        );
      },
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 216,
                width: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    SizedBox(
                        height: 98,
                        width: 98,
                        child: CachedImage(imageUrl: product.thumbnail)),
                    SizedBox(height: 25),
                    Spacer(),
                    Container(
                      height: 53,
                      decoration: BoxDecoration(
                        color: CustomColor.blue,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: CustomColor.blue,
                            blurRadius: 25,
                            spreadRadius: -12,
                            offset: Offset(0, 15),
                          ),
                        ],
                      ),
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
                                  fontSize: 13,
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
                          Spacer(),
                          SizedBox(
                            height: 24,
                            child: Image.asset(
                                'assets/images/icon_right_arrow_cricle.png'),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 10,
                bottom: 63,
                child: Text(
                  product.name,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'SM',
                    fontSize: 14,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child:
                      Image.asset('assets/images/icon_favorite_deactive.png'),
                ),
              ),
              Positioned(
                bottom: 85,
                left: 10,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    color: Colors.red,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    child: Text(
                      '%${product.persent!.round().toString()}',
                      style: TextStyle(
                        fontFamily: 'SB',
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
