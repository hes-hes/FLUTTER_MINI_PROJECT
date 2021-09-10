/// Author: Héricles Emanuel Semedo - a21801188 - ULHT */

import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'bloc/BlocController.dart';
import 'data/IncidentsDB.dart';
import 'models/Incident.dart';

IncidentsDB _allIncidents = IncidentsDB();
BlocController _bloc = BlocController();

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Clean City",
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

///--------------------------- Splash Screen -----------------------------*/

class SplashScreen extends StatefulWidget {
  @override
  State <StatefulWidget> createState(){
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen>{
  @override
  void initState(){
    super.initState();
    setTimer();
  }

  setTimer() async{
    var duration = Duration(seconds: 7);
    return Timer(duration, route);
  }

  route(){
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (context) => ActivesListScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "lib/assets/images/logo.jpg",
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //App name
              Text(
                "Clean City",
                style: TextStyle(
                  fontFamily: 'Bellyluerd',
                  fontSize: 35,
                  color: Colors.indigo.shade900,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //App name
              Text(
                "",
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  backgroundColor: Colors.white,
                  strokeWidth: 1.0
              ),
            ],
          ),
        ],
      ),
    );
  }
}

///-----------------------------------------------------------------------*/

///------------------------ Actives List Screen --------------------------*/

class ActivesListScreen extends StatefulWidget{
  ActivesListScreen();

  @override
  _ActivesListScreenState createState() => _ActivesListScreenState();

}

class _ActivesListScreenState extends State<ActivesListScreen>{

  @override
  Widget build(BuildContext context) {

    ///----------------- Random Incident Solver ------------------
    if(DateTime.now().minute % 2 == 0
        && DateTime.now().second > 45
        && _bloc.randomSolver(_allIncidents)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showTopSnackBar(
          context,
          CustomSnackBar.info(
            message:
            "Um dos seus incidentes foi dado como resolvido.",
          ),
        );
      });
    }
    ///-----------------------------------------------------------

    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: getAppBar(),
      floatingActionButton: getAddNewFAB(),
      body: buildListView(),
    );
  }

  ListView buildListView(){
    return ListView.builder(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(bottom: 50),
      itemCount: _allIncidents.getAllActives().length,
      itemBuilder: (context, idx) => GestureDetector(
          child: Card(
            elevation: 4.0,
            color: _allIncidents.getAllActives()[idx].getTileColor(),
            child: _allIncidents.getAllActives()[idx].getListTile(),
          ),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InfoScreen(_allIncidents.getAllActives()[idx])),
            );
          },
          onHorizontalDragEnd: (dragEndDetails) {
            if (dragEndDetails.primaryVelocity > 0.5) {

              Text alertText = _bloc.closeIncident(_allIncidents.getAllActives()[idx], _allIncidents);

              Widget okButton = FlatButton(
                child: Text("OK"),
                onPressed: () {
                  if(alertText.data == "O seu incidente foi dado como resolvido."
                      || alertText.data == "O seu incidente foi dado como fechado."
                  ){
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                        builder: (context) => ActivesListScreen()), (route) => false);
                  }
                  else{
                    Navigator.pop(context);
                  }
                },
              );

              AlertDialog alert = AlertDialog(
                content: alertText,
                actions: [
                  okButton,
                ],
              );
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            }
          }
      ),
    );
  }

  Widget getAppBar(){
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.blue.shade900.withOpacity(1.0),
      title: Center(
          child: Column(
            children: [
              Text(
                "       "
                    "Clean City",
                style: TextStyle(
                  fontFamily: 'Bellyluerd',
                  fontSize: 35,
                  color: Colors.white,
                ),
              ),
              Text(
                "                    "
                    "Incidentes Ativos",
                style: TextStyle(
                    fontSize:12
                ),
              ),
            ],
          )
      ),
      actions: <Widget>[
        Row(
          children: [
            Text(
              "Fechados",
              style: TextStyle(
                  fontSize: 10
              ),
            ),
            IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                ),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ClosedsListScreen()),
                  );
                }
            )
          ],
        )
      ],
    );
  }

  Widget getAddNewFAB(){
    return FloatingActionButton.extended(
      backgroundColor: Colors.blue.shade900,
      icon: Icon(
        Icons.add,
        size: 25.0,
      ),
      label: Text(
        "Novo",
        style: TextStyle(
            color: Colors.white
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InsertNewFormScreen()),
        );
      },
    );
  }

}

///-----------------------------------------------------------------------*/

///------------------------ Insert New Form ------------------------------*/

class InsertNewFormScreen extends StatefulWidget{
  @override
  _InsertNewFormScreenState createState() => _InsertNewFormScreenState();
}

class _InsertNewFormScreenState extends State<InsertNewFormScreen> {

  String title, address, description;

  final titleController = TextEditingController();
  final addressController = TextEditingController();
  final descricaoController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    addressController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: getInsertForm(),
    );
  }

  Widget getAppBar(){
    return AppBar(
      leading: IconButton(
          icon: Icon(
              Icons.arrow_back,
              color: Colors.white
          ),
          onPressed: () {
            Navigator.of(context).pop();
          }
      ),
      backgroundColor: Colors.blue.shade900.withOpacity(1.0),
      title: Center(
        child: Text(
          "Clean City      ",
          style: TextStyle(
            fontFamily: 'Bellyluerd',
            fontSize: 35,
            color: Colors.white,
          ),
        ),
      ),
    );

  }

  Widget getInsertForm(){
    return Container(
      padding: EdgeInsets.only(
          left: 10.0,
          top: 10.0,
          right: 10.0,
          bottom: 10.0
      ),
      child: Form(
        child:Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Titulo',
                ),
                controller: titleController,
                onSaved: (String value) {
                  title = value;
                  print(title);
                },
              ),
              Text(""),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Descrição',
                ),
                controller: descricaoController,
                onSaved: (String value) {
                  description = value;
                  print(description);
                },
              ),
              Text(""),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Morada',
                ),
                controller: addressController,
                onSaved: (String value) {
                  address = value;
                  print(address);
                },
              ),
              getSubmitButton()
            ]
        ),
      ),
    );
  }

  Widget getSubmitButton(){
    return Container(
      padding: EdgeInsets.only(
          left: 10.0,
          top: 10.0,
          right: 10.0,
          bottom: 10.0
      ),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.blue.shade900)
        ),
        child: Text(
          '\nSubmeter\n',
          style: TextStyle(
              color: Colors.white
          ),
        ),
        color: Colors.blue.shade900,

        onPressed: () {

          title = titleController.text;
          address = addressController.text;
          description = descricaoController.text;

          Text alertText = _bloc.validateInsertFormInput(
            title,
            address,
            description,
            _allIncidents,
          );

          Widget okButton = FlatButton(
            child: Text("OK"),
            onPressed: () {
              if(alertText.data == "O seu incidente foi submetido com sucesso."){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                    builder: (context) => ActivesListScreen()), (route) => false);
              }
              else{
                Navigator.pop(context);
              }
            },
          );

          AlertDialog alert = AlertDialog(
            content: alertText,
            actions: [
              okButton,
            ],
          );
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return alert;
            },
          );
        },
      ),
    );
  }

}

///-----------------------------------------------------------------------*/

///--------------------------- Edition Form ------------------------------*/

class EditFormScreen extends StatefulWidget{
  Incident _incident;

  EditFormScreen(Incident incident){
    _incident = incident;
  }

  @override
  _EditFormScreenState createState() => _EditFormScreenState(_incident);
}

class _EditFormScreenState extends State<EditFormScreen> {

  Incident _incident;

  _EditFormScreenState(Incident i){
    _incident = i;
  }

  String title, address, description;

  final titleController = TextEditingController();
  final addressController = TextEditingController();
  final descricaoController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    addressController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(),
        body: getEditForm()
    );
  }

  Widget getAppBar(){
    return AppBar(
      leading: IconButton(
          icon: Icon(
              Icons.arrow_back,
              color: Colors.white
          ),
          onPressed: () {
            Navigator.of(context).pop();
          }
      ),
      backgroundColor: Colors.blue.shade900.withOpacity(1.0),
      title: Center(
        child: Text(
          "Clean City      ",
          style: TextStyle(
            fontFamily: 'Bellyluerd',
            fontSize: 35,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget getEditForm(){
    return Container(
      padding: EdgeInsets.only(
          left: 10.0,
          top: 10.0,
          right: 10.0,
          bottom: 10.0
      ),
      child: Form(
        child:Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Titulo',
                ),
                controller: titleController,
                onSaved: (String value) {
                  title = value;
                  print(title);
                },
              ),
              Text(""),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Descrição',
                ),
                controller: descricaoController,
                onSaved: (String value) {
                  description = value;
                  print(description);
                },
              ),
              Text(""),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Morada',
                ),
                controller: addressController,
                onSaved: (String value) {
                  address = value;
                  print(address);
                },
              ),
              getEditButton()
            ]
        ),
      ),
    );
  }

  Widget getEditButton(){
    return Container(
      padding: EdgeInsets.only(
          left: 10.0,
          top: 10.0,
          right: 10.0,
          bottom: 10.0
      ),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.blue.shade900)
        ),
        child: Text(
          '\nEditar\n',
          style: TextStyle(
              color: Colors.white
          ),
        ),
        color: Colors.blue.shade900,
        onPressed:() {
          title = titleController.text;
          address = addressController.text;
          description = descricaoController.text;

          Text alertText = _bloc.validateEditionFormInput(
              _incident, title, address, description, _allIncidents
          );

          Widget okButton = FlatButton(
            child: Text("OK"),
            onPressed: () {
              if(alertText.data == "O seu incidente foi editado com sucesso."){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                    builder: (context) => ActivesListScreen()), (route) => false);
              }
              else{
                Navigator.pop(context);
              }
            },
          );
          AlertDialog alert = AlertDialog(
            content: alertText,
            actions: [
              okButton,
            ],
          );
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return alert;
            },
          );
        },
      ),
    );
  }

}

///-----------------------------------------------------------------------*/

///--------------------------- Infos Screen ------------------------------*/

class InfoScreen extends StatefulWidget{
  Incident _incident;

  InfoScreen(Incident incident){
    _incident = incident;
  }

  Incident getIncident(){
    return _incident;
  }

  @override
  _InfoScreenState createState() => _InfoScreenState(_incident);
}

class _InfoScreenState extends State<InfoScreen> {

  Incident _incident;

  _InfoScreenState(Incident i){
    _incident = i;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(),
        body: getIncidentInfos()
    );
  }

  Widget getAppBar(){
    return AppBar(
      leading: IconButton(
          icon: Icon(
              Icons.arrow_back,
              color: Colors.white
          ),
          onPressed: () {
            Navigator.of(context).pop();
          }
      ),
      backgroundColor: Colors.blue.shade900.withOpacity(1.0),
      title: Center(
        child: Text(
          "Clean City      ",
          style: TextStyle(
            fontFamily: 'Bellyluerd',
            fontSize: 35,
            color: Colors.white,
          ),
        ),
      ),
      actions: [
        getDeleteIconButton()
      ],
    );
  }

  Widget getIncidentInfos(){
    return Container(
      padding: EdgeInsets.only(
          left: 10.0,
          top: 10.0,
          right: 10.0,
          bottom: 10.0
      ),
      child:Column(
        children: [
          //Initial
          Column(
            children: [
              Image.asset(_incident.getLeadingImage()),
            ],
          ),
          Text(""),
          //Titulo
          Row(
            children: [
              Text(
                "Titulo: ",
                style: TextStyle(
                    color: Colors.blue.shade900,
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text("${_incident.getTitle()}",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          Text(""),
          //Descricao
          Row(
            children: [
              Text(
                "Descrição: ",
                style: TextStyle(
                    color: Colors.blue.shade900,
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text("${_incident.getDescription()}",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          Text(""),
          //Date
          Row(
            children: [
              Text(
                "Registado em: ",
                style: TextStyle(
                    color: Colors.blue.shade900,
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text("${_incident.dateToString()}",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          Text(""),
          //Morada
          Row(
            children: [
              Text(
                "Morada: ",
                style: TextStyle(
                    color: Colors.blue.shade900,
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text("${_incident.getAddress()}",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          Text(""),
          Container(
              padding: EdgeInsets.only(
                  left: 10.0,
                  top: 10.0,
                  right: 10.0,
                  bottom: 10.0
              ),
              child: Column(
                children: [
                  Container(
                      child: getEditionRaisedButton()
                  ),
                  Text(""),
                  Container(
                      child: getSolveOrCloseRaisedButton()
                  )
                ],
              )
          )
        ],
      ),
    );
  }

  Widget getDeleteIconButton(){
    if(_incident.getStatus() == "ABERTO"){
      return IconButton(
        icon: Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onPressed: (){

          Widget cancelaButton = FlatButton(
            child: Text("Cancelar"),
            onPressed:  () {
              Navigator.pop(context);
            },
          );
          Widget continuaButton = FlatButton(
            child: Text("Eliminar"),
            onPressed:  () {
              Navigator.pop(context);
              Text alertText = _bloc.deleteIncident(_incident,_allIncidents);

              Widget okButton = FlatButton(
                child: Text("OK"),
                onPressed: () {
                  if(alertText.data == "O incidente selecionado foi eliminado com sucesso."){
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                        builder: (context) => ActivesListScreen()), (route) => false);
                  }
                  else{
                    Navigator.pop(context);
                  }
                },
              );

              AlertDialog alert = AlertDialog(
                content: alertText,
                actions: [
                  okButton,
                ],
              );

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
          );
          AlertDialog alert = AlertDialog(
            content: Text("Deseja mesmo eliminar o Incidente?"),
            actions: [
              cancelaButton,
              continuaButton,
            ],
          );
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return alert;
            },
          );
        },
      );
    }
    return Text("");
  }

  Widget getSolveOrCloseRaisedButton(){
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.blue.shade900)
      ),
      child: Text(
        _incident.getInfoButtonString(),
        style: TextStyle(
            fontSize: 16,
            color: Colors.white
        ),
      ),
      color: Colors.blue.shade900,
      onPressed: () {
        Text alertText = Text("");

        if(_incident.getInfoButtonString() == "\nResolver\n"){
          alertText = _bloc.solveIncident(_incident, _allIncidents);
        }
        else {
          alertText = _bloc.closeIncident(_incident, _allIncidents);
        }

        Widget okButton = FlatButton(
          child: Text("OK"),
          onPressed: () {
            if(alertText.data == "O seu incidente foi dado como resolvido."
                || alertText.data == "O seu incidente foi dado como fechado."
            ){
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  builder: (context) => ActivesListScreen()), (route) => false);
            }
            else{
              Navigator.pop(context);
            }
          },
        );

        AlertDialog alert = AlertDialog(
          content: alertText,
          actions: [
            okButton,
          ],
        );
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return alert;
          },
        );
      },
    );
  }

  Widget getEditionRaisedButton(){
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.blue.shade900)
      ),
      child: Text(
        "Editar",
        style: TextStyle(
            fontSize: 16,
            color: Colors.white
        ),
      ),
      color: Colors.blue.shade900,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => EditFormScreen(_incident)
        ));
      },
    );
  }
}

///-----------------------------------------------------------------------*/

///------------------------- Closeds List Screen -------------------------*/

class ClosedsListScreen extends StatefulWidget{

  @override
  _ClosedsListScreenState createState() => _ClosedsListScreenState();
}

class _ClosedsListScreenState extends State<ClosedsListScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: getAppBar(),
      floatingActionButton: getClearAllFAB(),
      body: buildListView(),
    );
  }

  Widget getAppBar(){
    return AppBar(
      backgroundColor: Colors.blue.shade900.withOpacity(1.0),
      title: Center(
          child: Column(
            children: [
              Text(
                "Clean City     ",
                style: TextStyle(
                  fontFamily: 'Bellyluerd',
                  fontSize: 35,
                  color: Colors.white,
                ),
              ),
              Text(
                "Incidentes Fechados               ",
                style: TextStyle(
                    fontSize:12
                ),
              ),
            ],
          )
      ),
    );
  }

  Widget getClearAllFAB(){
    return FloatingActionButton.extended(
      backgroundColor: Colors.blue.shade900,
      label: Text(
        "Limpar",
        style: TextStyle(
            color: Colors.white
        ),
      ),
      onPressed: () {
        Text alertText = _bloc.clearClosedIncidents(_allIncidents);

        Widget okButton = FlatButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (context) => ActivesListScreen()), (route) => false);
          },
        );

        AlertDialog alert = AlertDialog(
          content: alertText,
          actions: [
            okButton,
          ],
        );
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return alert;
          },
        );
      },
    );
  }

  ListView buildListView(){
    return ListView.builder(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(bottom: 50),
      itemCount: _allIncidents.getAllClosed().length,
      itemBuilder: (context, idx) => GestureDetector(
        child: Card(
          elevation: 4.0,
          color:  Colors.black26,
          child: _allIncidents.getAllClosed()[idx].getListTile(),

        ),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ClosedsInfoScreen(_allIncidents.getAllClosed()[idx])),
          );
        },
      ),
    );
  }
}

///-----------------------------------------------------------------------*/

///------------------------- Closeds Infos Screen -------------------------*/

class ClosedsInfoScreen extends StatefulWidget{
  Incident _incident;

  ClosedsInfoScreen(Incident incident){
    _incident = incident;
  }

  Incident getIncident(){
    return _incident;
  }

  @override
  _ClosedsInfoScreenState createState() => _ClosedsInfoScreenState(_incident);
}

class _ClosedsInfoScreenState extends State<ClosedsInfoScreen> {

  Incident _incident;

  _ClosedsInfoScreenState(Incident i){
    _incident = i;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
                Icons.arrow_back,
                color: Colors.white
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }
        ),
        backgroundColor: Colors.blue.shade900.withOpacity(1.0),
        title: Center(
          child: Text(
            "Clean City      ",
            style: TextStyle(
              fontFamily: 'Bellyluerd',
              fontSize: 35,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(
            left: 10.0,
            top: 10.0,
            right: 10.0,
            bottom: 10.0
        ),
        child:Column(
          children: [
            //Initial
            Column(
              children: [
                Image.asset(_incident.getLeadingImage()),
              ],
            ),
            Text(""),
            //Titulo
            Row(
              children: [
                Text(
                  "Titulo: ",
                  style: TextStyle(
                      color: Colors.blue.shade900,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text("${_incident.getTitle()}",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
            Text(""),
            //Descricao
            Row(
              children: [
                Text(
                  "Descrição: ",
                  style: TextStyle(
                      color: Colors.blue.shade900,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text("${_incident.getDescription()}",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
            Text(""),
            //Date
            Row(
              children: [
                Text(
                  "Registado em: ",
                  //textAlign: ,
                  style: TextStyle(
                      color: Colors.blue.shade900,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text("${_incident.dateToString()}",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
            Text(""),
            //Morada
            Row(
              children: [
                Text(
                  "Morada: ",
                  style: TextStyle(
                      color: Colors.blue.shade900,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text("${_incident.getAddress()}",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

///-----------------------------------------------------------------------*/