import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  int? current;
  int? next;

  void tambahData() {
    emit(state + 1);
  }

  void kurangData() {
    emit(state - 1);
  }

  @override
  void onChange(Change<int> change) {
    super.onChange(change);
    print(change);
    current = change.currentState;
    next = change.nextState;
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print(error);
    print(stackTrace);
  }
}

class HomePage extends StatelessWidget {
  CounterCubit mycounter = CounterCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("bloc listener"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocListener(
              bloc: mycounter,
              listener: (context, state) {
                print(state);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text("nilai listener ${state}")));
              },
              listenWhen: (prev, current) {
                if (current is int) {
                  return current % 2 == 0;
                }
                return false;
              },
              child: BlocBuilder(
                bloc: mycounter,
                // buildWhen: (previous, current) {
                //   if (current is int) {
                //     return current % 2 == 0;
                //   }
                //   return false; // return false jika current bukan tipe data int
                // },
                builder: (context, state) {
                  return Text(
                    state.toString(),
                    style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.black,
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    color: Colors.cyanAccent,
                    margin: EdgeInsets.all(5),
                    child: IconButton(
                        onPressed: () {
                          mycounter.tambahData();
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.indigoAccent,
                        )),
                  ),
                  Container(
                    color: Colors.amber,
                    margin: EdgeInsets.all(5),
                    child: IconButton(
                        onPressed: () {
                          mycounter.kurangData();
                        },
                        icon: Icon(
                          Icons.remove,
                          color: Colors.red,
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
