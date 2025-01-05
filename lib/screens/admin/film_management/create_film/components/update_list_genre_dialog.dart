import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid/features/film_management/dtos/genre_dto.dart';

class UpdateListGenreDialog extends StatefulWidget {
  const UpdateListGenreDialog({super.key, required this.selectedGenres});

  final List<GenreDto> selectedGenres;

  @override
  State<UpdateListGenreDialog> createState() => _UpdateListGenreDialogState();
}

class _UpdateListGenreDialogState extends State<UpdateListGenreDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 20,
              children: [
                const Text(
                  'Chỉnh sửa danh sách Thể loại',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    // color: Colors.white,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close_rounded),
                )
              ],
            ),
            const Divider(height: 30),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: _allGenres
                    .map(
                      (genre) => CheckboxListTile(
                        value: widget.selectedGenres.any(
                          (selectedGenre) => selectedGenre.id == genre.id,
                        ),
                        title: Text(genre.name),
                        onChanged: (isChecked) {
                          setState(() {
                            if (isChecked == true) {
                              // Thêm phim vào danh sách nếu được chọn
                              widget.selectedGenres.add(genre);
                            } else {
                              // Xóa phim khỏi danh sách nếu bỏ chọn
                              widget.selectedGenres.remove(genre);
                            }
                          });
                        },
                      ),
                    )
                    .toList(),
                // ),
              ),
            ),
            const Divider(height: 30),
            FilledButton(
              onPressed: () => context.pop(),
              style: FilledButton.styleFrom(
                fixedSize: const Size.fromHeight(48),
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF695CFE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Xác nhận',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

final List<GenreDto> _allGenres = [
  GenreDto(
    id: '74454f17-c419-47e6-b75a-e818739923d0',
    name: 'Hành động',
  ),
  GenreDto(
    id: '8a7660de-22e5-4715-92cd-c6b221d3ed9d',
    name: 'Anime',
  ),
  GenreDto(
    id: '1712669b-8d4e-4f48-b9cc-d9ac8f041527',
    name: 'Siêu nhiên',
  ),
  GenreDto(
    id: 'e8a8593d-0bc7-4a40-8ba3-4454a46d4021',
    name: 'Giả tưởng',
  ),
  GenreDto(
    id: 'aa7f1961-881a-460d-a16f-6e2e708ae62c',
    name: 'Tội phạm',
  ),
  GenreDto(
    id: '94bdd035-bed1-46f6-be17-f398c1b2ceb2',
    name: 'Thời kỳ lịch sử',
  ),
  GenreDto(
    id: '78f2b4c5-b6e1-4f92-ad11-c8ef7bf6e40e',
    name: 'Lãng mạn',
  ),
  GenreDto(
    id: 'd9c8308c-b5bd-4397-b1ae-b81983aeebb7',
    name: 'Hài hước',
  ),
  GenreDto(
    id: '4a6886af-a373-4fe4-bf1b-24e21d65f187',
    name: 'Phiêu lưu',
  ),
  GenreDto(
    id: '7808f300-50f0-413d-a367-ca9d8db4d456',
    name: 'Khoa học',
  ),
  GenreDto(
    id: 'e4e535df-f705-438e-a263-434f05d21cba',
    name: 'Tuổi teen',
  ),
  GenreDto(
      id: '2a22240a-13e3-4ede-8352-0e60669e9b34', name: 'Khoa học viễn tưởng'),
  GenreDto(
    id: '1d204e05-f1ca-4c29-b479-c4c41a2f694d',
    name: 'Kịch tính',
  ),
  GenreDto(
    id: '7517c171-fc81-4d28-aa11-83d245a44e5d',
    name: 'Trẻ em',
  ),
  GenreDto(
    id: '14294e88-8378-461d-aebb-f0a888544681',
    name: 'Gia đình',
  ),
  GenreDto(
    id: 'c4648d1f-22b9-4949-97bc-2eb42d161901',
    name: 'Thần thoại',
  ),
  GenreDto(
    id: 'c2ef3437-07e1-4d6f-bcf7-3ea6c21b7122',
    name: 'Bí ẩn',
  ),
  GenreDto(
    id: '4a12d4d0-1565-4536-bc89-cc135dfe7c86',
    name: 'Chính kịch',
  ),
  GenreDto(
    id: 'd34b72b6-cf84-4303-8a36-1a9b5131e197',
    name: 'Hoạt hình',
  ),
  GenreDto(
    id: 'd60cf40d-c17f-461a-a20e-e7ce655a5aa8',
    name: 'Kinh dị',
  ),
  GenreDto(
    id: 'eb8a407f-c358-4faa-af1a-46021fc9b19a',
    name: 'Phép thuật',
  ),
];
