class CreatePostModel {
  String? postTitle;
  String? post;
  String? uid;
  String? photo;
  String? userPhoto;
  String? userName;
  String? postId;
  final likes;
  final int? commentLen;

  CreatePostModel(
      {this.likes,
      this.commentLen,
      this.post,
      this.postTitle,
      this.photo,
      this.uid,
      this.userName,
      this.userPhoto,
      this.postId});

  factory CreatePostModel.fromMap(map) {
    return CreatePostModel(
        post: map['post'] ?? "",
        likes: map['likes'] ?? "",
        postTitle: map['postTitle'] ?? "",
        photo: map['photo'] ?? "",
        userName: map['userName'] ?? "",
        userPhoto: map['userPhoto'] ?? "",
        uid: map['uid'] ?? "",
        postId: map['postId'] ?? "",
        commentLen: map['commentLen'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'post': post,
      'postTitle': postTitle,
      'photo': photo,
      'uid': uid,
      'postId': postId,
      'userPhoto': userPhoto,
      'userName': userName,
      'likes': likes,
      'commentLen': commentLen
    };
  }
}
