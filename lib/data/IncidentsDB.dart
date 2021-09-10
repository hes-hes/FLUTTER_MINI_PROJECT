

import 'package:clean_city_app/models/Incident.dart';

class IncidentsDB{

  List<Incident> _incidents = [];
  List<Incident> _closedIncidents = [];

  static IncidentsDB _instance;

  IncidentsDB._internal();

  static IncidentsDB getInstance(){
    if(_instance == null){
      _instance = IncidentsDB._internal();
    }
    return _instance;
  }

  IncidentsDB();

  int getLength() => _incidents.length;

  List getAllActives() => _incidents;

  List getAllClosed() => _closedIncidents;

  void insertIncident(Incident i){
    _incidents.add(i);
  }

  void closeIncident(Incident i){
    _closedIncidents.add(i);
    for(var pos=0; pos <_incidents.length; pos++){
      if(_incidents[pos].getTitle() == i.getTitle()){
        _incidents.removeAt(pos);
      }
    }
  }

  void deleteIncident(Incident i){
    for(var pos=0; pos <_incidents.length; pos++){
      if(_incidents[pos].getTitle() == i.getTitle()){
        _incidents.removeAt(pos);
      }
    }
  }

  bool isAvailableTitle(String title){
    for(var pos=0; pos <_incidents.length; pos++){
      if(_incidents[pos].getTitle() == title){
        return false;
      }
    }
    return true;
  }

  void clearClosedIncidents(){
    _closedIncidents.clear();
  }

  void editIncident(Incident i, String title, String address, String description){

    for(var pos=0; pos <_incidents.length; pos++){
      if(_incidents[pos].getTitle() == i.getTitle()){

        Incident newIncident = new Incident(
          title,
          description,
          address,
          _incidents[pos].getDateTime(),
        );
        newIncident.setStatus(_incidents[pos].getStatus());
        newIncident.createTile();
        insertIncident(newIncident);
        _incidents.removeAt(pos);
      }
    }
  }

}
