class Profile {
  String id;
  String name;
  String email;
  String membershipDate;
  String plan;
  int courses;
  int streak;
  int totalXP;
  bool notifications;
  String dailyGoal;
  String reminderTime;
  String? profilePicturePath;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.membershipDate,
    required this.plan,
    required this.courses,
    required this.streak,
    required this.totalXP,
    required this.notifications,
    required this.dailyGoal,
    required this.reminderTime,
    this.profilePicturePath,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json['id'] ?? '',
    name: json['name'],
    email: json['email'],
    membershipDate: json['membershipDate'],
    plan: json['plan'],
    courses: json['courses'],
    streak: json['streak'],
    totalXP: json['totalXP'],
    notifications: json['notifications'],
    dailyGoal: json['dailyGoal'],
    reminderTime: json['reminderTime'],
    profilePicturePath: json['profilePicturePath'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'membershipDate': membershipDate,
    'plan': plan,
    'courses': courses,
    'streak': streak,
    'totalXP': totalXP,
    'notifications': notifications,
    'dailyGoal': dailyGoal,
    'reminderTime': reminderTime,
    'profilePicturePath': profilePicturePath,
  };
}
