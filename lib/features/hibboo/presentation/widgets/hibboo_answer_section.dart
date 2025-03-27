import 'package:flutter/material.dart';

/// Section for user to input their answer to a Hibboo riddle
class HibbooAnswerSection extends StatelessWidget {
  /// Controller for the text input field
  final TextEditingController controller;

  /// Function to call when submitting an answer
  final VoidCallback onSubmit;

  /// Function to call when requesting a hint
  final VoidCallback onRequestHint;

  /// Creates an answer section widget
  const HibbooAnswerSection({
    super.key,
    required this.controller,
    required this.onSubmit,
    required this.onRequestHint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAnswerInput(),
        const SizedBox(height: 24),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildAnswerInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Type your answer here...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          icon: Icon(Icons.lightbulb_outline, color: Colors.amber[700]),
        ),
        style: const TextStyle(fontSize: 18),
        onSubmitted: (_) => onSubmit(),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline),
                SizedBox(width: 8),
                Text(
                  'Submit',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: onRequestHint,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
          ),
          child: const Icon(Icons.lightbulb),
        ),
      ],
    );
  }
}
