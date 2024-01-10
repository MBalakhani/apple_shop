import 'package:apple_shop/data/model/banner.dart';
import 'package:apple_shop/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerSlider extends StatelessWidget {
  final List<BannerCamper> bannerlist;
  BannerSlider(this.bannerlist, {super.key});

  @override
  Widget build(BuildContext context) {
    var controller = PageController(viewportFraction: .8);
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        SizedBox(
          height: 177,
          child: PageView.builder(
            controller: controller,
            itemCount: bannerlist.length,
            itemBuilder: ((context, index) {
              return Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: CachedImage(
                  imageUrl: bannerlist[index].thumbnail,
                  radius: 15,
                ),
              );
            }),
          ),
        ),
        Positioned(
          bottom: 10,
          child: SmoothPageIndicator(
            controller: controller,
            count: bannerlist.length,
            effect: ExpandingDotsEffect(
              expansionFactor: 4,
              dotWidth: 7,
              dotHeight: 7,
              dotColor: Colors.white54,
              activeDotColor: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
