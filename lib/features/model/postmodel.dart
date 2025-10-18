
import 'dart:convert';

UserPostModel userPostModelFromJson(String str) => UserPostModel.fromJson(json.decode(str));

String userPostModelToJson(UserPostModel data) => json.encode(data.toJson());

class UserPostModel {
    final bool status;
    final String message;
    final List<PostResponse> data;

    UserPostModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory UserPostModel.fromJson(Map<String, dynamic> json) => UserPostModel(
        status: json["status"],
        message: json["message"],
        data: List<PostResponse>.from(json["data"].map((x) => PostResponse.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class PostResponse {
    final int id;
    final int userId;
    final String title;
    final String description;
    final String imageUrl;
    final DateTime createdAt;

    PostResponse({
        required this.id,
        required this.userId,
        required this.title,
        required this.description,
        required this.imageUrl,
        required this.createdAt,
    });

    factory PostResponse.fromJson(Map<String, dynamic> json) => PostResponse(
        id: json["id"],
        userId: json["user_id"],
        title: json["title"],
        description: json["description"],
        imageUrl: json["image_url"],
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "title": title,
        "description": description,
        "image_url": imageUrl,
        "created_at": createdAt.toIso8601String(),
    };
}
