class Chat {
  final String message;
  final String id;
  final DateTime createdAt;
  final String userId;
  final String userName;

  const Chat(
      {required this.id,
      required this.message,
      required this.createdAt,
      required this.userName,
      required this.userId});
}
