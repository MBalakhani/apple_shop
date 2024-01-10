import 'package:apple_shop/bloc/basket/baset_event.dart';
import 'package:apple_shop/bloc/basket/basket_bloc.dart';
import 'package:apple_shop/bloc/basket/basket_state.dart';
import 'package:apple_shop/colors.dart';
import 'package:apple_shop/data/model/card_item.dart';
import 'package:apple_shop/util/extenstions/double_extenstions.dart';
import 'package:apple_shop/util/extenstions/string_extenstions.dart';
import 'package:apple_shop/widgets/cached_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColor.backgroundColor,
        body: SafeArea(
          child: BlocBuilder<BasketBloc, BasketState>(
            builder: (context, state) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 10, left: 44, right: 44, bottom: 32),
                          child: Container(
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Image.asset(
                                      'assets/images/icon_apple_blue.png'),
                                  Expanded(
                                    child: Text(
                                      'سبد خرید',
                                      style: TextStyle(
                                        fontFamily: 'SM',
                                        fontSize: 16,
                                        color: CustomColor.blue,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (state is BasketDataFetchedState) ...{
                        state.basketItemList.fold((l) {
                          return SliverToBoxAdapter(
                            child: Text(l),
                          );
                        }, (r) {
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return CardItem(r[index], index);
                              },
                              childCount: r.length,
                            ),
                          );
                        }),
                      },
                      SliverPadding(padding: EdgeInsets.only(bottom: 100))
                    ],
                  ),
                  if (state is BasketDataFetchedState) ...{
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 55, right: 55, bottom: 20),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColor.green,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18)),
                              ),
                            ),
                            onPressed: () {
                              context
                                  .read<BasketBloc>()
                                  .add(BasketPaymentInitEvent());

                              context
                                  .read<BasketBloc>()
                                  .add(BasketPaymentRequestEvent());
                            },
                            child: Text(
                              (state.basketFinalPrice == 0)
                                  ? 'سبد خرید شما خالیه '
                                  : '${state.basketFinalPrice} : مبلغ قابل پرداخت',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                  },
                ],
              );
            },
          ),
        ));
  }
}

class CardItem extends StatelessWidget {
  final BasketItem basketItem;
  final int index;
  CardItem(
    this.basketItem,
    this.index, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 249,
      margin: EdgeInsets.only(left: 44, right: 44, bottom: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      right: 13,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          basketItem.name,
                          style: TextStyle(
                            fontFamily: 'sb',
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'گارانتی ۱۸ ماه مدیا پردازش',
                          style: TextStyle(
                            fontFamily: 'sb',
                            fontSize: 12,
                            color: CustomColor.grey,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24)),
                                color: Colors.red,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: .5),
                                child: Text(
                                  '%${basketItem.persent!.round().toString()}',
                                  style: TextStyle(
                                    fontFamily: 'SB',
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'تومان',
                              style: TextStyle(
                                fontFamily: 'sb',
                                fontSize: 12,
                                color: CustomColor.grey,
                              ),
                            ),
                            Text(
                              '${basketItem.price.convertToPrice()}',
                              style: TextStyle(
                                fontFamily: 'sm',
                                fontSize: 12,
                                color: CustomColor.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        OptionCheap(
                          'آبی',
                          color: 'eb34b4',
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<BasketBloc>()
                                    .add(BasketRemoveProductEvent(index));
                              },
                              child: Container(
                                height: 26,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: .4,
                                    color: CustomColor.grey,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Row(
                                    children: [
                                      Text(
                                        'حذف',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'sm',
                                          fontSize: 11,
                                          color: CustomColor.grey,
                                        ),
                                      ),
                                      Spacer(),
                                      Image.asset(
                                          'assets/images/icon_trash.png'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Container(
                              height: 26,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  width: .4,
                                  color: CustomColor.grey,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Row(
                                  children: [
                                    Text(
                                      'ذخیره',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'sm',
                                        fontSize: 11,
                                        color: CustomColor.grey,
                                      ),
                                    ),
                                    Spacer(),
                                    Image.asset(
                                        'assets/images/active_fav_product.png'),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Container(
                              height: 26,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  width: .4,
                                  color: CustomColor.grey,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                          'assets/images/icon_options.png'),
                                      Spacer(),
                                      Text(
                                        '1',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'sm',
                                          fontSize: 12,
                                          color: CustomColor.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: SizedBox(
                      height: 100,
                      width: 90,
                      child: CachedImage(imageUrl: basketItem.thumbnail)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: DottedLine(
              lineThickness: 2,
              dashLength: 6,
              dashColor: CustomColor.grey.withOpacity(.4),
              dashGapLength: 3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'تومان',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'sb',
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  '${basketItem.realPrice.convertToPrice()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'sb',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OptionCheap extends StatelessWidget {
  String? color;
  String title;
  OptionCheap(this.title, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 26,
          width: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: .4,
              color: CustomColor.grey,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'sm',
                    fontSize: 11,
                    color: CustomColor.grey,
                  ),
                ),
                SizedBox(width: 4),
                Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: color.parseToColor(),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 5),
        Container(
          height: 26,
          width: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: .4,
              color: CustomColor.grey,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Text(
                  'gb',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'sm',
                    fontSize: 11,
                    color: CustomColor.grey,
                  ),
                ),
                SizedBox(width: 2),
                Text(
                  '256',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'sm',
                    fontSize: 12,
                    color: CustomColor.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
