import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kroma/BLoC/color_bloc.dart';
import 'package:kroma/BLoC/counter_bloc.dart';

class KromaHome extends StatelessWidget {
  const KromaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CounterBloc()),
        BlocProvider(create: (context) => GradientBloc()),
      ],
      child: BlocListener<CounterBloc, int>(
        listener: (context, count) {
          context.read<GradientBloc>().add(UpdateGradientEvent(count));
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Counter & Gradient')),
          floatingActionButton: const _GradientFABs(),
          body: const _MainBody(),
          
        ),
      ),
    );
  }
}

class _MainBody extends StatelessWidget {
  const _MainBody();

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Row(
      children: [
        Expanded(flex: 1, child: _GradientBody(),),
        Expanded(flex: 1, child: _ListBuilder(),)
      ],
    ));
  }
}

class _GradientFABs extends StatelessWidget {
  const _GradientFABs();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
                onPressed: () {
                  context.read<GradientBloc>().add(RegenerateGradientEvent());
                },
                child: const Icon(Icons.refresh),
                mini: true,
              ),
        const SizedBox(height: 8),
        FloatingActionButton(
          onPressed: () => context.read<CounterBloc>().add(IncrementEvent()),
          child: const Icon(Icons.add),
          mini: true,
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          onPressed: () => context.read<CounterBloc>().add(DecrementEvent()),
          child: const Icon(Icons.remove),
          mini: true,
        ),
      ],
    );
  }
}

class _GradientBody extends StatelessWidget {
  const _GradientBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GradientBloc, GradientState>(
      builder: (context, state) {
        if (state is GradientInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GradientLoaded) {
          return Container(
            margin: const EdgeInsets.all(16),
            decoration: state.colorCount == 1
              ?  BoxDecoration(
                color: state.colors[0],
                borderRadius: BorderRadius.circular(20)
              ) 
            : BoxDecoration(
              gradient: LinearGradient(
                colors: state.colors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
            ),

          );
        }
        return Container();
        }
      
    );
  }
}



class _ListBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<GradientBloc, GradientState>(
        builder: (context, state) {
          if (state is GradientLoaded) {
            final gradientBloc = context.read<GradientBloc>();
            final hexCodes = gradientBloc.getCurrentGradientHexCodes();
            
            return ListView.builder(
              itemCount: state.colors.length,
              itemBuilder: (context, index) {
                final color = state.colors[index];
                final hexCode = hexCodes[index];
                
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                    title: Text('Color ${index + 1}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(hexCode,
                      style: TextStyle(fontFamily: 'Monospace'),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('RGB: ${color.red},${color.green},${color.blue}',
                          style: TextStyle(fontSize: 12),
                        ),
                        IconButton(
                          icon: Icon(Icons.content_copy, size: 18),
                          onPressed: () => _copyToClipboard(context, hexCode),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is GradientInitial) {
            return Center(child: Text('No colors generated yet'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    // Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied: $text')),
    );
  }
}