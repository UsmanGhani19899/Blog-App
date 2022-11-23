class StoryPost {
  String? story;
  String? uid;
  String? userPhoto;

  String? userName;
  String? postId;
  final likes;
  final seenBy;
  StoryPost(
      {this.seenBy,
      this.likes,
      this.story,
      this.userPhoto,
      this.uid,
      this.userName,
      this.postId});

  factory StoryPost.fromMap(map) {
    return StoryPost(
      story: map['story'] ?? "",
      likes: map['likes'] ?? "",
      seenBy: map['seenBy'] ?? "",
      userPhoto: map['userPhoto'] ?? "",
      userName: map['userName'] ?? "",
      uid: map['uid'] ?? "",
      postId: map['postId'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'story': story,
      'userPhoto': userPhoto,
      'uid': uid,
      'postId': postId,
      'userName': userName,
      'likes': likes,
      'seenBy': seenBy
    };
  }
}
