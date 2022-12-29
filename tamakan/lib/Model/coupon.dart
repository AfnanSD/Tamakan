class Coupon {
  final String couponID;
  final String name;
  final DateTime endDate;
  final String childID;

  Coupon({
    required this.couponID,
    required this.name,
    required this.endDate,
    required this.childID,
  });

  Map<String, dynamic> toJson() {
    return {
      'couponID': couponID,
      'name': name,
      'endDate': endDate,
      'childID': childID,
    };
  }

  Coupon.fromJson(Map<String, dynamic> json)
      : couponID = json['couponID'],
        name = json['name'],
        endDate = json['endDate'].toDate(),
        childID = json['childID'];
}
