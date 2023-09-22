import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:weather/weather.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

Future<bool> checkInternetConnectivity() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi;
}

class DiaryEntry {
  final String id;
  final String title;
  final String content;
  final double latitude;
  final double longitude;
  final List<String> attachments;
  final List<String>
      images; // Added list of image URLs or file paths for images
  final int mood;
  final int weather;

  DiaryEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.latitude,
    required this.longitude,
    required this.attachments,
    required this.images,
    required this.mood,
    required this.weather,
  });

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'latitude': latitude,
      'longitude': longitude,
      'attachments': attachments,
      'images': images,
      'mood': mood,
      'weather': weather,
    };
  }

  DiaryEntry.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        content = json['content'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        attachments = List<String>.from(json['attachments']),
        images = List<String>.from(json['images']),
        mood = json['mood'],
        weather = json['weather'];
// Add toJSON and fromJSON methods here as shown in the previous response.
}

int choosenMoodIndex = 0;
int choosenWeatherIndex = 0;

Map<String, IconData> weatherIconMappings = {
  "01d": Icons.wb_sunny, // Clear sky (day)
  "01n": Icons.brightness_2, // Clear sky (night)
  "02d": Icons.wb_cloudy, // Few clouds (day)
  "02n": LucideIcons.cloudMoon, // Few clouds (night)
  "03d": LucideIcons.cloudy, // Scattered clouds (day)
  "03n": LucideIcons.cloudy, // Scattered clouds (night)
  "04d": Icons.cloud_queue, // Broken clouds (day)
  "04n": Icons.cloud_queue, // Broken clouds (night)
  "09d": LucideIcons.cloudDrizzle, // Shower rain (day)
  "09n": LucideIcons.cloudMoonRain, // Shower rain (night)
  "10d": Icons.beach_access, // Rain (day)
  "10n": Icons.beach_access, // Rain (night)
  "11d": LucideIcons.cloudLightning, // Thunderstorm (day)
  "11n": LucideIcons.cloudLightning, // Thunderstorm (night)
  "13d": Icons.ac_unit, // Snow (day)
  "13n": Icons.ac_unit, // Snow (night)
  "50d": LucideIcons.waves, // Mist (day)
  "50n": LucideIcons.waves, // Mist (night)
};

List<Map<String, dynamic>> moodOptions = [
  {
    'name': 'Grinning Face',
    'assetPath': 'lib/emoji/grinning-face.svg',
    'index': 0
  },
  {
    'name': 'Beaming Face with Smiling Eyes',
    'assetPath': 'lib/emoji/beaming-face-with-smiling-eyes.svg',
    'index': 1
  },
  {'name': 'Crazy Face', 'assetPath': 'lib/emoji/crazy-face.svg', 'index': 2},
  {
    'name': 'Cowboy Hat Face',
    'assetPath': 'lib/emoji/cowboy-hat-face.svg',
    'index': 3
  },
  {
    'name': 'Face Blowing a Kiss',
    'assetPath': 'lib/emoji/face-blowing-a-kiss.svg',
    'index': 4
  },
  {
    'name': 'Expressionless Face',
    'assetPath': 'lib/emoji/expressionless-face.svg',
    'index': 5
  },
  {
    'name': 'Amusing Face',
    'assetPath': 'lib/emoji/amusing-face.svg',
    'index': 6
  },
  {
    'name': 'Astonished Face',
    'assetPath': 'lib/emoji/astonished-face.svg',
    'index': 7
  },
  {
    'name': 'Anxious Face',
    'assetPath': 'lib/emoji/anxious-face.svg',
    'index': 8
  },
  {
    'name': 'Confused Face',
    'assetPath': 'lib/emoji/confused-face.svg',
    'index': 9
  },
  {
    'name': 'Confounded Face',
    'assetPath': 'lib/emoji/confounded-face.svg',
    'index': 10
  },
  {
    'name': 'Crying Face',
    'assetPath': 'lib/emoji/crying-face.svg',
    'index': 11
  },
  {
    'name': 'Disappointed Face',
    'assetPath': 'lib/emoji/disappointed-face.svg',
    'index': 12
  },
  {
    'name': 'Vomiting Face',
    'assetPath': 'lib/emoji/face-vomiting.svg',
    'index': 13
  },
  {
    'name': 'Angry Face',
    'assetPath': 'lib/emoji/face-with-steam-from-nose.svg',
    'index': 14
  },
  {
    'name': 'Sleepy Face',
    'assetPath': 'lib/emoji/sleepy-face.svg',
    'index': 15
  },
  // Add more mood options as needed
];

class Diary extends StatefulWidget {
  const Diary({Key? key}) : super(key: key);

  @override
  State<Diary> createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  double initialLat = 0.0;
  double initialLng = 0.0;
  Weather? currentWeather;
  bool isInternetConnected = false;
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  @override
  void initState() {
    super.initState();

    _checkConnection();

    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        isInternetConnected = result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi;
      });
    });
  }

  void _checkConnection() async {
    isInternetConnected = await checkInternetConnectivity();
    print('Connection of Intenet Status : $isInternetConnected');

    if (isInternetConnected == true) {
      await _getWeather();
    } else {
      print('Connect to internet');
    }
  }

  Future<void> _getLocationData() async {
    Location location = Location();
    LocationData? _locationData;

    try {
      bool _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      PermissionStatus _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      // Define a duration for the timeout (e.g., 10 seconds)
      const Duration timeoutDuration = Duration(seconds: 20);

      _locationData = await location
          .getLocation()
          .timeout(timeoutDuration); // Apply timeout to the location request
    } catch (e) {
      print("Error getting location: $e");
    }

    if (_locationData != null) {
      setState(() {
        initialLat = _locationData?.latitude ?? 0.0;
        initialLng = _locationData?.longitude ?? 0.0;
      });
    }
  }

  Future<void> _getWeather() async {
    await _getLocationData();

    try {
      WeatherFactory wf =
          new WeatherFactory("aa714d546d683feeca372d55167f36ed");

      // Define a duration for the timeout (e.g., 10 seconds)
      const Duration timeoutDuration = Duration(seconds: 20);

      Weather w = await wf
          .currentWeatherByLocation(initialLat, initialLng)
          .timeout(timeoutDuration); // Apply timeout to the request

      setState(() {
        currentWeather = w;
      });
    } catch (e) {
      // Handle timeout or other errors when fetching weather data
      if (e is TimeoutException) {
        print("Request timed out: $e");
        // Handle the timeout error here, e.g., display a message to the user.
      } else {
        print("Error fetching weather data: $e");
        // Handle other potential errors here.
      }
    }
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        image: DecorationImage(
          image: AssetImage("lib/img/cloud.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Text(
            "24/Sep/23",
            style: GoogleFonts.ubuntuMono(fontSize: 18),
          ),
          TextField(
            style: GoogleFonts.ubuntuMono(fontSize: 18),
            cursorColor: Colors.blue,
            decoration: InputDecoration(
              icon: const Icon(
                Icons.title_rounded,
                size: 32,
                color: Colors.blue,
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              hintText: ("Title"),
              hintStyle: GoogleFonts.ubuntuMono(
                color: const Color.fromARGB(255, 34, 35, 36),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLines: (MediaQuery.of(context).size.height ~/ 45),
                cursorColor: Colors.blue,
                style: GoogleFonts.ubuntuMono(fontSize: 18),
                decoration: const InputDecoration(
                  hintText: "About the Day how it's going",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(LucideIcons.save, color: Colors.white),
                  tooltip: "Save",
                ),
                IconButton(
                  onPressed: () {
                    _showMoodPicker(context);
                  },
                  icon: SelctedMoodEmoji(),
                  tooltip: "Mood",
                ),
                IconButton(
                  onPressed: () {
                    if (isInternetConnected == true) {
                      if (currentWeather != null) {
                        _showWeatherDialog(
                            context, (currentWeather) as Weather);
                        print(
                            "Current weatjer icon code is ${currentWeather!.weatherIcon}");
                      }
                    } else {
                      _showNoInternetDialog(context);
                    }
                  },
                  icon: currentWeatherIcon(),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.attach_file, color: Colors.white),
                  tooltip: "Attachment",
                ),
                IconButton(
                  onPressed: () async {
                    if (isInternetConnected == true) {
                      _showLocationDialog(context);
                    } else {
                      _showNoInternetDialog(context);
                    }
                    print(initialLat);
                    print(initialLng);
                  },
                  icon: showLocationIcon(),
                  tooltip: "Location",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMoodPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 26, 60, 88),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: moodOptions.map((moodOption) {
                return ListTile(
                  title: SvgPicture.asset(
                    moodOption['assetPath'],
                    width: 42,
                    theme: SvgTheme(currentColor: Colors.white),
                  ),
                  onTap: () {
                    int selectedIndex = moodOption['index'];
                    setState(() {
                      choosenMoodIndex = selectedIndex;
                      print(choosenMoodIndex);
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget SelctedMoodEmoji() {
    for (var e in moodOptions) {
      if (e['index'] == choosenMoodIndex) {
        return SvgPicture.asset(e['assetPath'],
            width: 24, theme: SvgTheme(currentColor: Colors.white));
      }
    }
    return Container();
  }

  void _showWeatherDialog(BuildContext context, Weather currentWeather) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 26, 60, 88),
          content: Container(
            // color: const Color.fromARGB(255, 26, 60, 88),
            height: 300,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Weather :',
                    style:
                        GoogleFonts.ubuntu(fontSize: 24, color: Colors.white),
                  ),
                  Text(
                    'Country : ${currentWeather?.country ?? "N/A"}',
                    style:
                        GoogleFonts.ubuntu(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'Area Name : ${currentWeather?.areaName ?? "N/A"}',
                    style:
                        GoogleFonts.ubuntu(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'Date : ${currentWeather?.date ?? "N/A"}',
                    style:
                        GoogleFonts.ubuntu(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'Humidity : ${currentWeather?.humidity ?? "N/A"}',
                    style:
                        GoogleFonts.ubuntu(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'Sunrise : ${currentWeather?.sunrise ?? "N/A"}',
                    style:
                        GoogleFonts.ubuntu(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'Sunset : ${currentWeather?.sunset ?? "N/A"}',
                    style:
                        GoogleFonts.ubuntu(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'TempFeelsLike : ${currentWeather?.tempFeelsLike ?? "N/A"}',
                    style:
                        GoogleFonts.ubuntu(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'TempMax : ${currentWeather?.tempMax ?? "N/A"}',
                    style:
                        GoogleFonts.ubuntu(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'TempMin : ${currentWeather?.tempMin ?? "N/A"}',
                    style:
                        GoogleFonts.ubuntu(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'Temp :  ${currentWeather?.temperature ?? "N/A"}',
                    style:
                        GoogleFonts.ubuntu(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'Weather : ${currentWeather?.weatherMain ?? "N/A"}',
                    style:
                        GoogleFonts.ubuntu(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'Rain Last 3 Hours :  ${currentWeather?.rainLast3Hours ?? "N/A"}',
                    style:
                        GoogleFonts.ubuntu(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'Rain Last Hour : ${currentWeather?.rainLastHour ?? "N/A"}',
                    style:
                        GoogleFonts.ubuntu(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'Snow Last 3 Hours : ${currentWeather?.snowLast3Hours ?? "N/A"}',
                    style:
                        GoogleFonts.ubuntu(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'Snow Last Hours : ${currentWeather?.snowLastHour ?? "N/A"}',
                    style:
                        GoogleFonts.ubuntu(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'Wind Degree : ${currentWeather?.windDegree ?? "N/A"}',
                    style:
                        GoogleFonts.ubuntu(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'Wind Gust : ${currentWeather?.windGust ?? "N/A"}',
                    style:
                        GoogleFonts.ubuntu(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'Wind Speed : ${currentWeather?.windSpeed ?? "N/A"}',
                    style:
                        GoogleFonts.ubuntu(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLocationDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text("Location", style: GoogleFonts.ubuntu(color: Colors.white)),
          backgroundColor: Color.fromARGB(255, 80, 139, 171),
          content: Container(
            width: double.maxFinite,
            height: 400, // Adjust the height as needed
            child: FutureBuilder(
              future: _getLocationDataWithTimeout(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Display a loading indicator while fetching location
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Handle the case where location retrieval fails
                  return Center(
                      child: Text("Failed to retrieve location data."));
                } else if (snapshot.hasData) {
                  // Display the map with location data
                  final LatLng locationData = snapshot.data ?? LatLng(0.0, 0.0);
                  ;
                  return Stack(
                    children: [
                      FlutterMap(
                        options: MapOptions(
                          center: locationData,
                          zoom: 16,
                          maxZoom: 16,
                          minZoom: 4,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                width: 30.0,
                                height: 30.0,
                                point: locationData,
                                builder: (ctx) => Container(
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.blue,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Center(child: Text("Location data not available."));
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<LatLng> _getLocationDataWithTimeout() async {
    try {
      Location location = Location();
      bool _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          throw Exception("Location service not enabled.");
        }
      }

      PermissionStatus _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          throw Exception("Location permission not granted.");
        }
      }

      LocationData? _locationData = await location.getLocation();
      if (_locationData == null) {
        throw Exception("Location data not available.");
      }

      return LatLng(
          _locationData.latitude ?? 0.0, _locationData.longitude ?? 0.0);
    } catch (e) {
      // Handle any potential errors when fetching location data
      print("Error getting location: $e");
      // You can return a default location or rethrow the exception as needed.
      return LatLng(0.0, 0.0);
    }
  }

  Widget currentWeatherIcon() {
    if (isInternetConnected == true) {
      if (currentWeather != null) {
        final weatherIcon = weatherIconMappings[currentWeather!.weatherIcon];
        if (weatherIcon != null) {
          return Icon(weatherIcon, color: Colors.white);
        }
      }
    }

    // Return a default icon in case of null or missing weather icon
    return Icon(LucideIcons.cloudOff, color: Colors.white);
  }

  Widget showLocationIcon() {
    if (isInternetConnected == false) {
      return Icon(
        LucideIcons.mapPinOff,
        color: Colors.white,
      );
    }

    // Return the default map pin icon in other cases
    return Icon(LucideIcons.mapPin, color: Colors.white);
  }

  void _showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("No Internet Connection"),
          content: Text("Please connect to the internet and try again."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
