import 'dart:io';
import 'package:aid_app/Widgets/image_drawer.dart';
import 'package:aid_app/Widgets/no_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aid_app/Providers/add_aid_requestprov.dart';

// ignore: must_be_immutable
class ShowCarouselSlider extends StatefulWidget {
  ShowCarouselSlider({
    this.imgUrls,
    super.key,
  });
  List<dynamic>? imgUrls;

  @override
  State<ShowCarouselSlider> createState() => _ShowCarouselSliderState();
}

class _ShowCarouselSliderState extends State<ShowCarouselSlider> {
  int currentIndex = 0;

  void updateIndex(int i) {
    setState(() {
      currentIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> images =
        Provider.of<AddAidRequestProvider>(context, listen: true).imagesItems;

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.34,
          width: double.infinity,
          child: images.isNotEmpty
              ? Stack(
                  children: [
                    CarouselSlider.builder(
                      itemCount: images.length > 5 ? 5 : images.length,
                      itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) {
                        return buildView(context, itemIndex, images);
                      },
                      options: CarouselOptions(
                        viewportFraction: 1,
                        height: MediaQuery.of(context).size.height * 0.34,
                        initialPage: 0,
                        reverse: false,
                        autoPlay: false,
                        enableInfiniteScroll: true,
                        onPageChanged: (index, reason) => updateIndex(index),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, bottom: 16),
                        child: Container(
                          height: 30,
                          width: 60,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6))),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '${currentIndex + 1} / ${images.length > 5 ? 5 : images.length}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : NoImage(),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            images.length > 5 ? 5 : images.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: currentIndex == index ? 10 : 8,
              height: currentIndex == index ? 10 : 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentIndex == index ? Colors.blue : Colors.grey[400],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildView(BuildContext context, int itemIndex, List<dynamic> images) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: widget.imgUrls != null
                  ? NetworkImage(images[itemIndex]) as ImageProvider
                  : FileImage(File(images[itemIndex].path)),
            ),
          ),
        ),
        images.isNotEmpty
            ? Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.grey[600])),
                        onPressed: () {
                          setState(() {
                            Provider.of<AddAidRequestProvider>(context,
                                    listen: false)
                                .imagesToBeDeleted(itemIndex);
                            updateIndex(
                                currentIndex > 1 ? itemIndex - 1 : itemIndex);
                          });
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          size: MediaQuery.of(context).size.height * 0.03,
                          color: Colors.white70,
                        )),
                    if (Provider.of<AddAidRequestProvider>(context,
                                listen: true)
                            .imagesItems
                            .length <
                        5)
                      IconButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.grey[600])),
                        icon: Icon(
                          Icons.add,
                          color: Colors.white70,
                          size: MediaQuery.of(context).size.height * 0.028,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              elevation: 10,
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width - 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              builder: (BuildContext context) {
                                return ImagesDrawer();
                              });
                        },
                      ),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
