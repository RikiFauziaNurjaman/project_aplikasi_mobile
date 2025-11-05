import '../models/user_model.dart';

var dummyUser = User(
  id: 'u1',
  username: 'michaelhermanto',
  email: 'michael@example.com',
  fullName: 'Michael Hermanto',

  favoriteComicIds: ['c1', 'c3', 'c4'],
  lastRead: {'comicId': 'c1', 'chapterId': 'op_ch3'},
);
