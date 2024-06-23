// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:benchmarkhostel/api/base.dart';
import 'package:benchmarkhostel/screens/hotsel/roomType.dart';
import 'package:benchmarkhostel/screens/profile/profile.dart';
import 'package:benchmarkhostel/screens/student/student.dart';
import 'package:benchmarkhostel/screens/warden/warden.dart';
import 'package:benchmarkhostel/services/Token.dart';
import 'package:benchmarkhostel/services/sharedPreferences/sharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> imagePaths = [
    'assets/bspbg.jpg',
    'assets/hostelrooms.jpg',
  ];

  int currentPage = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _getUserdetale();
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      setState(() {
        currentPage = (currentPage + 1) % imagePaths.length;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _getUserdetale() async {
    var box = await Hive.openBox(tokenBox);
    String? token = box.get('token');

    if (token != null) {
      await getUserdata(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: screenHeight * 0.3,
                width: screenWidth,
                decoration: BoxDecoration(
                  // color: Colors.red,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Stack(
                  children: [
                    PageView.builder(
                      itemCount: imagePaths.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.asset(
                          imagePaths[index],
                          fit: BoxFit.cover,
                          width: screenWidth,
                        );
                      },
                    ),
                    // Positioned(
                    //   bottom: 10.0,
                    //   left: 0,
                    //   right: 0,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: List.generate(
                    //       imagePaths.length,
                    //       (index) => Container(
                    //         width: 10.0,
                    //         height: 10.0,
                    //         margin: EdgeInsets.symmetric(horizontal: 2.0),
                    //         decoration: BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           color: currentPage == index
                    //               ? Colors.white
                    //               : Colors.grey,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            const Text(
              'Benchmark Hostel',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Hostel Management System',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () async {
                    var box = await Hive.openBox(tokenBox);
                    String? token = box.get('token');
                    if (token != null) {
                      bool? hasHotel = sharedPreferences!.getBool("has_Hotel");
                      bool? is_student =
                          sharedPreferences!.getBool("is_student");
                      print(hasHotel);
                      if (hasHotel == true && is_student == true) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RoomType(),
                          ),
                        );
                      }
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Student(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: screenHeight * 0.45,
                    width: screenWidth * 0.47,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/student.jpeg'),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: screenHeight * 0.08,
                          width: screenWidth * 0.47,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(133, 53, 8, 57),
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(15),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Student Login',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    var box = await Hive.openBox(tokenBox);
                    String? token = box.get('token');
                    if (token != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Warden(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: screenHeight * 0.45,
                    width: screenWidth * 0.47,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/warden.jpeg'),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: screenHeight * 0.08,
                          width: screenWidth * 0.47,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(133, 53, 8, 57),
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(15),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Warden Login',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
