
class APIEndPoint {
  static const String authLogin = "auth/login";
  static const String homePosts = "home/posts";
  static const String createPost = 'posts';
  static String deletePost(int postId) {
    return 'posts/$postId';
  }
}
