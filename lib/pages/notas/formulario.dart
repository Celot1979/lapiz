// my_form_page.dart
import 'package:flutter/material.dart';

class MyFormPage extends StatelessWidget {
  const MyFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario de Prueba'),
      ),
      body: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  String _textField1Value = '';
  String _textField2Value = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Campo 1'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduce texto';
                }
                return null;
              },
              onSaved: (value) {
                _textField1Value = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Campo 2'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduce texto';
                }
                return null;
              },
              onSaved: (value) {
                _textField2Value = value!;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  print('Campo 1: $_textField1Value, Campo 2: $_textField2Value');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Procesando datos')),
                  );
                }
              },
              child: Text('Prueba'),
            ),
          ],
        ),
      ),
    );
  }
}