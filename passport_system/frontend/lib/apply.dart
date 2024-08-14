import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'user_dashboard.dart';

class Apply extends StatefulWidget {
  Apply({Key? key}) : super(key: key);

  @override
  _ApplyState createState() => _ApplyState();
}

class _ApplyState extends State<Apply> {
  final _pageController = PageController();
  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];

  // Controllers for Personal Info
  final _nationalIdController = TextEditingController();
  final _birthCertificateController = TextEditingController();
  final _citizenshipController = TextEditingController();
  final _dualCitizenshipController = TextEditingController();
  final _otherCitizenshipCountryController = TextEditingController();
  final _foreignPassportNoController = TextEditingController();
  final _maritalStatusController = TextEditingController();
  final _professionController = TextEditingController();
  final _contactNoController = TextEditingController();
  final _emailController = TextEditingController();

  // Controllers for Permanent Address
  final _permanentDistrictController = TextEditingController();
  final _permanentPoliceStationController = TextEditingController();
  final _permanentPostOfficeController = TextEditingController();
  final _permanentPostCodeController = TextEditingController();
  final _permanentCityController = TextEditingController();
  final _permanentRoadController = TextEditingController();

  // Controllers for Present Address
  final _presentDistrictController = TextEditingController();
  final _presentPoliceStationController = TextEditingController();
  final _presentPostOfficeController = TextEditingController();
  final _presentPostCodeController = TextEditingController();
  final _presentCityController = TextEditingController();
  final _presentRoadController = TextEditingController();

  int _currentStep = 0;

  Future<void> saveApplication() async {
    final applicationData = {
      'personalInfo': {
        'nationalId': _nationalIdController.text,
        'birthCertificate': _birthCertificateController.text,
        'citizenship': _citizenshipController.text,
        'dualCitizenship': _dualCitizenshipController.text,
        'otherCitizenshipCountry': _otherCitizenshipCountryController.text,
        'foreignPassportNo': _foreignPassportNoController.text,
        'maritalStatus': _maritalStatusController.text,
        'profession': _professionController.text,
        'contactNo': _contactNoController.text,
        'email': _emailController.text,
      },
      'permanentAddress': {
        'district': _permanentDistrictController.text,
        'policeStation': _permanentPoliceStationController.text,
        'postOffice': _permanentPostOfficeController.text,
        'postCode': _permanentPostCodeController.text,
        'city': _permanentCityController.text,
        'road': _permanentRoadController.text,
      },
      'presentAddress': {
        'district': _presentDistrictController.text,
        'policeStation': _presentPoliceStationController.text,
        'postOffice': _presentPostOfficeController.text,
        'postCode': _presentPostCodeController.text,
        'city': _presentCityController.text,
        'road': _presentRoadController.text,
      },
    };

    try {
      final response = await http.post(
        Uri.parse("http://localhost:8080/application"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(applicationData),
      );

      if (response.statusCode == 200) {
        print('Application successful: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Application successful!'),
            backgroundColor: Colors.green,
          ),
        );
        _clearFields();
      } else {
        print('Failed to apply: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to apply. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _clearFields() {
    _nationalIdController.clear();
    _birthCertificateController.clear();
    _citizenshipController.clear();
    _dualCitizenshipController.clear();
    _otherCitizenshipCountryController.clear();
    _foreignPassportNoController.clear();
    _maritalStatusController.clear();
    _professionController.clear();
    _contactNoController.clear();
    _emailController.clear();

    _permanentDistrictController.clear();
    _permanentPoliceStationController.clear();
    _permanentPostOfficeController.clear();
    _permanentPostCodeController.clear();
    _permanentCityController.clear();
    _permanentRoadController.clear();

    _presentDistrictController.clear();
    _presentPoliceStationController.clear();
    _presentPostOfficeController.clear();
    _presentPostCodeController.clear();
    _presentCityController.clear();
    _presentRoadController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Apply',
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            ),
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('images/wahab.png'),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildPersonalInfoForm(),
          _buildPermanentAddressForm(),
          _buildPresentAddressForm(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentStep > 0)
              ElevatedButton(
                onPressed: () {
                  if (_currentStep > 0) {
                    setState(() {
                      _currentStep--;
                    });
                    _pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: Text('Back'),
              ),
            ElevatedButton(
              onPressed: () {
                if (_formKeys[_currentStep].currentState?.validate() ?? false) {
                  if (_currentStep < 2) {
                    setState(() {
                      _currentStep++;
                    });
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    saveApplication();
                  }
                } else {
                  print("Form not valid");
                }
              },
              child: Text(_currentStep < 2 ? 'Next' : 'Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoForm() {
    return Form(
      key: _formKeys[0],
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Personal Information",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color.fromARGB(255, 0, 0, 0)),
            ),
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _nationalIdController,
                  decoration: InputDecoration(labelText: 'National ID No'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _birthCertificateController,
                  decoration:
                      InputDecoration(labelText: 'Birth Certificate No'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _citizenshipController,
                  decoration: InputDecoration(labelText: 'Type of Citizenship'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _dualCitizenshipController,
                  decoration: InputDecoration(labelText: 'Dual Citizenship'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _otherCitizenshipCountryController,
                  decoration: InputDecoration(
                      labelText: 'Country of Other Citizenship'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _foreignPassportNoController,
                  decoration: InputDecoration(labelText: 'Foreign Passport No'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _maritalStatusController,
                  decoration: InputDecoration(labelText: 'Marital Status'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _professionController,
                  decoration: InputDecoration(labelText: 'Profession'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _contactNoController,
                  decoration: InputDecoration(labelText: 'Contact No'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermanentAddressForm() {
    return Form(
      key: _formKeys[1],
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Permanent Address",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color.fromARGB(255, 0, 0, 0)),
            ),
            Column(
              children: [
                TextFormField(
                  controller: _permanentDistrictController,
                  decoration: InputDecoration(labelText: 'District'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _permanentPoliceStationController,
                  decoration: InputDecoration(labelText: 'Police Station'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _permanentPostOfficeController,
                  decoration: InputDecoration(labelText: 'Post Office'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _permanentPostCodeController,
                  decoration: InputDecoration(labelText: 'Post Code'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _permanentCityController,
                  decoration: InputDecoration(labelText: 'City'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _permanentRoadController,
                  decoration: InputDecoration(labelText: 'Road'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresentAddressForm() {
    return Form(
      key: _formKeys[2],
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Present Address",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color.fromARGB(255, 0, 0, 0)),
            ),
            Column(
              children: [
                TextFormField(
                  controller: _presentDistrictController,
                  decoration: InputDecoration(labelText: 'District'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _presentPoliceStationController,
                  decoration: InputDecoration(labelText: 'Police Station'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _presentPostOfficeController,
                  decoration: InputDecoration(labelText: 'Post Office'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _presentPostCodeController,
                  decoration: InputDecoration(labelText: 'Post Code'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _presentCityController,
                  decoration: InputDecoration(labelText: 'City'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _presentRoadController,
                  decoration: InputDecoration(labelText: 'Road'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
