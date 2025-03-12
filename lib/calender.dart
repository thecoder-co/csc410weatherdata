import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:weather/main.dart';
import 'dart:ui' as ui;

import 'package:weather/weather_data_provider.dart';

class DateCalender extends ConsumerStatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime)? onDateSelected;
  const DateCalender({
    super.key,
    this.initialDate,
    this.onDateSelected,
  });

  @override
  ConsumerState<DateCalender> createState() => _DateCalenderState();
}

class _DateCalenderState extends ConsumerState<DateCalender> {
  late DateTime selectedDate = widget.initialDate ?? DateTime.now();
  @override
  Widget build(BuildContext context) {
    final days = <DateTime>[
      ...List.generate(
        3,
        (index) => DateTime.now().subtract(
          Duration(
            days: (index - 3).abs(),
          ),
        ),
      ),
      DateTime.now(),
      ...List.generate(
        3,
        (index) => DateTime.now().add(
          Duration(
            days: (index + 1),
          ),
        ),
      ),
    ];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          for (var i in days.indexed) ...[
            if (i.$1 != 0) const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedDate = i.$2;
                  });
                  ref.read(dateProvider.notifier).state =
                      dateFormat.format(i.$2);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 45, sigmaY: 45),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: dateFormat.format(i.$2) ==
                                  dateFormat.format(selectedDate)
                              ? Colors.transparent
                              : Colors.grey[100]!,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        color: dateFormat.format(i.$2) ==
                                dateFormat.format(selectedDate)
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                      child: Column(
                        children: [
                          Text(
                            dateFormat.format(i.$2) ==
                                    dateFormat.format(selectedDate)
                                ? 'Now'
                                : DateFormat.MEd().format(i.$2),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.33,
                              letterSpacing: -0.50,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Image.asset(
                            'assets/cloud_icon.png',
                            height: 30,
                          ),
                          const SizedBox(height: 12),
                          Consumer(
                            builder: (context, ref, child) {
                              final data = ref.watch(
                                  weatherProvider(dateFormat.format(i.$2)));
                              return Text(
                                data.hasValue && data.value!.isNotEmpty
                                    ? '${getAvg(
                                        data.value!
                                                .map(
                                                  (e) =>
                                                      num.tryParse(
                                                          e.temperature ??
                                                              '') ??
                                                      1,
                                                )
                                                .toList() ??
                                            [],
                                      )!.toStringAsFixed(2)}°'
                                    : '--°',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  height: 1.20,
                                  letterSpacing: 0.38,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
