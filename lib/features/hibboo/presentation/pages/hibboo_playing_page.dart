import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hibboo_provider.dart';

class HibbooPlayingPage extends StatefulWidget {
  const HibbooPlayingPage({super.key});

  @override
  _HibbooPlayingPageState createState() => _HibbooPlayingPageState();
}

class _HibbooPlayingPageState extends State<HibbooPlayingPage> {
  final TextEditingController _controller = TextEditingController();
  String? _hint;
  List<String> _scrambledLetters = [];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HibbooProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solve Hibboo'),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    provider.currentHibboo.text,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Your Answer',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_controller.text.toLowerCase() ==
                          provider.currentHibboo.answer.toLowerCase()) {
                        provider.solveHibboo();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Correct!')),
                        );
                        _controller.clear();
                        _hint = null;
                        _scrambledLetters = [];
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Try again!')),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _hint = provider.currentHibboo.answer;
                        _scrambledLetters = _hint!.split('')..shuffle();
                      });
                    },
                    child: const Text('Hint'),
                  ),
                  if (_hint != null) ...[
                    const SizedBox(height: 20),
                    Text('Scrambled Letters: ${_scrambledLetters.join(', ')}'),
                  ],
                ],
              ),
            ),
    );
  }
}