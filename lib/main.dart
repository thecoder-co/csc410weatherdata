import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather/calender.dart';
import 'package:weather/weather_data_model.dart';
import 'dart:ui' as ui;

import 'package:weather/weather_data_provider.dart';

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(weatherProviderDef);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/bg.jpg',
            ),
          ),
        ),
        child: Column(
          children: [
            Flexible(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Lagos',
                    style: TextStyle(
                      fontSize: 34,
                      color: Colors.white,
                      height: 1.21,
                      letterSpacing: 0.37,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data.hasValue && data.value!.isNotEmpty
                        ? '${getAvg(
                            data.value!
                                    .map(
                                      (e) =>
                                          num.tryParse(e.temperature ?? '') ??
                                          1,
                                    )
                                    .toList() ??
                                [],
                          )!.toStringAsFixed(2)}°'
                        : '--°',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 96,
                      fontWeight: FontWeight.w200,
                      height: 0.73,
                      letterSpacing: 0.37,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Mostly Clear\n',
                          style: TextStyle(
                            color: Color(0x99EBEBF5),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            height: 1.20,
                            letterSpacing: 0.38,
                          ),
                        ),
                        TextSpan(
                          text: 'H:${data.hasValue ? max(
                              data.value!
                                      .map(
                                        (e) =>
                                            num.tryParse(e.temperature ?? '') ??
                                            1,
                                      )
                                      .toList() ??
                                  [],
                            )?.toStringAsFixed(2) : '--'}°   L:${data.hasValue ? min(
                              data.value!
                                      .map(
                                        (e) =>
                                            num.tryParse(e.temperature ?? '') ??
                                            1,
                                      )
                                      .toList() ??
                                  [],
                            )?.toStringAsFixed(2) : '--'}°',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            height: 1.20,
                            letterSpacing: 0.38,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                children: [
                  const DateCalender(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20).copyWith(top: 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter:
                                    ui.ImageFilter.blur(sigmaX: 45, sigmaY: 45),
                                child: Container(
                                  height: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey[100]!,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Avg temp: ${data.hasValue && data.value!.isNotEmpty ? '${getAvg(
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
                                          )!.toStringAsFixed(2)}°' : '--'}°',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 26,
                                          height: 1.20,
                                          letterSpacing: 0.38,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        'Avg Pressure: ${data.hasValue && data.value!.isNotEmpty ? getAvg(
                                            data.value!
                                                    .map(
                                                      (e) =>
                                                          num.tryParse(
                                                              e.pressure ??
                                                                  '') ??
                                                          1,
                                                    )
                                                    .toList() ??
                                                [],
                                          )!.toStringAsFixed(2) : '--'}°',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 26,
                                          height: 1.20,
                                          letterSpacing: 0.38,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        'Avg Sea Lvl Pressure: ${data.hasValue && data.value!.isNotEmpty ? getAvg(
                                            data.value!
                                                    .map(
                                                      (e) =>
                                                          num.tryParse(
                                                              e.seaLevelPressure ??
                                                                  '') ??
                                                          1,
                                                    )
                                                    .toList() ??
                                                [],
                                          )!.toStringAsFixed(2) : '--'}°',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 26,
                                          height: 1.20,
                                          letterSpacing: 0.38,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: () {
                              launchUrl(Uri.parse(
                                  'https://sheetdb.io/api/v1/u6hmify2sgfwc'));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter:
                                    ui.ImageFilter.blur(sigmaX: 45, sigmaY: 45),
                                child: Container(
                                  height: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey[100]!,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Export All Data',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        height: 1.20,
                                        letterSpacing: 0.38,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

num? getAvg(List<num> data) {
  if (data.isEmpty) return null;
  return data.reduce(
        (value, element) => value + element,
      ) /
      data.length;
}

num? max(List<num> data) {
  num? value = data.firstOrNull;
  if (data.isEmpty) return null;
  for (var i in data) {
    if (i > value!) {
      value = i;
    }
  }
  return value;
}

num? min(List<num> data) {
  num? value = data.firstOrNull;
  if (data.isEmpty) return null;
  for (var i in data) {
    if (i < value!) {
      value = i;
    }
  }
  return value;
}
