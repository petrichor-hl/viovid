import 'package:flutter/material.dart';
import 'package:viovid/data/dynamic/profile_data.dart';
import 'package:viovid/data/dynamic/topics_data.dart';
import 'package:viovid/screens/browse/components/browse_header.dart';
import 'package:viovid/screens/browse/components/chat_bot_dialog.dart';
import 'package:viovid/screens/browse/components/content_list.dart';
import 'package:viovid/screens/browse/components/custom_app_bar.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  late final Size _screenSize = MediaQuery.sizeOf(context);

  late final ScrollController _scrollController = ScrollController()
    ..addListener(() {
      setState(() {});
    });

  bool _isFetchingData = true;

  bool _isChatDialogVisible = false;

  Future<void> fetchData() async {
    await fetchTopicsData();

    if (profileData.isEmpty) {
      print('[GET]: fetch profile data - ⏰');
      await fetchProfileData();
      print('[GET]: fetch profile data - ✅');
    }

    setState(() {
      _isFetchingData = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {});
    // Executes a function only one time after the layout is completed*/
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isFetchingData
        ? const ColoredBox(
            color: Colors.black,
          )
        : Scaffold(
            extendBodyBehindAppBar: true,
            appBar: PreferredSize(
              preferredSize: Size(_screenSize.width, 100),
              child: CustomAppBar(
                scrollOffset: _scrollController.hasClients ? _scrollController.offset : 0,
              ),
            ),
            body: Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    const SliverToBoxAdapter(
                      child: BrowseHeader(),
                    ),
                    ...topicsData.map(
                      (topic) => SliverToBoxAdapter(
                        child: ContentList(
                          key: PageStorageKey(topic),
                          title: topic.name,
                          films: topic.posters,
                          isOriginals: topic.name == 'Chỉ có trên VioVid',
                        ),
                      ),
                    ),
                    const SliverPadding(padding: EdgeInsets.only(bottom: 20))
                  ],
                ),
                Positioned(
                    bottom: 16,
                    right: 80,
                    child: IgnorePointer(
                      ignoring: !_isChatDialogVisible,
                      child: AnimatedOpacity(
                        opacity: _isChatDialogVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 150),
                        child: ChatBotDialog(
                          minimizeDialog: () => setState(() {
                            _isChatDialogVisible = false;
                          }),
                        ),
                      ),
                    )),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => setState(() {
                _isChatDialogVisible = !_isChatDialogVisible;
              }),
              child: const Icon(Icons.smart_toy_rounded),
            ),
          );
  }
}
