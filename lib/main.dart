import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with TickerProviderStateMixin {
  bool selected = false;
  bool _bool = true;
  final _items = [];
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  void _addItem() {
    _items.insert(0, "Item ${_items.length + 1}");
    _key.currentState!.insertItem(0, duration: const Duration(seconds: 1));
  }

  void _removeItem(int index) {
    _key.currentState!.removeItem(
      index,
      (_, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: const Card(
            margin: EdgeInsets.all(10),
            color: Colors.red,
            child: ListTile(
              title: Text(
                "Deleted",
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        );
      },
      duration: const Duration(milliseconds: 300),
    );
    _items.removeAt(index);
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 5),
    vsync: this,
  )..repeat();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //The about dialog widgets
          ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => const AboutDialog(
                        applicationIcon: FlutterLogo(),
                        applicationLegalese: 'Legalese',
                        applicationName: 'Flutter App',
                        applicationVersion: 'version 1.0.0',
                        children: [Text("this is the text created by the app")],
                      ));
            },
            child: const Text('Enabled'),
          ),
          //About list style
          const AboutListTile(
            icon: Icon(Icons.info),
            applicationIcon: FlutterLogo(),
            applicationLegalese: 'Legalese',
            applicationName: "Flutter App",
            applicationVersion: 'version 1.0.0',
            aboutBoxChildren: [Text('This is a text created by flutter mapp')],
          ),
          //Alert Dialog
          ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Close'))
                            ],
                            title: const Text('flutter mapp'),
                            content: const Text("Alert Dialog")));
              },
              child: const Text('show alert Dialog')),
          // //the align widget
          // Container(
          //   child: Container(
          //     width: double.infinity,
          //     height: 120.0,
          //     color: Colors.blueGrey,
          //     child: const Align(
          //       alignment: Alignment.bottomRight,
          //       child: FlutterLogo(
          //         size: 60,
          //       ),
          //     ),
          //   ),
          // ),
          //Animated align
          GestureDetector(
              onTap: () {
                setState(() {
                  selected = !selected;
                });
              },
              child: Center(
                  child: Container(
                width: double.infinity,
                height: 250.0,
                color: Colors.blueGrey,
                child: AnimatedAlign(
                    alignment:
                        selected ? Alignment.topRight : Alignment.bottomLeft,
                    duration: const Duration(seconds: 2),
                    curve: Curves.fastOutSlowIn,
                    child: FlutterLogo(size: 50.0)),
              ))),
          //Animated Builder
          AnimatedBuilder(
            animation: _controller,
            child: FlutterLogo(size: 100),
            builder: (BuildContext context, Widget? child) {
              return Transform.rotate(
                  angle: _controller.value * 2.0 * math.pi, child: child);
            },
          ),
          //Animated cross Fade
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: double.infinity,
                height: 100,
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _bool = !_bool;
                    });
                  },
                  child: const Text(
                    'Switch',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
              AnimatedCrossFade(
                  firstChild: Image.asset('assets/Images/blue.jpg',
                      width: double.infinity, height: 50.0),
                  secondChild: Image.asset('assets/Images/ocean.png',
                      width: double.infinity, height: 50.0),
                  crossFadeState: _bool
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(seconds: 3))
            ],
          ),
          // Animated List
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              IconButton(
                onPressed: _addItem,
                icon: const Icon(Icons.add),
              ),
              Expanded(
                  child: AnimatedList(
                      key: _key,
                      initialItemCount: 0,
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index, animation) {
                        return SizeTransition(
                            key: UniqueKey(),
                            sizeFactor: animation,
                            child: Card(
                              margin: const EdgeInsets.all(10),
                              color: Colors.orangeAccent,
                              child: ListTile(
                                title: Text(
                                  _items[index],
                                  style: const TextStyle(fontSize: 24),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _removeItem(index);
                                  },
                                ),
                              ),
                            ));
                      }))
            ],
          )
        ],
      ),
    );
  }
}
