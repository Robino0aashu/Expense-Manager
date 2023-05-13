import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart' as sql_api;

import './widgets/new_transaction.dart';
import './widgets/chart.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Flutter App',
      theme: ThemeData(
          fontFamily: 'Quicksand',
          appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Transaction> _userTransactions = [];

  @override
  void initState() {
    loadPlaces();
    super.initState();
  }

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('transaction_list');
    final transactionData = data.map((row) {
      return Transaction(
        id: row['id'] as String,
        title: row['title'] as String,
        amount: row['amount'] as double,
        date: DateFormat("yyyy-MM-dd hh:mm:ss").parse(row['date']),
      );
    }).toList();
    setState(() {
      _userTransactions = transactionData;
    });
  }

  Future<sql.Database> _getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, 'transactions.db'),
      onCreate: ((db, version) {
        return db.execute(
            'Create table transaction_list(id TEXT PRIMARY KEY, title TEXT, amount REAL, date TEXT )');
      }),
      version: 1,
    );
    return db;
  }

  bool _showChart = false;
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String title, double amount, DateTime chosenDate) async {
    final newTx = Transaction(
      title: title,
      amount: amount,
      date: chosenDate,
    );

    final db = await _getDatabase();

    db.insert('transaction_list', {
      'id': newTx.id,
      'title': newTx.title,
      'amount': newTx.amount,
      'date': chosenDate.toString(),
    });

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) async {
    final db = await _getDatabase();
    //command to delete a column by id
    db.delete('transaction_list', where: 'id = ?', whereArgs: [id]);
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bctx) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.translucent,
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Center(
        child: Text(
          'Expensso',
          style: TextStyle(
            fontFamily: 'OpenSans',
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => _startAddNewTransaction(context),
          icon: Icon(Icons.add),
        )
      ],
      backgroundColor: Color.fromRGBO(12, 12, 10, 1),
    );

    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final txListWidget = Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));

    return Scaffold(
      //backgroundColor: Color.fromRGBO(12, 12, 10, 1),
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Option just available for Landscape mode.
            if (isLandScape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show Chart'),
                  Switch.adaptive(
                    value: (_showChart),
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                      ;
                    },
                  ),
                ],
              ),

            // FOR PORTRAIT MODE
            if (!isLandScape)
              Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.3,
                child: Chart(_recentTransactions),
              ),
            if (!isLandScape) txListWidget,

            // FOR LANDSCAPE MODE
            if (isLandScape)
              _showChart
                  ? Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.7,
                      child: Chart(_recentTransactions),
                    )
                  : txListWidget,
          ],
        ),
      ),
      floatingActionButtonLocation: Platform.isIOS
          ? Container()
          : FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewTransaction(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
