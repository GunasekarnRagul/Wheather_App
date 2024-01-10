import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:wheather_app/responsive/dimensions.dart';
import 'const.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory _wf = WeatherFactory(OEPNWEATHER_API_KEY);
  Weather? weather;
  String _locationMessage = '';
   double latitude = 0.0;
   double longitude = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation();
    _wf.currentWeatherByLocation(
      latitude,longitude
    ).then((value) => {
          weather = value,
        });


  }
  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _locationMessage =
        "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
        latitude = position.latitude;
        longitude = position.longitude;
        print(_locationMessage);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: bodyUi(),
    );
  }

  Widget bodyUi() {
    if (weather == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.black,
        ),
      );
    } else {
      return SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _locationHeader(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.08,
            ),
            _dateTimeInfo(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.05,
            ),
            weatherIcon(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.02,
            ),
            currentTemp(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.03,
            ),
            extraInfo(),
          ],
        ),
      );
    }
  }

  Widget _locationHeader() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.location_on_outlined,
          color: Colors.blueGrey,
          size: Dimensions.updateDimensions(context, 'w', 35),
        ),
        RichText(
          text: TextSpan(
            text: weather?.areaName ?? '',
            style: GoogleFonts.ubuntu(
              color: Colors.black,
              fontSize: Dimensions.updateDimensions(context, 'w', 35),
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }

  Widget _dateTimeInfo() {
    DateTime? now = weather?.date;
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: DateFormat('h:mm a').format(now!).toString(),
            style: GoogleFonts.ubuntu(
              color: Colors.black,
              fontSize: Dimensions.updateDimensions(context, 'w', 35),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(
          height: Dimensions.updateDimensions(context, 'h', 10),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                text: DateFormat('EEEE').format(now).toString(),
                style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: Dimensions.updateDimensions(context, 'w', 25),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              width: Dimensions.updateDimensions(context, 'w', 10),
            ),
            RichText(
              text: TextSpan(
                text: DateFormat('d:m:y').format(now).toString(),
                style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: Dimensions.updateDimensions(context, 'w', 25),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.2,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'http://openweathermap.org/img/wn/${weather?.weatherIcon}@4x.png'))),
        ),
        RichText(
          text: TextSpan(
            text: weather?.weatherDescription ?? '',
            style: GoogleFonts.ubuntu(
              color: Colors.black,
              fontSize: Dimensions.updateDimensions(context, 'w', 20),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget currentTemp() {
    return RichText(
      text: TextSpan(
        text: "${weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
        style: GoogleFonts.ubuntu(
          color: Colors.black,
          fontSize: Dimensions.updateDimensions(context, 'w', 90),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget extraInfo() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.18,
      width: MediaQuery.sizeOf(context).width * 0.80,
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(
              Dimensions.updateDimensions(context, 'w', 20))),
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  text:
                      "MAX: ${weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                  style: GoogleFonts.ubuntu(
                    color: Colors.white,
                    fontSize: Dimensions.updateDimensions(context, 'w', 15),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  text:
                      "MIN: ${weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                  style: GoogleFonts.ubuntu(
                    color: Colors.white,
                    fontSize: Dimensions.updateDimensions(context, 'w', 15),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  text: "WIND: ${weather?.windSpeed?.toStringAsFixed(0)} M/S",
                  style: GoogleFonts.ubuntu(
                    color: Colors.white,
                    fontSize: Dimensions.updateDimensions(context, 'w', 15),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: "HUMANITY: ${weather?.humidity?.toStringAsFixed(0)} %",
                  style: GoogleFonts.ubuntu(
                    color: Colors.white,
                    fontSize: Dimensions.updateDimensions(context, 'w', 15),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
