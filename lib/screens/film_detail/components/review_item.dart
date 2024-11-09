import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:viovid/base/extension.dart';
import 'package:viovid/main.dart';
import 'package:viovid/models/review_film.dart';

class ReviewItem extends StatelessWidget {
  const ReviewItem({super.key, required this.review});

  final ReviewFilm review;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: '$baseAvatarUrl/${review.avatarUrl}',
            height: 100,
            width: 100,
            fit: BoxFit.cover,
            // fadeInDuration: là thời gian xuất hiện của Image khi đã load xong
            fadeInDuration: const Duration(milliseconds: 300),
            // fadeOutDuration: là thời gian biến mất của placeholder khi Image khi đã load xong
            fadeOutDuration: const Duration(milliseconds: 500),
            placeholder: (context, url) => const Padding(
              padding: EdgeInsets.all(76),
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        const Gap(20),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review.hoTen,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(8),
              RatingBarIndicator(
                rating: review.star.toDouble(),
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 40,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                unratedColor: Colors.grey,
              ),
              const Gap(8),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade900,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
                  child: Text(
                    review.content,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const Gap(4),
              Text(
                'Ngày: ${review.createAt.toVnFormat()}',
                style: const TextStyle(color: Colors.white38),
              ),
              const Gap(14),
            ],
          ),
        ),
      ],
    );
  }
}
