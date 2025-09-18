import 'package:bloc/bloc.dart' show Bloc, Emitter;



class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<IncrementEvent>((event, emit) => _onIncrement(event, emit, state));
    on<DecrementEvent>((event, emit) => _onDecrement(event, emit, state));
  }
}
void _onIncrement(IncrementEvent event, Emitter<int> emit, int currentState) {
  emit(currentState + 1);
}

void _onDecrement(DecrementEvent event, Emitter<int> emit, int currentState) {
  emit(currentState - 1);
}


abstract class CounterEvent {}

class IncrementEvent extends CounterEvent {}

class DecrementEvent extends CounterEvent {}
