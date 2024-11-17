import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid/main.dart';

class FilmManagementScreen extends StatefulWidget {
  const FilmManagementScreen({super.key});

  @override
  State<FilmManagementScreen> createState() => _FilmManagementScreenState();
}

class _FilmManagementScreenState extends State<FilmManagementScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool _isGrid = true;
  late List<Map<String, dynamic>> _posters;

  late final _futurePosters = _fetchPosters('');
  Future<void> _fetchPosters(String searchText) async {
    if (searchText.isEmpty) {
      _posters = await supabase.from('film').select('id, name, poster_path, content_rating');
    } else {
      _posters = await supabase.from('film').select('id, name, poster_path, content_rating').or('id.ilike.%$searchText%,name.ilike.%$searchText%');
    }
  }

  void handleSearch() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchPosters(_controller.text);
    setState(() {
      _isLoading = false;
    });
  }

  void switchToGridView() {
    setState(() {
      _isGrid = true;
    });
  }

  void switchToListView() {
    setState(() {
      _isGrid = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futurePosters,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Có lỗi xảy ra khi truy vấn thông tin phim',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () => context.push('/admin/film-management/add'),
                    style: IconButton.styleFrom(
                      fixedSize: const Size.fromHeight(48),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF695CFE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Thêm',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm ...',
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                        ),
                        border: MaterialStateOutlineInputBorder.resolveWith(
                          (states) {
                            if (states.contains(WidgetState.focused)) {
                              return const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                borderSide: BorderSide(color: Color(0xFF695CFE), width: 2),
                              );
                            } else if (states.contains(WidgetState.hovered)) {
                              return OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                borderSide: BorderSide(color: const Color(0xFF695CFE).withOpacity(0.3), width: 1),
                              );
                            }
                            return const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              borderSide: BorderSide(color: Colors.black),
                            );
                          },
                        ),
                        contentPadding: const EdgeInsets.all(14),
                      ),
                      onEditingComplete: handleSearch,
                    ),
                  ),
                  const Gap(8),
                  IconButton(
                    onPressed: _isLoading ? null : handleSearch,
                    style: IconButton.styleFrom(
                      fixedSize: const Size(80, 48),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF695CFE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(
                      Icons.search_rounded,
                      size: 28,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: switchToGridView,
                    style: IconButton.styleFrom(
                      fixedSize: const Size(48, 48),
                      foregroundColor: _isGrid ? Colors.white : null,
                      backgroundColor: _isGrid ? const Color(0xFF695CFE) : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(
                      Icons.grid_view_rounded,
                      size: 28,
                    ),
                  ),
                  const Gap(8),
                  IconButton(
                    onPressed: switchToListView,
                    style: IconButton.styleFrom(
                      fixedSize: const Size(48, 48),
                      foregroundColor: _isGrid ? null : Colors.white,
                      backgroundColor: _isGrid ? null : const Color(0xFF695CFE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(
                      Icons.list_alt,
                      size: 28,
                    ),
                  )
                ],
              ),
              const Gap(20),
              Expanded(
                child: _isGrid
                    ? GridView(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 225,
                          childAspectRatio: 2 / 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        children: List.generate(
                          _posters.length,
                          (index) {
                            // final filmId = posters[index].filmId;
                            return InkWell(
                              onTap: () => context.push("/admin/film-management/edit/${_posters[index]['id']}"),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w440_and_h660_face/${_posters[index]['poster_path']}',
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Column(
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color(0xFF695CFE),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Gap(20),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'MÃ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Gap(20),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'TÊN',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Gap(20),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'LOẠI',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Gap(20),
                                ],
                              ),
                            ),
                          ),
                          const Gap(10),
                          Expanded(
                            child: ListView.separated(
                              itemBuilder: (ctx, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Gap(20),
                                      Expanded(
                                        flex: 2,
                                        child: Text(_posters[index]['id']),
                                      ),
                                      const Gap(20),
                                      Expanded(
                                        flex: 3,
                                        child: Text(_posters[index]['name']),
                                      ),
                                      const Gap(20),
                                      Expanded(
                                        flex: 2,
                                        child: Text(_posters[index]['content_rating']),
                                      ),
                                      const Gap(20),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (ctx, index) => Divider(
                                color: const Color(0xFF695CFE).withOpacity(0.3),
                              ),
                              itemCount: _posters.length,
                            ),
                          )
                        ],
                      ),
              )
            ],
          ),
        );
      },
    );
  }
}
