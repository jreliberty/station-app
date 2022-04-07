class PushNotification {
  PushNotification({
    required this.read,
    required this.index,
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
    this.imageUrl,
    this.sentTime,
  });

  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;
  String? imageUrl;
  DateTime? sentTime;

  bool read;
  final int index;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['title'] = this.title;
    map['body'] = this.body;
    map['dataTitle'] = this.dataTitle;
    map['dataBody'] = this.dataBody;
    map['imageUrl'] = this.imageUrl;
    map['sentTime'] = this.sentTime.toString();
    map['read'] = this.read.toString();
    map['index'] = this.index.toString();
    return map;
  }

  factory PushNotification.fromMap(Map<String, dynamic> data) {
    return PushNotification(
      title: data["title"] ?? "",
      read: data["read"] == 'true',
      body: data["body"] ?? "",
      dataTitle: data["dataTitle"] ?? "",
      dataBody: data["dataBody"] ?? "",
      imageUrl: data["imageUrl"] ?? "",
      sentTime: DateTime.parse(data["sentTime"]),
      index: int.parse(data["index"] ?? 0),
    );
  }
}
