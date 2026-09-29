import 'package:flutter/material.dart';

class DosageCalculatorPage extends StatefulWidget {
  const DosageCalculatorPage({super.key});

  @override
  State<DosageCalculatorPage> createState() => _DosageCalculatorPageState();
}

class _DosageCalculatorPageState extends State<DosageCalculatorPage> {
  bool useAge = true;
  bool isLiquid = true;

  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final doseController = TextEditingController();
  final frequencyController = TextEditingController();

  final concentrationMgController = TextEditingController();
  final concentrationMlController = TextEditingController();

  String? result;

  @override
  void dispose() {
    ageController.dispose();
    weightController.dispose();
    doseController.dispose();
    frequencyController.dispose();
    concentrationMgController.dispose();
    concentrationMlController.dispose();
    super.dispose();
  }

  void calculate() {
    final dose = double.tryParse(doseController.text);
    final frequency = double.tryParse(frequencyController.text);

    if (dose == null || frequency == null) {
      setState(() {
        result = 'Enter valid dose and frequency';
      });
      return;
    }

    if (useAge) {
      final age = int.tryParse(ageController.text);

      if (age == null) {
        setState(() {
          result = 'Enter a valid age';
        });
        return;
      }
    } else {
      final weight = double.tryParse(weightController.text);

      if (weight == null) {
        setState(() {
          result = 'Enter a valid weight';
        });
        return;
      }
    }

    // Example calculation only.
    //
    // The actual calculation strategy should be implemented separately.
    double calculatedDose;

    if (useAge) {
      calculatedDose = dose;
    } else {
      final weight = double.parse(weightController.text);
      calculatedDose = dose * weight;
    }

    String calculatedResult =
        '${calculatedDose.toStringAsFixed(2)} mg';

    if (isLiquid) {
      final concentrationMg =
          double.tryParse(concentrationMgController.text);
      final concentrationMl =
          double.tryParse(concentrationMlController.text);

      if (concentrationMg == null || concentrationMl == null) {
        setState(() {
          result = 'Enter a valid concentration';
        });
        return;
      }

      final volume =
          calculatedDose * concentrationMl / concentrationMg;

      calculatedResult +=
          '\n${volume.toStringAsFixed(2)} mL';
    }

    setState(() {
      result = calculatedResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 244, 244),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 430,
              ),
              child: Column(
                children: [
                  _title(),
                  const SizedBox(height: 24),

                  _ageWeightSelector(),

                  const SizedBox(height: 12),

                  if (useAge)
                    _inputField(
                      controller: ageController,
                      label: 'edad',
                      keyboardType: TextInputType.number,
                    )
                  else
                    _inputField(
                      controller: weightController,
                      label: 'kg',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),

                  const SizedBox(height: 16),

                  _inputField(
                    controller: doseController,
                    label: 'unidad de dosis (mg)',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _inputField(
                    controller: frequencyController,
                    label: 'frecuencia',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _formulationHeader(),

                  const SizedBox(height: 14),

                  _formulationSelector(),

                  if (isLiquid) ...[
                    const SizedBox(height: 18),

                    _inputField(
                      controller: concentrationMgController,
                      label: 'Concentracion',
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _smallInput(
                            controller: concentrationMgController,
                            label: 'mg',
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            '/',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 26,
                            ),
                          ),
                        ),

                        Expanded(
                          child: _smallInput(
                            controller: concentrationMlController,
                            label: 'mL',
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 28),

                  _calculateButton(),

                  if (result != null) ...[
                    const SizedBox(height: 24),
                    _resultCard(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 67, 199, 247),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: const Color.fromARGB(255, 9, 9, 9),
          width: 1,
        ),
      ),
      child: const Text(
        'Calculadora de dosis',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color.fromARGB(255, 3, 3, 3),
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _ageWeightSelector() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 246, 249, 250),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: const Color.fromARGB(255, 0, 0, 0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _selectorButton(
              text: 'Edad',
              selected: useAge,
              onTap: () {
                setState(() {
                  useAge = true;
                });
              },
            ),
          ),
          Expanded(
            child: _selectorButton(
              text: 'kg',
              selected: !useAge,
              onTap: () {
                setState(() {
                  useAge = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectorButton({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: selected
              ? const Color.fromARGB(255, 67, 199, 247)
              : const Color.fromARGB(0, 0, 0, 0),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: selected
                  ? const Color.fromARGB(255, 0, 0, 0)
                  : const Color.fromARGB(179, 14, 14, 14),
              fontSize: 17,
              
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Color.fromARGB(255, 0, 0, 0),
        fontSize: 17,
      ),
      decoration: InputDecoration(
        
         labelText: label,
        labelStyle: const TextStyle(
          color: Color.fromARGB(179, 0, 0, 0),
        ),
        floatingLabelStyle: const TextStyle(
          color: Color.fromARGB(255, 4, 4, 4),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 252, 250, 254),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 4, 4, 4),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 67, 199, 247),
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _smallInput({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color.fromARGB(179, 7, 7, 7),
        ),
        floatingLabelStyle: const TextStyle(
          color: Color.fromARGB(255, 4, 4, 4),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 189, 233, 255),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _formulationHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 67, 199, 247),
        borderRadius: BorderRadius.circular(5),
         border: Border.all(
          color: const Color.fromARGB(255, 9, 9, 9),
          width: 1,
        ),
      ),
      child: const Text(
        'Formulacion',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _formulationSelector() {
    return Row(
      children: [
        Expanded(
          child: _formulationButton(
            text: 'Solido',
            selected: !isLiquid,
            onTap: () {
              setState(() {
                isLiquid = false;
              });
            },
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          child: _formulationButton(
            text: 'Liquido',
            selected: isLiquid,
            onTap: () {
              setState(() {
                isLiquid = true;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _formulationButton({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 177, 234, 255),
          borderRadius: BorderRadius.circular(5),
          border: selected
              ? Border.all(
                  color: const Color.fromARGB(255, 2, 2, 2),
                  width: 1,
                )
              : null,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _calculateButton() {
    return SizedBox(
      width: 210,
      height: 54,
      child: ElevatedButton(
        onPressed: calculate,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 170, 231, 255),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: const BorderSide(
              color: Color.fromARGB(255, 1, 1, 1),
              width: 1,
            ),
          ),
        ),
        child: const Text(
          'Calcular',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _resultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 247, 245, 247),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: const Color.fromARGB(255, 52, 170, 255),
          width: 2,
        ),
      ),
      child: Text(
        result!,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color.fromARGB(255, 5, 5, 5),
          fontSize: 19,
          height: 1.6,
        ),
      ),
    );
  }
}