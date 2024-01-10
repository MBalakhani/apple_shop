import 'package:apple_shop/bloc/categoryProduct/category_product_bloc.dart';
import 'package:apple_shop/bloc/categoryProduct/category_product_event.dart';
import 'package:apple_shop/bloc/categoryProduct/category_product_state.dart';
import 'package:apple_shop/colors.dart';
import 'package:apple_shop/data/model/category.dart';

import 'package:apple_shop/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListScreen extends StatefulWidget {
  final Category category;
  ProductListScreen(this.category, {super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    BlocProvider.of<CategoryProductBloc>(context)
        .add(CategoryProductInitialize(widget.category.id!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryProductBloc, CategoryProductState>(
        builder: (context, State) {
      return Scaffold(
        backgroundColor: Color(0xffEEEEEE),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 10, left: 44, right: 44, bottom: 32),
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
                          Icon(Icons.filter_alt),
                          Expanded(
                            child: Text(
                              widget.category.title!,
                              style: TextStyle(
                                fontFamily: 'SM',
                                fontSize: 16,
                                color: CustomColor.blue,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Image.asset('assets/images/icon_back.png'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (State is CategoryProductLoadingState) ...{
                SliverToBoxAdapter(
                  child: Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              },
              if (State is CategoryProductResponseSuccessState) ...{
                State.productListByCategory.fold((l) {
                  return SliverToBoxAdapter(
                    child: Text(l),
                  );
                }, (r) {
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Productitem(r[index]);
                        },
                        childCount: r.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 2.7,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                      ),
                    ),
                  );
                })
              },
            ],
          ),
        ),
      );
    });
  }
}
