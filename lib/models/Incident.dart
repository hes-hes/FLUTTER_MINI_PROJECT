import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Incident {

  String _title;
  String _description;
  String _address;
  DateTime _dateTime;
  String _status = "ABERTO";
  ListTile _tile;


  Incident(String title, String description, String address, DateTime dateTime){
    _title = title;
    _description = description;
    _address = address;
    _dateTime = dateTime;
    _tile = createTile();
  }

  String getTitle()=> _title;

  String getAddress()=> _address;

  String getDescription()=> _description;

  String getStatus() => _status;

  Widget getListTile() => _tile;

  DateTime getDateTime() => _dateTime;

  void setStatus(String st) => _status=st;

  String dateToString(){
    String dia, mes, hora, minuto;

    if(_dateTime.day < 10){
      dia = "0${_dateTime.day}";
    }
    else{
      dia = "${_dateTime.day}";
    }

    if(_dateTime.month < 10){
      mes = "0${_dateTime.month}";
    }
    else{
      mes = "${_dateTime.month}";
    }

    if(_dateTime.hour < 10){
      hora = "0${_dateTime.hour}";
    }
    else{
      hora = "${_dateTime.hour}";
    }

    if(_dateTime.minute < 10){
      minuto = "0${_dateTime.minute}";
    }
    else{
      minuto = "${_dateTime.minute}";
    }

    return
      "$dia/$mes/${_dateTime.year}-$hora:$minuto";
  }

  Widget createTile(){
    return ListTile(
        title: Text(
          _title+"\n",
          style: TextStyle(
            color: Colors.indigo.shade900,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          dateToString(),
          style: TextStyle(
            color: Colors.indigo.shade900,
          ),
        ),
        leading: Image.asset(
          getLeadingImage(),
        ),
        isThreeLine: true,
        trailing: Column(
            children:[
              Text(""),
              Icon(
                Icons.info_outline,
                color: Colors.indigo.shade900,
              ),
              Text(
                "info",
                style: TextStyle(
                    color: Colors.indigo.shade900
                ),
              ),
            ]
        )
    );
  }

  Color getTileColor(){
    if(_status == "ABERTO"){
      return Colors.blue.shade300;
    }
    if(_status == "RESOLVIDO"){
      return Colors.green.shade300;
    }
  }

  String getLeadingImage(){
    String name = "";
    if(_title[0] == "a" || _title[0] == "A"){
      name = "a";
    }
    else if(_title[0] == "b" || _title[0] == "B"){
      name = "b";
    }
    else if(_title[0] == "c" || _title[0] == "C"){
      name = "c";
    }
    else if(_title[0] == "d" || _title[0] == "D"){
      name = "d";
    }
    else if(_title[0] == "e" || _title[0] == "E"){
      name = "e";
    }
    else if(_title[0] == "f" || _title[0] == "F"){
      name = "f";
    }
    else if(_title[0] == "g" || _title[0] == "G"){
      name = "g";
    }
    else if(_title[0] == "h" || _title[0] == "H"){
      name = "h";
    }
    else if(_title[0] == "i" || _title[0] == "I"){
      name = "i";
    }
    else if(_title[0] == "j" || _title[0] == "J"){
      name = "j";
    }
    else if(_title[0] == "k" || _title[0] == "K"){
      name = "k";
    }
    else if(_title[0] == "l" || _title[0] == "L"){
      name = "l";
    }
    else if(_title[0] == "m" || _title[0] == "M"){
      name = "m";
    }
    else if(_title[0] == "n" || _title[0] == "N"){
      name = "n";
    }
    else if(_title[0] == "o" || _title[0] == "O"){
      name = "o";
    }
    else if(_title[0] == "p" || _title[0] == "P"){
      name = "p";
    }
    else if(_title[0] == "q" || _title[0] == "Q"){
      name = "q";
    }
    else if(_title[0] == "r" || _title[0] == "R"){
      name = "r";
    }
    else if(_title[0] == "s" || _title[0] == "S"){
      name = "s";
    }
    else if(_title[0] == "t" || _title[0] == "T"){
      name = "t";
    }
    else if(_title[0] == "u" || _title[0] == "U"){
      name = "u";
    }
    else if(_title[0] == "v" || _title[0] == "V"){
      name = "v";
    }
    else if(_title[0] == "w" || _title[0] == "W"){
      name = "w";
    }
    else if(_title[0] == "x" || _title[0] == "X"){
      name = "x";
    }
    else if(_title[0] == "y" || _title[0] == "Y"){
      name = "y";
    }
    else if(_title[0] == "z" || _title[0] == "Z"){
      name = "o";
    }
    else {
      name = "_other";
    }
    return "lib/assets/images/$name.png";
  }

  String getInfoButtonString(){
    if(_status == "ABERTO"){
      return "\nResolver\n";
    }
    if(_status == "RESOLVIDO"){
      return "\n  Fechar  \n";
    }
  }

}