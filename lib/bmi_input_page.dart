import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bmi_summary_page.dart';

class BmiInputPage extends StatefulWidget {
  const BmiInputPage({super.key});

  @override
  State<BmiInputPage> createState() => _BmiInputPageState();
}

class _BmiInputPageState extends State<BmiInputPage> {
  final TextEditingController nameController =
  TextEditingController();

  final TextEditingController birthController =
  TextEditingController();

  final TextEditingController heightController =
  TextEditingController(text: '170');

  final TextEditingController weightController =
  TextEditingController(text: '70');

  final GlobalKey<FormState> formKey =
  GlobalKey<FormState>();

  final Dio dio = Dio();

  int selectedGender = 0;

  bool isLoading = false;

  static const String apiUrl =
      'https://api.apiverve.com/v1/bmicalculator';

  static const String apiKey =
      'ff870e7d-5d78-4309-82bc-0b5e0347db0f';

  @override
  void dispose() {
    nameController.dispose();
    birthController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  Future<void> selectBirthDate() async {
    final DateTime? selectedDate =
    await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDate: DateTime(2000),
    );

    if (selectedDate != null) {
      birthController.text =
      '${selectedDate.year}-'
          '${selectedDate.month.toString().padLeft(2, '0')}-'
          '${selectedDate.day.toString().padLeft(2, '0')}';
    }
  }

  void changeNumber(
      TextEditingController controller,
      int amount,
      ) {
    int number =
        int.tryParse(controller.text) ?? 0;

    number += amount;

    if (number < 1) {
      number = 1;
    }

    controller.text = number.toString();

    setState(() {});
  }

  Future<void> calculateBmi() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await dio.get(
        apiUrl,
        queryParameters: {
          'weight': weightController.text,
          'height': heightController.text,
          'unit': 'metric',
        },
        options: Options(
          headers: {
            'x-api-key': apiKey,
          },
        ),
      );

      print('API RESPONSE:');
      print(response.data);

      if (!mounted) {
        return;
      }

      final Map<String, dynamic> result =
      Map<String, dynamic>.from(
        response.data,
      );

      result['name'] = nameController.text;
      result['birthDate'] = birthController.text;
      result['gender'] =
      selectedGender == 0 ? 'Male' : 'Female';

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              BmiSummaryPage(data: result),
        ),
      );
    } on DioException catch (error) {
      if (!mounted) {
        return;
      }

      String message = 'Something went wrong';

      if (error.response != null) {
        message =
        'API Error: ${error.response?.statusCode}';
      } else {
        message =
            error.message ?? 'Connection error';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  InputDecoration inputDecoration() {
    return InputDecoration(
      counterText: '',
      filled: true,
      fillColor: const Color(0x26B3B2EA),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget genderContainer({
    required String image,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        width: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0x26B3B2EA),
          border: selected
              ? Border.all(
            width: 1,
            color: const Color(0xE501502E),
          )
              : null,
        ),
        child: Image.asset(
          image,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget numberField({
    required TextEditingController controller,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: inputDecoration().copyWith(
        suffixIcon: IconButton(
          onPressed: onAdd,
          icon: const Icon(
            Icons.add,
            size: 26,
            color: Colors.black,
          ),
        ),
        prefixIcon: IconButton(
          onPressed: onRemove,
          icon: const Icon(
            Icons.remove,
            size: 26,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BMI',
          style: TextStyle(
            letterSpacing: 20,
            fontWeight: FontWeight.w900,
            fontSize: 26,
            color: Color(0xE501502E),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                'Name',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: nameController,
                maxLength: 50,
                decoration: inputDecoration(),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'this is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              const Text(
                'birth date',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: birthController,
                readOnly: true,
                maxLength: 50,
                onTap: selectBirthDate,
                decoration: inputDecoration(),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'please, enter your birth date';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              const Text(
                'select gender',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  genderContainer(
                    image: 'lib/assets/male.png',
                    selected:
                    selectedGender == 0,
                    onTap: () {
                      setState(() {
                        selectedGender = 0;
                      });
                    },
                  ),

                  const SizedBox(width: 40),

                  genderContainer(
                    image: 'lib/assets/female.png',
                    selected:
                    selectedGender == 1,
                    onTap: () {
                      setState(() {
                        selectedGender = 1;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 18),

              const Text(
                'Your Height(cm)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              numberField(
                controller: heightController,
                onAdd: () {
                  changeNumber(
                    heightController,
                    1,
                  );
                },
                onRemove: () {
                  changeNumber(
                    heightController,
                    -1,
                  );
                },
              ),

              const SizedBox(height: 18),

              const Text(
                'Your Weight(kg)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              numberField(
                controller: weightController,
                onAdd: () {
                  changeNumber(
                    weightController,
                    1,
                  );
                },
                onRemove: () {
                  changeNumber(
                    weightController,
                    -1,
                  );
                },
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(9),
                    ),
                    backgroundColor:
                    const Color(0xff484783),
                  ),
                  onPressed:
                  isLoading ? null : calculateBmi,
                  child: isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'Calculate BMI',
                    style: TextStyle(
                      fontWeight:
                      FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}