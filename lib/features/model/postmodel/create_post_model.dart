
import 'dart:convert';

CreatePostResponse createPostResponseFromJson(String str) => CreatePostResponse.fromJson(json.decode(str));

String createPostResponseToJson(CreatePostResponse data) => json.encode(data.toJson());

class CreatePostResponse {
    final bool? status;
    final String? message;
    final PostResponseModel? data;

    CreatePostResponse({
        this.status,
        this.message,
        this.data,
    });

    factory CreatePostResponse.fromJson(Map<String, dynamic> json) => CreatePostResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : PostResponseModel.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class PostResponseModel {
    final int? id;
    final int? userId;
    final Author? author;
    final String? title;
    final String? description;
    final String? imageUrl;
    final String? country;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    PostResponseModel({
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

    factory PostResponseModel.fromJson(Map<String, dynamic> json) => PostResponseModel(
        id: json["id"],
        userId: json["user_id"],
        author: json["author"] == null ? null : Author.fromJson(json["author"]),
        title: json["title"],
        description: json["description"],
        imageUrl: json["image_url"],
        country: json["country"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "author": author?.toJson(),
        "title": title,
        "description": description,
        "image_url": imageUrl,
        "country": country,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
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

    Author({
        this.id,
        this.name,
        this.email,
        this.password,
        this.phoneNumber,
        this.gender,
        this.role,
        this.createdAt,
    });

    factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        phoneNumber: json["phoneNumber"],
        gender: json["gender"],
        role: json["role"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "password": password,
        "phoneNumber": phoneNumber,
        "gender": gender,
        "role": role,
        "created_at": createdAt?.toIso8601String(),
    };
}
