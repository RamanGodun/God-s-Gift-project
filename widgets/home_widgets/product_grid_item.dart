import 'package:flutter/material.dart';
import 'package:gods_gift/widgets/home_widgets/liters_counter.dart';

class ProductGridItem extends StatefulWidget {
  final bool? isPromotion;
  const ProductGridItem({super.key, this.isPromotion = true});

  @override
  State<ProductGridItem> createState() => _ProductGridItemState();
}

class _ProductGridItemState extends State<ProductGridItem> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.02,
        vertical: MediaQuery.of(context).size.width * 0.03,
      ),
      child: GridTile(
          child: Container(
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.18,
                      child: Container(
                        color: Colors.amberAccent,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    child: Text(
                      'Grechanuy!',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: height / 40,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: widget.isPromotion == true
                        ? MediaQuery.of(context).size.width * 0.4
                        : MediaQuery.of(context).size.width * 0.3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 5,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  '₴199',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            widget.isPromotion == true
                                ? const SizedBox(
                                    width: 4,
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: Text(
                                        ' ₴200',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationColor: Colors.amber,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              width: widget.isPromotion == true ? 4 : 5,
                              child: const FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  ' / 0.5 л',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
              LitersCounter(),
            ],
          ),
        ),
      )),
    );
  }
}
