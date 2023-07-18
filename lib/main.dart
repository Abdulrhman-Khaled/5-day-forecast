import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return const MaterialApp(
          title: '5-Day Forecast',
          home: MyHomePage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int selectedPage;
  late final PageController _pageController;
  bool loading = true;

  String? weatherStatusw,
      tempHighw,
      tempLoww,
      windDirectionw,
      windSpeedw,
      humidityw,
      rainProbabilityw;

  DateTime now = DateTime.now();

  Future<void> getWeatherData(String city) async {
    const apiKey = 'a86b8f180ba27dba5398df05d0e15d71';

    final apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(apiUrl));

    final jsonData = json.decode(response.body);
    final weatherStatus = jsonData['weather'][0]['description'];
    final tempHigh = jsonData['main']['temp_max'].toString();
    final tempLow = jsonData['main']['temp_min'].toString();
    final windDirection = jsonData['wind']['deg'].toString();
    final windSpeed = jsonData['wind']['speed'].toString();
    final humidity = jsonData['main']['humidity'].toString();
    final rainProbability = jsonData['pop'].toString();

    setState(() {
      weatherStatusw = weatherStatus;
      tempHighw = tempHigh;
      tempLoww = tempLow;
      windDirectionw = windDirection;
      windSpeedw = windSpeed;
      humidityw = humidity;
      rainProbabilityw = rainProbability;
      loading = false;
    });
  }

  @override
  void initState() {
    selectedPage = 0;
    _pageController = PageController(initialPage: selectedPage);
    getWeatherData('london');
    super.initState();
  }

  onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Yes', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const pageCount = 5;
    String day = DateFormat('EEEE').format(now);
    String date = DateFormat('MMM d').format(now);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 217, 217, 217),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              onBackPressed();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  loading = true;
                  getWeatherData('london');
                });
              },
              icon: const Icon(
                Icons.refresh_outlined,
                color: Colors.black,
              )),
        ],
        centerTitle: true,
        title: Text(
          '5 DAYS FORECAST',
          style: GoogleFonts.rubik(
              color: Colors.black,
              fontSize: 17.sp,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            ))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (page) {
                      setState(() {
                        selectedPage = page;
                      });
                    },
                    children: List.generate(pageCount, (index) {
                      return Center(
                          child: Container(
                        height: 75.h,
                        width: 85.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Image.asset(
                                  'assets/back.png',
                                  color: Colors.black.withOpacity(0.3),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                children: [
                                  Text(
                                    '$day, $date',
                                    style: GoogleFonts.rubik(
                                        color: Colors.black,
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  Text(
                                    weatherStatusw!,
                                    style: GoogleFonts.rubik(
                                        color: Colors.black,
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w200),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Image.asset(
                                    'assets/sun.png',
                                    width: 17.w,
                                  ),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/sun.png',
                                            width: 8.w,
                                          ),
                                          SizedBox(
                                            width: 2.w,
                                          ),
                                          Text(
                                            '${tempHighw!}°C',
                                            style: GoogleFonts.rubik(
                                                color: Colors.black,
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/moon.png',
                                            width: 8.w,
                                          ),
                                          SizedBox(
                                            width: 2.w,
                                          ),
                                          Text(
                                            '${tempLoww!}°C',
                                            style: GoogleFonts.rubik(
                                                color: Colors.black,
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  SizedBox(
                                    width: 60.w,
                                    child: CustomPaint(
                                      painter: PointedLinePainter(60.w),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/wind.png',
                                            width: 9.w,
                                          ),
                                          SizedBox(
                                            width: 6.w,
                                          ),
                                          SizedBox(
                                            width: 40.w,
                                            child: Text(
                                              'Wind Direction',
                                              style: GoogleFonts.rubik(
                                                  color: Colors.black,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                          Text(
                                            windDirectionw!,
                                            textAlign: TextAlign.right,
                                            style: GoogleFonts.rubik(
                                                color: Colors.black,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/thunder.png',
                                            width: 9.w,
                                          ),
                                          SizedBox(
                                            width: 6.w,
                                          ),
                                          SizedBox(
                                            width: 40.w,
                                            child: Text(
                                              'Wind Speed',
                                              style: GoogleFonts.rubik(
                                                  color: Colors.black,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                          Text(
                                            '${windSpeedw!} km/h',
                                            textAlign: TextAlign.right,
                                            style: GoogleFonts.rubik(
                                                color: Colors.black,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/thermometer.png',
                                            width: 9.w,
                                          ),
                                          SizedBox(
                                            width: 6.w,
                                          ),
                                          SizedBox(
                                            width: 40.w,
                                            child: Text(
                                              'Humidity',
                                              style: GoogleFonts.rubik(
                                                  color: Colors.black,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                          Text(
                                            humidityw!,
                                            textAlign: TextAlign.right,
                                            style: GoogleFonts.rubik(
                                                color: Colors.black,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/rain.png',
                                            width: 9.w,
                                          ),
                                          SizedBox(
                                            width: 6.w,
                                          ),
                                          SizedBox(
                                            width: 40.w,
                                            child: Text(
                                              'Rain Probability',
                                              style: GoogleFonts.rubik(
                                                  color: Colors.black,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                          Text(
                                            rainProbabilityw! == 'null'
                                                ? '0 %'
                                                : '${rainProbabilityw!} %',
                                            textAlign: TextAlign.right,
                                            style: GoogleFonts.rubik(
                                                color: Colors.black,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: PageViewDotIndicator(
                    currentItem: selectedPage,
                    count: pageCount,
                    unselectedColor: Colors.grey,
                    selectedColor: Colors.black,
                    duration: const Duration(milliseconds: 200),
                    boxShape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
              ],
            ),
    );
  }
}

class PointedLinePainter extends CustomPainter {
  final double width;

  PointedLinePainter(this.width);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    var gradient = const LinearGradient(
      colors: [Colors.white, Colors.black, Colors.white],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    paint.shader =
        gradient.createShader(Rect.fromLTWH(0, 0, width, size.height));
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, 0);
    path.quadraticBezierTo(width / 3, 4, width, 0);
    path.quadraticBezierTo(width / 3, -3, 0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
