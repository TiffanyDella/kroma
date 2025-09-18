
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';


class GradientBloc extends Bloc<GradientEvent, GradientState> {
  GradientBloc() : super(GradientInitial()) {
    on<UpdateGradientEvent>((event, emit) {
      final colors = _generateColors(event.colorCount);
      emit(GradientLoaded(
      colorCount: event.colorCount,
       colors: colors,
       ));
    });

    on<RegenerateGradientEvent>((event, emit) {
      if (state is GradientLoaded) {
        final currentState = state as GradientLoaded;
        final newColors = _generateColors(currentState.colorCount);
        emit(GradientLoaded(
          colorCount: currentState.colorCount,
          colors: newColors,
        )
        );
      }
    });
  }
  
   List<Color> _generateColors(int count) {
    if (count <= 0) return [Colors.grey];
    
    final random = Random();
    return List.generate(count, (_) => Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    ));
  }

   String colorToHex(Color color, {bool includeAlpha = true}) {
    if (includeAlpha) {
      return '#${color.value.toRadixString(16).padLeft(8, '0')}';
    } else {
      return '#${(color.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
    }
  }

  List<String> getCurrentGradientHexCodes({bool includeAlpha = true}) {
    if (state is GradientLoaded) {
      final loadedState = state as GradientLoaded;
      return loadedState.colors
          .map((color) => colorToHex(color, includeAlpha: includeAlpha))
          .toList();
    }
    return [];
  }
}

abstract class GradientEvent {}
class UpdateGradientEvent extends GradientEvent {
  final int colorCount;
  UpdateGradientEvent(this.colorCount);
}

class RegenerateGradientEvent extends GradientEvent {}

abstract class GradientState {}


class GradientInitial extends GradientState {}
class GradientLoaded extends GradientState {
  final int colorCount;
  final List<Color> colors;
  GradientLoaded({required this.colorCount, required this.colors});
  
}