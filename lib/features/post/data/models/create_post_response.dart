class CreatePostResponse {
  final String message;
  CreatePostResponse({required this.message});

  factory CreatePostResponse.fromJson(Map<String, dynamic> json) =>
      CreatePostResponse(message: json['message']);
}
