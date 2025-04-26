import 'package:flutter/material.dart';

class OrderTrackingTimeline extends StatelessWidget {
  final List<TrackingStep> steps = [
    TrackingStep(
      title: 'Order Confirmed',
      date: 'March 5, 2025',
      isActive: true,
    ),
    TrackingStep(title: 'Packed', date: 'March 6, 2025', isActive: true),
    TrackingStep(
      title: 'Out for Delivery',
      date: 'March 9, 2025',
      isActive: true,
    ),
    TrackingStep(title: 'Delivered', date: 'Pending', isActive: false),
  ];

  OrderTrackingTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Timeline Row
        Row(
          children: List.generate(steps.length * 2 - 1, (index) {
            if (index.isEven) {
              int stepIndex = index ~/ 2;
              final step = steps[stepIndex];
              return Container(
                width: 45, // Fixed dot size
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: step.isActive ? Colors.redAccent : Colors.black,
                    border: Border.all(color: Colors.grey.shade300, width: 4),
                  ),
                  child:
                      step.isActive
                          ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          )
                          : SizedBox(height: 14, width: 14),
                ),
              );
            } else {
              int lineIndex = index ~/ 2;
              final current = steps[lineIndex];
              final next = steps[lineIndex + 1];
              bool isLineActive = current.isActive && next.isActive;

              return Expanded(
                child: Container(
                  height: 2,
                  color: isLineActive ? Colors.redAccent : Colors.black26,
                ),
              );
            }
          }),
        ),
        const SizedBox(height: 10),

        // Title Labels Row
        Row(
          children:
              steps.map((step) {
                return Expanded(
                  child: Text(
                    step.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }).toList(),
        ),

        const SizedBox(height: 4),

        // Date Labels Row
        Row(
          children:
              steps.map((step) {
                return Expanded(
                  child: Center(
                    child: Text(
                      step.date,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}

class TrackingStep {
  final String title;
  final String date;
  final bool isActive;

  TrackingStep({
    required this.title,
    required this.date,
    this.isActive = false,
  });
}
