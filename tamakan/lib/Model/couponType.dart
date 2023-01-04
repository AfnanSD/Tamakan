class CouponType {
  String name;
  DateTime startDate;
  DateTime endDate;
  String pictureURL;
  String description;
  int amount;
  int points;

  CouponType(
    this.name,
    this.startDate,
    this.endDate,
    this.pictureURL,
    this.description,
    this.amount,
    this.points,
  );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'startDate': startDate,
      'endDate': endDate,
      'pictureURL': pictureURL,
      'description': description,
      'amount': amount,
      'points': points,
    };
  }

  CouponType.fromJson(Map<String, dynamic>? json)
      : name = json!['name'],
        startDate = json['startDate'].toDate(),
        endDate = json['endDate'].toDate(),
        pictureURL = json['pictureURL'],
        description = json['description'],
        amount = json['amount'],
        points = json['points'];
}
