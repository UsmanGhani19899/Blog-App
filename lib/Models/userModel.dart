class UserModel {
  String? name;
  String? email;
  String? uid;
  String? photo;
  String? userId;
  final savedPosts;
  final followers;
  final followings;

  UserModel(
      {this.email,
      this.name,
      this.photo,
      this.uid,
      this.followers,
      this.followings,
      this.savedPosts,
      this.userId});

  factory UserModel.fromMap(map) {
    return UserModel(
      userId: map['userId'] ?? "",
      email: map['email'] ?? "",
      name: map['name'] ?? "",
      photo: map['photo'] ?? "",
      followers: map['followers'] ?? "",
      followings: map['followings'] ?? "",
      savedPosts: map['savedPosts'] ?? "",
      uid: map['uid'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'photo': photo,
      'uid': uid,
      'savedPosts': savedPosts,
      'followers': followers,
      'followings': followings
    };
  }
}
