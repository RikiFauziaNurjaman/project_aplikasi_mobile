class User {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final List<String> favoriteComicIds;
  final Map<String, String>? lastRead;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.favoriteComicIds,
    this.lastRead,
  });
}
 