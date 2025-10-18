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
      ref.read(postViewModelProvider.notifier)
          .getUserPost('${Environment.baseUrl}home/posts');
    });
  }

  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(postViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search posts...',
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
            onChanged: (value) {
            },
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(postViewModelProvider.notifier)
              .getUserPost('${Environment.baseUrl}home/posts');
        },
        child: postState.when(
          loading: () =>
              const Center(child: CircularProgressIndicator(color: Colors.red)),
          error: (error, _) => Center(child: Text('Error: $error')),
          data: (userPostModel) {
            if (userPostModel == null || userPostModel.data.isEmpty) {
              return const Center(child: Text('No posts available'));
            }
            return ListView.builder(
              itemCount: userPostModel.data.length,
              itemBuilder: (context, index) {
                final post = userPostModel.data[index];
                return PostCard(post: post, baseUrl: Environment.baseUrl);
              },
            );
          },
        ),
      ),
    );
  }
}
