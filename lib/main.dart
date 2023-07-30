import 'package:expenseplanner/widgets/new_transcation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './widgets/transcation_list.dart';
import './models/transcation.dart';
import './widgets/chart.dart';

/*
In the previous lecture, you learned about setting text themes.

With the latest version of Flutter, some theme identifiers changed.

display4 => headline1;
display3 => headline2;
display2 => headline3;
display1 => headline4;
headline => headline5;
title    => headline6; // used in previous lecture
subhead  => subtitle1;
subtitle => subtitle2;
body2    => bodyText1; // will be used in future lectures
body     => bodyText2; // will be used in future lectures
*/
void main() {
  //its for restrict app for only potrait mode
  WidgetsFlutterBinding.ensureInitialized();
  /* 
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);*/
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Planner',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        //accentColor: Colors.amber,
        errorColor: Colors.red,
        //primary color only set one type of color but primaryswatch set all the different shades of that color
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: const TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
        appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: const TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;
  final List<Transcation> _userTranscations = [];
  List<Transcation> get _recent {
    return _userTranscations.where((t) {
      return t.date.isAfter(
        DateTime.now().subtract(Duration(days: 7)),
      );
    }).toList();
  }

  void _addnewTranscation(String txTitle, double txAmount, DateTime a) {
    final newTx = Transcation(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: a);
    setState(() {
      _userTranscations.add(newTx);
    });
  }

  void _deleteTranscation(String id) {
    setState(() {
      _userTranscations.removeWhere((element) => element.id == id);
    });
  }

  void _startAddNewTranascition(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: NewTranscation(_addnewTranscation));
        });
  }

  @override
  Widget build(BuildContext context) {
    final isLand = MediaQuery.of(context).orientation == Orientation.landscape;
    final appbar = AppBar(
      title: const Text(
        'Expense Planner',
        style: TextStyle(fontFamily: 'Open Saans'),
      ),
      actions: <Widget>[
        IconButton(
            onPressed: () => _startAddNewTranascition(context),
            icon: Icon(Icons.add))
      ],
    );
    final transcationWidgets = Container(
        height: (MediaQuery.of(context).size.height -
                appbar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.7,
        child: TranscationList(_userTranscations, _deleteTranscation));
    return Scaffold(
      appBar: appbar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (isLand)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show Chart'),
                  Switch(
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      }),
                ],
              ),
            if (!isLand)
              Container(
                  height: (MediaQuery.of(context).size.height -
                          appbar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.3,
                  child: Chart(_userTranscations)),
            if (!isLand) transcationWidgets,
            if (isLand)
              _showChart
                  ? Card(
                      //if we want to increase the size of card change the size of its child.card depends upon its child size unless if the parent as clear its size
                      //double.infinty means take as much as you get
                      child: Container(
                          height: (MediaQuery.of(context).size.height -
                                  appbar.preferredSize.height -
                                  MediaQuery.of(context).padding.top) *
                              0.7,
                          child: Chart(_userTranscations)),
                      elevation: 5,
                    )
                  : transcationWidgets
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewTranascition(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
