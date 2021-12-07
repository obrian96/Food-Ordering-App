class UserDetails {
  final String user_id;
  final String user_email;
  final String user_phno;
  final String user_addline;
  final int pincode;
  final String join_dt;
  final String user_name;
  final String user_pass;
  final int isAdmin;

  UserDetails(this.user_id, this.user_email, this.user_phno, this.user_addline,
      this.pincode, this.join_dt, this.user_name, this.user_pass, this.isAdmin);

  factory UserDetails.fromMap(Map<String, dynamic> json) {
    return UserDetails(
      json['user_id'],
      json['user_email'],
      json['user_phno'],
      json['user_addline'],
      json['pincode'],
      json['join_dt'],
      json['user_name'],
      json['user_pass'],
      json['isAdmin'],
    );
  }

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      json['user_id'],
      json['user_email'],
      json['user_phno'],
      json['user_addline'],
      json['user_pincode'],
      json['user_join_dt'],
      json['user_name'],
      json['user_pass'],
      json['isAdmin'],
    );
  }
}
