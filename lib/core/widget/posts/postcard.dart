import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jobarchy_flutter_app/features/model/postmodel/postmodel.dart';
import 'package:jobarchy_flutter_app/core/utils/colors.dart';
import 'package:jobarchy_flutter_app/features/viewmodel/deletepost_viewmodel.dart';

/// ------------------------------
///  POST CARD
/// ------------------------------
class PostCard extends ConsumerStatefulWidget {
  final PostResponse? post;
  final String baseUrl;
  final String currentUserId;

  const PostCard({
    super.key,
    required this.post,
    required this.baseUrl,
    required this.currentUserId,
  });

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  bool _isExpanded = false;

  String _formatTime(DateTime? createdAt) {
    final date = createdAt ?? DateTime.now();
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  void _showPostOptions(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text("Post Options",
            style: TextStyle(color: Colors.black, fontSize: 16)),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            isDefaultAction: true,
            child: const Text('Edit Post',
                style: TextStyle(color: CupertinoColors.activeBlue)),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              if (widget.post?.id != null) {
                 ref.read(deletePostViewModelProvider.notifier).deleteUserPost(widget.post?.id ?? 0);
              }
               Navigator.pop(context);
            },
            isDestructiveAction: true,
            child: const Text('Delete Post',
                style: TextStyle(color: CupertinoColors.destructiveRed)),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel',
              style: TextStyle(color: CupertinoColors.activeBlue)),
        ),
      ),
    );
  }

  // Simple orange text (no gradient stroke)
  Widget _orangeText(String data) {
    return Text(
      data,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    if (post == null) return const SizedBox.shrink();

    final imageUrl = post.imageUrl?.isNotEmpty ?? false
        ? '${widget.baseUrl}${post.imageUrl!.replaceAll('\\', '/')}'
        : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withAlpha(50), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.grey[800],
                    child: ClipOval(
                      child: post.author?.imageUrl?.isNotEmpty ?? false
                          ? CachedNetworkImage(
                              imageUrl:
                                  '${widget.baseUrl}uploads/${post.author!.imageUrl!.replaceAll('\\', '/')}',
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                              placeholder: (_, __) =>
                                  const Icon(Icons.person, color: Colors.grey),
                              errorWidget: (_, __, ___) =>
                                  const Icon(Icons.person, color: Colors.grey),
                            )
                          : const Icon(Icons.person,
                              color: Colors.grey, size: 26),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _orangeText(post.author?.name ?? "Unknown Author"),
                        Text(
                          post.country ?? "Unknown",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[400],
                          ),
                        ),
                        Text(
                          _formatTime(post.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (post.userId?.toString() == widget.currentUserId)
                    IconButton(
                      icon: const Icon(CupertinoIcons.ellipsis,
                          color: Colors.grey),
                      onPressed: () => _showPostOptions(context),
                    ),
                ],
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title ?? 'Untitled',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    firstChild: Text(
                      post.description ?? '',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 15, color: Colors.white70, height: 1.4),
                    ),
                    secondChild: Text(
                      post.description ?? '',
                      style: const TextStyle(
                          fontSize: 14, color: Colors.white70, height: 1.4),
                    ),
                    crossFadeState:
                        _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  ),
                  if ((post.description?.length ?? 0) > 120)
                    GestureDetector(
                      onTap: () => setState(() => _isExpanded = !_isExpanded),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _isExpanded ? "Show Less" : "Show More",
                          style: const TextStyle(
                            color: CupertinoColors.activeBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            if (imageUrl != null)
              CachedNetworkImage(
                imageUrl: imageUrl,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: Colors.grey[800],
                  height: 220,
                ),
              ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
