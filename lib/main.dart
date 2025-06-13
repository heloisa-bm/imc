import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() => runApp(const RedFinanceApp());

class RedFinanceApp extends StatelessWidget {
  const RedFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulador Vermelho',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.red[50],
      ),
      home: const FinanceScreen(),
    );
  }
}

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  final _formKey = GlobalKey<FormState>();
  double _valor = 0;
  double _juros = 0;
  int _parcelas = 0;
  double _taxas = 0;
  double _total = 0;
  double _parcela = 0;

  void _calcular() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final taxaDecimal = _juros / 100;
      final montante = _valor * (pow(1 + taxaDecimal, _parcelas));
      _total = montante + _taxas;
      _parcela = _total / _parcelas;

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulador Vermelho'),
        backgroundColor: Colors.red[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInput(
                'Valor do financiamento',
                'R\$',
                (v) => _valor = double.parse(v),
              ),
              _buildInput(
                'Taxa de juros mensal',
                '%',
                (v) => _juros = double.parse(v),
              ),
              _buildInput(
                'Número de parcelas',
                '',
                (v) => _parcelas = int.parse(v),
              ),
              _buildInput(
                'Taxas adicionais',
                'R\$',
                (v) => _taxas = double.parse(v),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcular,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  'CALCULAR',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 30),
              Card(
                color: Colors.red[100],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildResult('Total a pagar:', _total),
                      _buildResult('Valor da parcela:', _parcela),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, String suffix, Function(String) onSaved) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.red[800]),
          suffixText: suffix,
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red[700]!),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Digite um valor';
          return null;
        },
        onSaved: (v) => onSaved(v!),
      ),
    );
  }

  Widget _buildResult(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.red[900],
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'R\$ ${value.toStringAsFixed(2)}',
            style: TextStyle(
              color: Colors.red[900],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
