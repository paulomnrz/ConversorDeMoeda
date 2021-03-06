import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance/quotations?format=json&key=98d971c3";

void main () async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
    ),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController realController = TextEditingController();
  TextEditingController dolarController = TextEditingController();
  TextEditingController euroController = TextEditingController();

  double dolar;
  double euro;

  _realChanged(String text){
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }
  _dolarChanged(String text){
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar/euro).toStringAsFixed(2);
  }
  _euroChanged(String text){
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("\$Conversor de Moedas\$"),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        body: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text(
                  "Carregando dados...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Carregando dados...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
              euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

              return SingleChildScrollView(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.monetization_on, size: 150.0,
                        color: Colors.amber),
                    buildTextField("Reais", "R\$ ", realController, _realChanged),
                    Divider(),
                    buildTextField("Doláres", "US\$ ", dolarController,_dolarChanged),
                    Divider(),
                    buildTextField("Euros", "€ ",euroController, _euroChanged),
                  ],
                ),
              );
            }
          },
          future: getData(),
        )
    );
  }

  Future<Map> getData() async {
    http.Response response = await http.get(request);
    return json.decode(response.body);
  }

  Widget buildTextField(String label, String prefix, TextEditingController controler, Function f){
    return TextField(
      controller: controler,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: Colors.amber
          ),
          border: OutlineInputBorder(),
          prefixText: prefix,
      ),
      style: TextStyle(
        color: Colors.amber,
        fontSize: 25,
      ),
      onChanged: f,
      keyboardType: TextInputType.number,
    );
  }

}