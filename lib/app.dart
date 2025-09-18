import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kroma/BLoC/counter_bloc.dart';

class KromaHome extends StatefulWidget {
  const KromaHome({super.key});

  @override
  _KromaHomeState createState() => _KromaHomeState();
}

class _KromaHomeState extends State<KromaHome> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CounterBloc()),
        //BlocProvider(create: (context) => SubjectBloc()),
      ],
      child: BlocBuilder<CounterBloc, int>(
        builder: (context, state) {
          final bloc = BlocProvider.of<CounterBloc>(context);
          return Scaffold(
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    bloc.add(IncrementEvent());
                  },
                  icon: const Icon(Icons.plus_one),
                ),
                IconButton(
                  onPressed: () {
                    bloc.add(DecrementEvent());
                  },
                  icon: const Icon(Icons.exposure_minus_1),
                ),
              ],
            ),
            body: Center(
              child: Text(state.toString(), style: TextStyle(fontSize: 40.0)),
            ),
          );
        },
      ),
    );
  }
}
