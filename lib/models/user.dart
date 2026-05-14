class User {
  final String fullName;
  final String email;
  final String phone;
  final DateTime birthDate;
  final String country;
  final String gender;
  final bool subscribeToNewsletter;

  User({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.birthDate,
    required this.country,
    required this.gender,
    required this.subscribeToNewsletter,
  });

  String get formattedBirthDate {
    return '${birthDate.day}/${birthDate.month}/${birthDate.year}';
  }

  int get age {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
