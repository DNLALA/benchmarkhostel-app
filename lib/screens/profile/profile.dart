// ignore_for_file: library_private_types_in_public_api

import 'package:benchmarkhostel/api/base.dart';
import 'package:benchmarkhostel/componets/botton/SubmitBotton.dart';
import 'package:benchmarkhostel/models/UserState.dart';
import 'package:benchmarkhostel/models/hostel.dart';
import 'package:benchmarkhostel/screens/home/home.dart';
import 'package:benchmarkhostel/screens/warden/allstudents.dart';
import 'package:benchmarkhostel/services/Token.dart';
import 'package:benchmarkhostel/services/sharedPreferences/sharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  Hostel? hostel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    bool? hasHotel = sharedPreferences!.getBool("has_Hotel");

    var box = await Hive.openBox(tokenBox);
    String? token = box.get('token');
    // if (hasHotel = true) {
    //   print('object');
    //   getHostel(token!);
    // }
  }

  @override
  Widget build(BuildContext context) {
    bool? hasHotel = sharedPreferences!.getBool("has_Hotel");
    bool? isWarden = sharedPreferences!.getBool("is_warden");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'User Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      'Name: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${sharedPreferences!.getString("username")}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Email: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${sharedPreferences!.getString("email")}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Reg No: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${sharedPreferences!.getString("reg_no")}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (hasHotel == true && isWarden == false) ...[
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Hostel Details',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Room Type: ${sharedPreferences!.getString("roomType")}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Seater: ${sharedPreferences!.getString("seater")}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Hostel: ${sharedPreferences!.getString("hostel")}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Room Number: ${sharedPreferences!.getString("roomNumber")}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Bed: ${sharedPreferences!.getString("bed")}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            Column(
              children: [
                if (isWarden == true) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SubmitButton(
                      buttonText: "Student Details",
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HostelListScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SubmitButton(
                    buttonText: "LogOut",
                    textColor: Colors.white,
                    onPressed: () {
                      logout();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
