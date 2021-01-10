import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shimmer/shimmer.dart';

class ImageSwiper extends StatelessWidget {
  final List<String> images;
  final double height;
  final double width;
  const ImageSwiper({Key key, this.images, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        child: images.length > 0
            ? Swiper(
                itemCount: images.length,
                autoplay: true,
                duration: 1000,
                autoplayDelay: 5000,
                pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                        activeColor: Colors.white,
                        color: Colors.white38,
                        size: 7,
                        activeSize: 7)),
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                      imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      placeholder: (context, url) {
                        return Shimmer.fromColors(
                          child: Container(
                            color: Colors.grey[300],
                            height: 300,
                            width: double.infinity,
                          ),
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.white,
                        );
                      },
                      imageUrl: images[index]);
                  /* Image.network(
                    images[index],
                    fit: BoxFit.fill,
                    loadingBuilder: (context, child, loadingProgress) {
                      return loadingProgress == null
                          ? child
                          : Shimmer.fromColors(
                              child: Container(
                                color: Colors.grey[300],
                                height: 300,
                                width: double.infinity,
                              ),
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.white,
                            );
                    },
                  ) */
                },
              )
            : Shimmer.fromColors(
                child: Container(
                  color: Colors.grey[300],
                  height: 500,
                  width: double.infinity,
                ),
                baseColor: Colors.grey[300],
                highlightColor: Colors.white,
              ));
  }
}
