import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/base/extension.dart';
import 'package:viovid/bloc/repositories/selected_film_repo.dart';
import 'package:viovid/data/dynamic/profile_data.dart';
import 'package:viovid/main.dart';
import 'package:viovid/screens/film_detail/components/harmful_warning_dialog.dart';

class ReviewInput extends StatefulWidget {
  const ReviewInput({super.key});

  @override
  State<ReviewInput> createState() => _ReviewInputState();
}

class _ReviewInputState extends State<ReviewInput> {
  late final TextEditingController _controller;
  late double _rate;
  bool _isPushReview = false;

  void handleSubmitReview() async {
    setState(() {
      _isPushReview = true;
    });
    final content = _controller.text;
    OpenAIModerationModel moderation = await OpenAI.instance.moderation.create(
      /*
        https://platform.openai.com/docs/models#moderation
        model: "text-moderation-007",
        Nếu chỉ có văn được được gửi thì server sẽ sử dụng text-moderation-007
        Vừa có hình ảnh vừa có văn bản thì server sẽ sử dụng omni-moderation-2024-09-26
      */
      input: content,
    );
    /*
    OpenAIModerationModel(
      id: modr-AReCqGwdsA8Bdz1tunsGAO9xyRntD,
      model: text-moderation-007,
      results: [
        OpenAIModerationResultModel(
          categories: OpenAIModerationResultCategoriesModel(
            hate: false,
            hateAndThreatening: false,
            selfHarm: false,
            sexual: false,
            sexualAndMinors: false,
            violence: false,
            violenceAndGraphic: false
          ),
          categoryScores: OpenAIModerationResultScoresModel(
            hate: 0.000025305775125161745,
            hateAndThreatening: 8.491527978549129e-7,
            selfHarm: 0.0000012788224239557167,
            sexual: 0.0037432664539664984,
            sexualAndMinors: 0.00008319870539708063,
            violence: 0.00004879423067905009,
            violenceAndGraphic: 0.000020057279471075162
          ),
          flagged: false
        )
      ]
    )
    */

    final flagged = moderation.results[0].flagged;
    if (flagged) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => const HarmfulWarningDialog(),
        );
      }
    } else if (mounted) {
      await supabase.from('review').upsert(
        {
          'user_id': supabase.auth.currentUser!.id,
          'film_id': context.read<SelectedFilmRepo>().selectedFilm.id,
          'star': _rate,
          'content': content,
          'created_at': DateTime.now().toVnFormat(),
        },
      );
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text(
                'Cảm ơn bạn đã đánh giá phim.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
            width: 300,
          ),
        );
      }
    }
    setState(() {
      _isPushReview = false;
    });
  }

  @override
  void initState() {
    super.initState();
    final reviews = context.read<SelectedFilmRepo>().selectedFilm.reviews;
    final index = reviews.indexWhere(
      (review) => review.userId == supabase.auth.currentUser!.id,
    );
    if (index >= 0) {
      _rate = reviews[index].star.toDouble();
      _controller = TextEditingController(text: reviews[index].content);
    } else {
      _rate = 4;
      _controller = TextEditingController();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: '$baseAvatarUrl/${profileData['avatar_url']}',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // RatingBarIndicator(
              //   rating: 3,
              //   itemBuilder: (context, index) => const Icon(
              //     Icons.star,
              //     color: Colors.amber,
              //   ),
              //   itemCount: 5,
              //   itemSize: 50.0,
              // ),
              RatingBar.builder(
                initialRating: _rate,
                minRating: 1,
                direction: Axis.horizontal,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                unratedColor: Colors.grey,
                onRatingUpdate: (rating) {
                  _rate = rating;
                },
              ),
              const Gap(8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Nhập đánh giá phim',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade900,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
                      ),
                      onEditingComplete: handleSubmitReview,
                    ),
                  ),
                  const Gap(14),
                  FilledButton(
                    onPressed: _isPushReview ? null : handleSubmitReview,
                    style: IconButton.styleFrom(
                      fixedSize: const Size(140, 52),
                      foregroundColor: Colors.white,
                      backgroundColor: primaryColor,
                      disabledForegroundColor: Colors.black,
                      disabledBackgroundColor: const Color(0xFF676767),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isPushReview
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text(
                            'Đánh giá',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
