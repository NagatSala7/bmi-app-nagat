import 'package:flutter/material.dart';

class BmiSummaryPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const BmiSummaryPage({
    super.key,
    required this.data,
  });

  double getBmi() {
    dynamic value;

    if (data['data'] is Map) {
      value = data['data']['bmi'];
    }

    value ??= data['bmi'];

    return double.tryParse(
      value?.toString() ?? '0',
    ) ??
        0.0;
  }

  String getHeight() {
    dynamic value;

    if (data['data'] is Map) {
      value = data['data']['height'];
    }

    value ??= data['height'];

    return value?.toString() ?? '0';
  }

  String getWeight() {
    dynamic value;

    if (data['data'] is Map) {
      value = data['data']['weight'];
    }

    value ??= data['weight'];

    return value?.toString() ?? '0';
  }

  int getAge() {
    final String? birthText =
    data['birthDate']?.toString();

    if (birthText == null ||
        birthText.isEmpty) {
      return 0;
    }

    final DateTime? birthDate =
    DateTime.tryParse(birthText);

    if (birthDate == null) {
      return 0;
    }

    final DateTime today =
    DateTime.now();

    int age =
        today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month &&
            today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  String getCategory() {
    final double bmi = getBmi();

    if (bmi < 18.5) {
      return 'Under Weight';
    }

    if (bmi < 25) {
      return 'Normal Weight';
    }

    if (bmi < 30) {
      return 'Over Weight';
    }

    return 'Obesity';
  }

  String getDescription() {
    final double bmi = getBmi();

    if (bmi < 18.5) {
      return 'Your BMI is less than 18.5';
    }

    if (bmi < 25) {
      return 'Your BMI is in the normal range';
    }

    if (bmi < 30) {
      return 'Your BMI is in the overweight range';
    }

    return 'Your BMI is in the obesity range';
  }

  @override
  Widget build(BuildContext context) {
    final String name =
        data['name']?.toString() ?? 'Unknown';

    final String gender =
        data['gender']?.toString() ?? 'Unknown';

    final int age = getAge();

    final double bmi = getBmi();

    final String height = getHeight();

    final String weight = getWeight();

    return Scaffold(
      appBar: AppBar(),

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 298,
              decoration: BoxDecoration(
                color: const Color(0xff7876CD),
                borderRadius:
                BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(
                        left: 30,
                        top: 30,
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style:
                            const TextStyle(
                              fontSize: 22,
                              fontWeight:
                              FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),

                          Text(
                            'A $age years old $gender .',
                            style:
                            const TextStyle(
                              fontSize: 15,
                              fontWeight:
                              FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Column(
                            children: [
                              Text(
                                bmi.toStringAsFixed(1),
                                style:
                                const TextStyle(
                                  fontSize: 35,
                                  fontWeight:
                                  FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),

                              const Text(
                                'BMI Calc',
                                style:
                                TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '$height cm',
                                    style:
                                    const TextStyle(
                                      fontSize: 20,
                                      fontWeight:
                                      FontWeight.w700,
                                      color:
                                      Colors.white,
                                    ),
                                  ),

                                  const Text(
                                    'Height',
                                    style:
                                    TextStyle(
                                      fontSize: 15,
                                      fontWeight:
                                      FontWeight.w500,
                                      color:
                                      Colors.white,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                width: 20,
                              ),

                              Container(
                                height: 50,
                                width: 2,
                                color: Colors.white,
                              ),

                              const SizedBox(
                                width: 20,
                              ),

                              Column(
                                children: [
                                  Text(
                                    '$weight kg',
                                    style:
                                    const TextStyle(
                                      fontSize: 20,
                                      fontWeight:
                                      FontWeight.w700,
                                      color:
                                      Colors.white,
                                    ),
                                  ),

                                  const Text(
                                    'Weight',
                                    style:
                                    TextStyle(
                                      fontSize: 15,
                                      fontWeight:
                                      FontWeight.w500,
                                      color:
                                      Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 80,
                    height: 280,
                    child: Image.asset(
                      'lib/assets/body.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Container(
              width: double.infinity,
              height: 350,
              padding:
              const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff01502E),
                borderRadius:
                BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    getCategory(),
                    style:
                    const TextStyle(
                      fontSize: 22,
                      fontWeight:
                      FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    getDescription(),
                    style:
                    const TextStyle(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  const Text(
                    'Lorem ipsum dolor sit amet consectetur. '
                        'Sagittis interdum dui enim imperdiet sapien cursus velit '
                        'pharetra. Viverra justo tempor dictum odio. Nisl non dui '
                        'integer orci nulla eget laoreet tellus. Orci nunc a orci '
                        'convallis ac orci. Urna auctor at elementum sit ante '
                        'maecenas ullamcorper rhoncus. Morbi venenatis lectus '
                        'ultrices euismod. Laoreet purus risus amet enim sagittis ut. '
                        'Consectetur libero orci urna.',
                    style:
                    TextStyle(
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 40,
            ),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(0xFF484783),
                ),
                child: const Text(
                  'calculate BMI again',
                  style:
                  TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}