import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jobarchy_flutter_app/core/utils/environment.dart';
import 'package:jobarchy_flutter_app/core/widget/posts/postcard.dart';
import 'package:jobarchy_flutter_app/features/viewmodel/post_viewmodel.dart';


class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(postViewModelProvider.notifier)
          .getUserPost('${Environment.baseUrl}home/posts');
    });
  }

  Future<void> _refresh() async {
    await ref
        .read(postViewModelProvider.notifier)
        .getUserPost('${Environment.baseUrl}home/posts');
  }

  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(postViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF090A0F),
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12, width: 0.5),
          ),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              prefixIcon: Icon(CupertinoIcons.search, color: Colors.white70),
              hintText: "Search posts...",
              hintStyle: TextStyle(fontSize: 15, color: Colors.white54),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: CupertinoColors.activeBlue,
        child: postState.when(
          loading: () => const Center(
            child: CupertinoActivityIndicator(radius: 16, color: Colors.white70),
          ),
          error: (err, _) => Center(
              child: Text("Error: $err",
                  style: const TextStyle(color: Colors.white70))),
          data: (data) {
            final posts = data?.data?.posts ?? [];
            if (posts.isEmpty) {
              return const Center(
                  child: Text("No posts yet",
                      style: TextStyle(color: Colors.white70)));
            }
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostCard(
                  post: posts[index],
                  baseUrl: Environment.baseUrl,
                  currentUserId: "1",
                );
              },
            );
          },
        ),
      ),
    );
  }
}