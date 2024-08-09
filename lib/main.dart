import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  Future<List<User>> fetchUsers() async {
    final response =
        await http.get(Uri.parse('https://ws.jakarta.go.id/gateway/DataPortalSatuDataJakarta/1.0/satudata?kategori=dataset&tipe=detail&url=indeks-kepuasan-layanan-penunjang-urusan-pemerintahan-daerah-pada-dinas-pariwisata-dan-ekonomi-kreatif'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: FutureBuilder<List<User>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.periode_data),
                subtitle: Text(user.jenis_layanan),
              );
            },
          );
        },
      ),
    );
  }
}

class User {
  final String periode_data;
  final String jenis_layanan;
  User({required this.periode_data, required this.jenis_layanan});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      periode_data: json['periode_data'],
      jenis_layanan: json['jenis_layanan'],
    );
  }
}
