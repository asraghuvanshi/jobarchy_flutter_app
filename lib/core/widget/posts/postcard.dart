import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jobarchy_flutter_app/features/model/postmodel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:jobarchy_flutter_app/features/viewmodel/post_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime? createdAt) {
    final date = createdAt ?? DateTime.now();
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  void _showPostOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blueAccent),
              title: const Text('Edit Post', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                if (widget.post != null) {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => EditPostScreen(
                  //       post: widget.post!,
                  //       baseUrl: widget.baseUrl,
                  //     ),
                  //   ),
                  // );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Post', style: TextStyle(fontSize: 16)),
              onTap: () async {
                Navigator.pop(context);
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Post'),
                    content: const Text('Are you sure you want to delete this post?'),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirm == true && widget.post?.id != null) {
                  // ref.read(postViewModelProvider.notifier).deletePost(
                  //       widget.post!.id!,
                  //       context,
                  //       widget.baseUrl,
                  //     );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.post == null) {
      return const SizedBox.shrink(); // Return empty widget if post is null
    }

    final post = widget.post!;
    final imageUrl = post.imageUrl?.isNotEmpty ?? false
        ? '${widget.baseUrl}${post.imageUrl!.replaceAll('\\', '/')}'
        : null;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey[200],
                        child: ClipOval(
                          child: post.author?.imageUrl?.isNotEmpty ?? false
                              ? CachedNetworkImage(
                                  imageUrl: '${widget.baseUrl}${post.author!.imageUrl!.replaceAll('\\', '/')}',
                                  fit: BoxFit.cover,
                                  width: 48,
                                  height: 48,
                                  placeholder: (context, url) => Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(color: Colors.white),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(
                                    Icons.person,
                                    size: 24,
                                    color: Colors.grey,
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 24,
                                  color: Colors.grey,
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.author?.name?.isNotEmpty ?? false
                                ? post.author!.name!
                                : 'Unknown Author',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            post.country?.isNotEmpty ?? false ? post.country! : 'Unknown Location',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            _formatTime(post.createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (post.userId?.toString() == widget.currentUserId)
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.grey),
                      onPressed: () => _showPostOptions(context),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                post.title?.isNotEmpty ?? false ? post.title! : 'No Title',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 8),
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 200,
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      print('Image load error: $url, $error');
                      return Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              if (imageUrl != null) const SizedBox(height: 12),
              Text(
                post.description?.isNotEmpty ?? false ? post.description! : 'No Description',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                  letterSpacing: 0.3,
                ),
                maxLines: _isExpanded ? null : 3,
                overflow: _isExpanded ? null : TextOverflow.ellipsis,
              ),
              if ((post.description?.length ?? 0) > 150)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(
                      _isExpanded ? 'Show Less' : 'Show More',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}