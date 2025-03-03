import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weatherController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedCondition = 'ฝนตก';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เพิ่มข้อมูลสภาพอากาศ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ช่องกรอกสภาพอากาศ
              TextFormField(
                controller: _weatherController,
                decoration: const InputDecoration(labelText: 'สภาพอากาศ'),
                keyboardType: TextInputType.text,  // ใช้แป้นพิมพ์ทั่วไป
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกสภาพอากาศ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // ช่องกรอกอุณหภูมิ
              TextFormField(
                controller: _temperatureController,
                decoration: const InputDecoration(labelText: 'อุณหภูมิ'),
                keyboardType: TextInputType.number,  // ใช้แป้นพิมพ์ตัวเลข
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกอุณหภูมิ';
                  }
                  if (int.tryParse(value) == null) {
                    return 'กรุณากรอกตัวเลขสำหรับอุณหภูมิ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // ตัวเลือกวันที่
              ListTile(
                title: Text(
                  _selectedDate == null
                      ? 'เลือกวันที่'
                      : 'วันที่: ${_selectedDate!.toLocal()}'.split(' ')[0],
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null && pickedDate != _selectedDate) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
              ),
              const SizedBox(height: 10),

              // Dropdown สำหรับเลือกประเภทของสภาพอากาศ
              DropdownButtonFormField<String>(
                value: _selectedCondition,
                items: ['ฝนตก', 'ฟ้าครึ้ม', 'เมฆมาก', 'แดด']
                    .map((condition) => DropdownMenuItem(
                          value: condition,
                          child: Text(condition),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCondition = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'ประเภทสภาพอากาศ'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาเลือกประเภทสภาพอากาศ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // ปุ่มส่งข้อมูล
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _selectedDate != null) {
                      Navigator.pop(context, {
                        'weather': _weatherController.text,
                        'temperature': int.parse(_temperatureController.text),
                        'date': _selectedDate,
                        'condition': _selectedCondition,
                      });
                    }
                  },
                  child: const Text('บันทึก'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
