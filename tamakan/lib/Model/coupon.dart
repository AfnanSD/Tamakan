class Coupon {
  final String couponID;
  final String name;

  Coupon({
    required this.couponID,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'couponID': couponID,
      'name': name,
    };
  }

  Coupon.fromJson(Map<String, dynamic> json)
      : couponID = json['couponID'],
        name = json['name'];
}
