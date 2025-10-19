class UserPostModel {
  final bool? status;
  final String? message;
  final PostData? data;

  UserPostModel({
    this.status,
    this.message,
    this.data,
  });

  factory UserPostModel.fromJson(Map<String, dynamic> json) {
    return UserPostModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null ? PostData.fromJson(json['data']) : null,
    );
  }
}

class PostData {
  final int? page;
  final int? pageSize;
  final List<PostResponse>? posts;
  final int? total;
  final int? totalPages;

  PostData({
    this.page,
    this.pageSize,
    this.posts,
    this.total,
    this.totalPages,
  });

  factory PostData.fromJson(Map<String, dynamic> json) {
    return PostData(
      page: json['page'] as int?,
      pageSize: json['page_size'] as int?,
      posts: (json['posts'] as List<dynamic>?)?.map((e) => PostResponse.fromJson(e)).toList(),
      total: json['total'] as int?,
      totalPages: json['total_pages'] as int?,
    );
  }
}

class PostResponse {
  final int? id;
  final int? userId;
  final Author? author;
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? country;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PostResponse({
    this.id,
    this.userId,
    this.author,
    this.title,
    this.description,
    this.imageUrl,
    this.country,
    this.createdAt,
    this.updatedAt,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      author: json['author'] != null ? Author.fromJson(json['author']) : null,
      title: json['title'] as String?,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      country: json['country'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
}

class Author {
  final int? id;
  final String? name;
  final String? email;
  final String? password;
  final String? phoneNumber;
  final String? gender;
  final String? role;
  final DateTime? createdAt;
  final String? imageUrl; // Added to support author profile images

  Author({
    this.id,
    this.name,
    this.email,
    this.password,
    this.phoneNumber,
    this.gender,
    this.role,
    this.createdAt,
    this.imageUrl,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      phoneNumber: json['phone_number'] as String?,
      gender: json['gender'] as String?,
      role: json['role'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      imageUrl: json['image_url'] as String?,
    );
  }
}