import 'package:equatable/equatable.dart';

class PsymateModel extends Equatable {
  final String id;
  final String name;
  final String specialization;
  final String? imageUrl;

  const PsymateModel({
    required this.id,
    required this.name,
    required this.specialization,
    this.imageUrl,
  });

  factory PsymateModel.fromJson(Map<String, dynamic> json) {
    return PsymateModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      specialization: json['specialization']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'specialization': specialization,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }

  @override
  List<Object?> get props => [id, name, specialization, imageUrl];
}

class PackageModel extends Equatable {
  final String id;
  final String packageName;
  final int sessions;
  final double price;

  const PackageModel({
    required this.id,
    required this.packageName,
    required this.sessions,
    required this.price,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['_id']?.toString() ?? '',
      packageName: json['packageName']?.toString() ?? '',
      sessions: (json['sessions'] ?? 0) as int,
      price: (json['price'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'packageName': packageName,
      'sessions': sessions,
      'price': price,
    };
  }

  @override
  List<Object?> get props => [id, packageName, sessions, price];
}

class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? mobile;
  final String? status;
  final String? userId;
  final String? psymateId;
  final String? packageId;
  final PsymateModel? psymate;
  final PackageModel? package;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.mobile,
    this.status,
    this.userId,
    this.psymateId,
    this.packageId,
    this.psymate,
    this.package,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      mobile: json['mobile']?.toString(),
      status: json['status']?.toString(),
      userId: json['userId']?.toString(),
      psymateId: json['psymateId']?.toString(),
      packageId: json['packageId']?.toString(),
      psymate: json['psymate'] != null
          ? PsymateModel.fromJson(json['psymate'] as Map<String, dynamic>)
          : null,
      package: json['package'] != null
          ? PackageModel.fromJson(json['package'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'id': id,
      'email': email,
      'name': name,
      if (mobile != null) 'mobile': mobile,
      if (status != null) 'status': status,
      if (userId != null) 'userId': userId,
      if (psymateId != null) 'psymateId': psymateId,
      if (packageId != null) 'packageId': packageId,
      if (psymate != null) 'psymate': psymate!.toJson(),
      if (package != null) 'package': package!.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        mobile,
        status,
        userId,
        psymateId,
        packageId,
        psymate,
        package,
      ];
}
