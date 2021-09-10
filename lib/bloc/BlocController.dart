import 'package:clean_city_app/data/IncidentsDB.dart';
import 'package:clean_city_app/models/Incident.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class BlocController {

  Widget validateInsertFormInput(String titulo,
      String morada, String descricao, IncidentsDB data){

    if(titulo.isEmpty){
      return Text("Adiciona um titulo ao incidente.");
    }

    if(titulo.length > 25){
      return Text("O titulo deve ter no máximo 25 caracteres.");
    }

    if(!data.isAvailableTitle(titulo)){
      return Text("Este incidente já se encontra registado.");
    }

    if(descricao.isEmpty){
      return Text("Adiciona uma descrição do incidente.");
    }

    if(descricao.length < 100 || descricao.length > 200){
      return Text("A descrição deve ter de 100 a 200 caracteres.");
    }

    if(morada.isNotEmpty && morada.length > 60){
      return Text("A morada deve ter no máximo 60 caracteres.");
    }

    data.insertIncident(Incident(
        titulo,
        descricao,
        morada,
        DateTime.now()
    ));
    return Text("O seu incidente foi submetido com sucesso.");
  }

  Widget validateEditionFormInput(Incident incident, String titulo,
      String morada, String descricao, IncidentsDB data){
    if(titulo.isEmpty){
      return Text("Adiciona um titulo ao incidente.");
    }

    if(titulo.length > 25){
      return Text("O titulo deve ter no máximo 25 caracteres.");
    }

    if(!data.isAvailableTitle(titulo)){
      return Text("Este incidente já se encontra registado.");
    }

    if(descricao.length < 100 || descricao.length > 200){
      return Text("A descrição deve ter de 100 a 200 caracteres.");
    }

    if(morada.isNotEmpty && morada.length > 60){
      return Text("A morada deve ter no máximo 60 caracteres.");
    }

    data.editIncident(incident,titulo, descricao, morada);
    incident.createTile();
    return Text("O seu incidente foi editado com sucesso.");
  }

  Widget solveIncident(Incident incident, IncidentsDB data){
    if(incident.getStatus() == "ABERTO"){
      incident.setStatus("RESOLVIDO");
      incident.createTile();
      return Text("O seu incidente foi dado como resolvido.");
    }
    return Text("Este incidente não pode ser resolvido");
  }

  Widget closeIncident(Incident incident, IncidentsDB data){
    if(incident.getStatus() == "RESOLVIDO"){
      incident.setStatus("FECHADO");
      data.closeIncident(incident);
      incident.createTile();
      return Text("O seu incidente foi dado como fechado.");
    }
    return Text("Este incidente ainda não se encontra resolvido, "
        "por isso não pode transitar para a lista dos fechados");
  }

  Widget deleteIncident(Incident incident, IncidentsDB data){

    if(incident.getStatus() != "ABERTO"){
      return Text("O incidente selecionado não pode ser eliminado.");
    }

    data.deleteIncident(incident);
    return Text("O incidente selecionado foi eliminado com sucesso.");

  }

  Widget clearClosedIncidents(IncidentsDB data){
    data.clearClosedIncidents();
    return Text("A lista foi limpada com sucesso.");
  }

  bool randomSolver(IncidentsDB data){
    if(data.getAllActives().length < 3){
      return false;
    }
    var idx = Random().nextInt(data.getAllActives().length-1);
    data.getAllActives()[idx].setStatus("RESOLVIDO");
    data.getAllActives()[idx].createTile();
    return true;
  }

}