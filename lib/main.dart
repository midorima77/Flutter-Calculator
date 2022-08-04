import 'package:bloc_example/Result.dart';
import 'package:bloc_example/counter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.red,
    ),
    home: BlocProvider(
        create: (context) => CounterCubit(), child: const HomePage()),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CounterCubit cubit;

  final integerSavedController = TextEditingController();

  void routingToMultiply(BuildContext context, int input, int state) {
    //Routing to pages from multiply_and_divide.dart
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return MultiplyFunction(
          input: input,
          state: state,
        );
      },
    ));
  }

  void routingToDivision(BuildContext context, int input, int state) {
    //Routing to pages from multiply_and_divide.dart
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return DivideFunction(
          input: input,
          state: state,
        );
      },
    ));
  }

  @override
  void didChangeDependencies() {
    cubit = BlocProvider.of<CounterCubit>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo'),
        centerTitle: true,
      ),
      body: BlocConsumer<CounterCubit, int>(
        bloc: cubit,
        listener: (context, state) {
          const snackBar = SnackBar(
            content: Text('State is reached'),
          );

          if (state == 5) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (BuildContext context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: integerSavedController,
                  keyboardType: TextInputType.numberWithOptions(),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Insert Number',
                  ),
                ),
                Text(
                  '$state',
                  style: TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          cubit.decrement();
                        },
                        child: const Icon(Icons.remove)),
                    ElevatedButton(
                        onPressed: () {
                          cubit.reset();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                title: const Text('You have Reset')),
                          );
                        },
                        child: const Icon(Icons.refresh)),
                    ElevatedButton(
                        onPressed: () {
                          cubit.increment();
                        },
                        child: const Icon(Icons.add)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          int input = int.parse(integerSavedController.text);
                          routingToMultiply(context, input, state);
                        },
                        child: const Icon(Icons.close)),
                    ElevatedButton(
                        onPressed: () {
                          int input = int.parse(integerSavedController.text);
                          routingToDivision(context, input, state);
                        },
                        child: const Text('÷',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold))),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
