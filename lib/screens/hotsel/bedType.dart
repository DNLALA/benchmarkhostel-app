// ignore_for_file: use_build_context_synchronously
import 'package:benchmarkhostel/api/base.dart';
import 'package:benchmarkhostel/componets/botton/SubmitBotton.dart';
import 'package:benchmarkhostel/componets/botton/choise.dart';
import 'package:benchmarkhostel/screens/home/home.dart';
import 'package:benchmarkhostel/screens/warden/newStudent.dart';
import 'package:benchmarkhostel/services/sharedPreferences/sharedPreferences.dart';
import 'package:flutter/material.dart';

class BedType extends StatefulWidget {
  final String roomType;
  final String seater;
  final String hostel;
  final String roomNumber;

  const BedType({
    Key? key,
    required this.roomType,
    required this.seater,
    required this.hostel,
    required this.roomNumber,
  }) : super(key: key);

  @override
  State<BedType> createState() => _BedTypeState();
}

class _BedTypeState extends State<BedType> {
  String? bed;
  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Student Dashboard",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text(
                  "Choose Any Bed",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ChoiceButton(
                  buttonText: 'A',
                  onPressed: () {
                    setState(() {
                      bed = 'A';
                    });
                  },
                  textColor: Colors.black,
                  isActive: bed == 'A',
                ),
                const SizedBox(height: 10),
                ChoiceButton(
                  buttonText: 'B',
                  onPressed: () {
                    setState(() {
                      bed = 'B';
                    });
                  },
                  textColor: Colors.black,
                  isActive: bed == 'B',
                ),
                const SizedBox(height: 10),
                ChoiceButton(
                  buttonText: 'C',
                  onPressed: () {
                    setState(() {
                      bed = 'C';
                    });
                  },
                  textColor: Colors.black,
                  isActive: bed == 'C',
                ),
                const SizedBox(height: 10),
                ChoiceButton(
                  buttonText: 'D',
                  onPressed: () {
                    setState(() {
                      bed = 'D';
                    });
                  },
                  textColor: Colors.black,
                  isActive: bed == 'D',
                ),
              ],
            ),
            Column(
              children: [
                SubmitButton(
                  buttonText: "Submit",
                  textColor: Colors.white,
                  onPressed: nextPage,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> nextPage() async {
    if (bed != null) {
      String? userID = sharedPreferences!.getString("uid");
      showDialog(
          context: context,
          builder: (c) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 160, 98, 160),
              ),
            );
          });

      bool? isStudent = sharedPreferences!.getBool("is_student");
      if (isStudent != null) {
        if (isStudent == true) {
          var result = await newHostel(
            widget.roomType,
            widget.seater,
            widget.hostel,
            widget.roomNumber,
            bed!,
            userID!,
          );
          if (result is String && result == widget.roomType) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Success'),
                duration: Duration(seconds: 2),
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          } else {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('failed: $result'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewStudentCreate(
                roomType: widget.roomType,
                seater: widget.seater,
                hostel: widget.hostel,
                roomNumber: widget.roomNumber,
                bed: bed!,
              ),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select bed'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
