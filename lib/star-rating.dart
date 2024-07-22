import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int starCount;
  final Color color;

  const StarRating({super.key, this.rating = 0.0, this.starCount = 5, this.color = Colors.yellow});

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) {
        if (index < fullStars) {
          return Icon(
            Icons.star,
            color: color,
          );
        } else if (index == fullStars && hasHalfStar) {
          return Icon(
            Icons.star_half,
            color: color,
          );
        } else {
          return Icon(
            Icons.star_border,
            color: color,
          );
        }
      }),
    );
  }
}
