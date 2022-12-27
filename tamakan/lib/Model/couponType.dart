class CouponType {
  String name;
  DateTime startDate;
  DateTime endDate;
  String pictureURL;
  String descripton;
  int amount;
  int points;

  CouponType(
    this.name,
    this.startDate,
    this.endDate,
    this.pictureURL,
    this.descripton,
    this.amount,
    this.points,
  );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'startDate': startDate,
      'endDate': endDate,
      'pictureURL': pictureURL,
      'descripton': descripton,
      'amount': amount,
      'points': points,
    };
  }

  CouponType.fromJson(Map<String, dynamic>? json)
      : name = json!['name'],
        startDate = json['startDate'].toDate(),
        endDate = json['endDate'].toDate(),
        pictureURL = json['pictureURL'],
        descripton = json['descripton'],
        amount = json['amount'],
        points = json['points'];
}
