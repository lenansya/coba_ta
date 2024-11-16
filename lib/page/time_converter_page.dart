// lib/screens/time_converter_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeConverterPage extends StatefulWidget {
  const TimeConverterPage({super.key});

  @override
  State<TimeConverterPage> createState() => _TimeConverterPageState();
}

class _TimeConverterPageState extends State<TimeConverterPage> {
  final TextEditingController _timeController = TextEditingController();
  final DateFormat _timeFormat = DateFormat("HH:mm");

  // Map zona waktu dengan selisih waktu dari UTC
  final Map<String, int> _timeZones = {
    'WIB': 7,       // Waktu Indonesia Barat (UTC+7)
    'WITA': 8,      // Waktu Indonesia Tengah (UTC+8)
    'WIT': 9,       // Waktu Indonesia Timur (UTC+9)
    'London': 0,    // GMT (UTC+0)
    'US': -5,       // Eastern Standard Time (UTC-5)
    'Arab Saudi': 3 // Arabia Standard Time (UTC+3)
  };

  String _fromTimeZone = 'WIB';
  String _toTimeZone = 'WITA';
  String _convertedTime = '';

  void _convertTime() {
    try {
      // Parsing waktu input ke DateTime
      final DateTime inputTime = _timeFormat.parse(_timeController.text);

      // Konversi ke UTC
      final int fromOffset = _timeZones[_fromTimeZone]!;
      final DateTime utcTime = inputTime.subtract(Duration(hours: fromOffset));

      // Konversi dari UTC ke zona waktu tujuan
      final int toOffset = _timeZones[_toTimeZone]!;
      final DateTime convertedTime = utcTime.add(Duration(hours: toOffset));

      setState(() {
        _convertedTime = _timeFormat.format(convertedTime);
      });
    } catch (e) {
      // Jika terjadi error saat parsing atau konversi waktu
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid time in HH:mm format')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Converter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Time Converter',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(
                labelText: 'Enter time (HH:mm)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _fromTimeZone,
                    onChanged: (value) {
                      setState(() {
                        _fromTimeZone = value!;
                      });
                    },
                    items: _timeZones.keys.map((zone) {
                      return DropdownMenuItem(
                        value: zone,
                        child: Text(zone),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'From',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _toTimeZone,
                    onChanged: (value) {
                      setState(() {
                        _toTimeZone = value!;
                      });
                    },
                    items: _timeZones.keys.map((zone) {
                      return DropdownMenuItem(
                        value: zone,
                        child: Text(zone),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'To',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _convertTime,
                child: const Text('Convert'),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                _convertedTime.isEmpty
                    ? 'Converted time will appear here'
                    : 'Converted Time: $_convertedTime $_toTimeZone',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }
}
