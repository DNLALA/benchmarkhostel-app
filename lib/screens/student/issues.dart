// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:convert';
import 'package:benchmarkhostel/services/Token.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import '../../api/base.dart';

class IssuesScreen extends StatefulWidget {
  final int id;

  const IssuesScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<IssuesScreen> createState() => _IssuesScreenState();
}

class _IssuesScreenState extends State<IssuesScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _requestController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = true;
  bool _hasRequest = false;

  @override
  void initState() {
    super.initState();
    _checkUserRequest();
  }

  Future<void> _checkUserRequest() async {
    var box = await Hive.openBox(tokenBox);
    String token = box.get('token');

    var url = Uri.parse('$baseUrl/hostel/issues/${widget.id}/');
    var res = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (res.statusCode == 200) {
      setState(() {
        _hasRequest = true;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _submitRequest() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      String request = _requestController.text;
      String email = _emailController.text;

      var box = await Hive.openBox(tokenBox);
      String token = box.get('token');

      var url = Uri.parse('$baseUrl/hostel/issues-create');
      var res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode({
          'email': email,
          'issues': request,
          'hostel': widget.id,
        }),
      );
      print(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request submitted successfully')),
        );
        setState(() {
          _hasRequest = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit request')),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Rase an Issues',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasRequest
              ? const Center(
                  child: Text(
                    'Your request is under process',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your request';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _requestController,
                          decoration: const InputDecoration(
                            labelText: 'Request',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your request';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submitRequest,
                          child: const Text('Submit Request'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
