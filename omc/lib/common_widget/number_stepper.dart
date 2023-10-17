import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omc/common_widget/button_style.dart';

class NumberStepper extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double initialValue;
  final ValueChanged<double> onChanged;

  NumberStepper({
    Key? key,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<NumberStepper> createState() => _NumberStepperState();
}

class _NumberStepperState extends State<NumberStepper> {
  late double _currentValue;
  bool _isIncrementing = false;
  bool _isDecrementing = false;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final numberFormatter = NumberFormat.decimalPattern('en_US');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            _decrementValue();
          },
          onLongPress: () {
            _startDecrementTimer();
          },
          onLongPressEnd: (_) {
            _stopTimer();
          },
          child: IconButton(
            style: CustomButtonStyle.outlinedButton,
            icon: const Icon(Icons.remove),
            onPressed: () {
              if (!_isDecrementing && _currentValue > widget.minValue) {
                _decrementValue();
              }
            },
          ),
        ),
        Text(
          numberFormatter.format(_currentValue),
          style: const TextStyle(fontSize: 24),
        ),
        GestureDetector(
          onTap: () {
            _incrementValue();
          },
          onLongPress: () {
            _startIncrementTimer();
          },
          onLongPressEnd: (_) {
            _stopTimer();
          },
          child: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (!_isIncrementing && _currentValue < widget.maxValue) {
                _incrementValue();
              }
            },
          ),
        ),
      ],
    );
  }

  void _decrementValue() {
    setState(() {
      _currentValue -= 0.1;
      widget.onChanged(_currentValue);
    });
  }

  void _incrementValue() {
    setState(() {
      _currentValue += 0.1;
      widget.onChanged(_currentValue);
    });
  }

  Timer? _timer;

  void _startIncrementTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 5), (_) {
      if (_currentValue < widget.maxValue) {
        _incrementValue();
      }
    });
    setState(() {
      _isIncrementing = true;
    });
  }

  void _startDecrementTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 5), (_) {
      if (_currentValue > widget.minValue) {
        _decrementValue();
      }
    });
    setState(() {
      _isDecrementing = true;
    });
  }

  void _stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    setState(() {
      _isIncrementing = false;
      _isDecrementing = false;
    });
  }
}
