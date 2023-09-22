import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Data {
  String date;
  String title;
  String day;
  String time;
  String entry;

  Data({
    required this.date,
    required this.title,
    required this.day,
    required this.time,
    required this.entry,
  });
}

List<Data> dummyData = [
  Data(
      date: "16",
      day: "Sun",
      title: "You never ",
      time: "22:24",
      entry: "This diary is demmo"),
  Data(
      date: "24",
      day: "Sun",
      title: "You never ",
      time: "22:24",
      entry: "This diary is demmo"),
  Data(
      date: "24",
      day: "Sun",
      title: "You never ",
      time: "22:24",
      entry: "This diary is demmo"),
  Data(
      date: "24",
      day: "Sun",
      title: "You never ",
      time: "22:24",
      entry: "This diary is demmo"),
  Data(
      date: "24",
      day: "Sun",
      title: "You never ",
      time: "22:24",
      entry: "This diary is demmo"),
  Data(
      date: "24",
      day: "Sun",
      title: "You never ",
      time: "22:24",
      entry: "This diary is demmo"),
  Data(
      date: "24",
      day: "Sun",
      title: "You never ",
      time: "22:24",
      entry: "This diary is demmo"),
  Data(
      date: "24",
      day: "Sun",
      title: "You never ",
      time: "22:24",
      entry: "This diary is demmo"),
  Data(
      date: "24",
      day: "Sun",
      title: "You never ",
      time: "22:24",
      entry: "This diary is demmo"),
  Data(
      date: "24",
      day: "Sun",
      title: "You never ",
      time: "22:24",
      entry: "This diary is demmo"),
  Data(
      date: "24",
      day: "Sun",
      title: "You never ",
      time: "22:24",
      entry: "This diary is demmo"),
  Data(
      date: "24",
      day: "Sun",
      title: "You never ",
      time: "22:24",
      entry: "This diary is demmo"),
  Data(
      date: "24",
      day: "Sun",
      title: "You never ",
      time: "22:24",
      entry: "This diary is demmo"),
  Data(
      date: "24",
      day: "Sun",
      title: "You never ",
      time: "22:24",
      entry: "This diary is demmo"),
  Data(
      date: "24",
      day: "Sun",
      title: "You never ",
      time: "22:24",
      entry: "This diary is demmo"),
  Data(
      date: "24",
      day: "Sun",
      title: "You never ",
      time: "22:24",
      entry: "This diary is demmo"),
  Data(
      date: "24",
      day: "Sun",
      title: "You never ",
      time: "22:24",
      entry: "This diary is demmo"),
];

class Entries extends StatefulWidget {
  const Entries({super.key});

  @override
  State<Entries> createState() => _EntriesState();
}

class _EntriesState extends State<Entries> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("lib/img/yourname.png"), fit: BoxFit.cover)),
      child: ListView.builder(
          itemCount: dummyData.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _showDiaryEntryDialog(context);
              },
              child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                dummyData[index].date,
                                style: GoogleFonts.ubuntu(
                                    fontSize: 36,
                                    fontWeight: FontWeight.normal,
                                    height: 1,
                                    color: Colors.blue),
                              ),
                              Text(
                                dummyData[index].day,
                                style: GoogleFonts.ubuntu(
                                    fontSize: 18, color: Colors.blue),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dummyData[index].time,
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.blue),
                                ),
                                Text(
                                  dummyData[index].title,
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 14, color: Colors.blue),
                                ),
                                Text(
                                  dummyData[index].entry,
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 12,
                                      color: const Color.fromARGB(
                                          255, 48, 46, 46)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Image.asset(
                                "lib/weather/icons8-partly-cloudy-day-48.png",
                                width: 24,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: SvgPicture.asset(
                                  "lib/emoji/beaming-face-with-smiling-eyes.svg",
                                  width: 24,
                                  theme: SvgTheme(currentColor: Colors.blue),
                                )),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                LucideIcons.bookmark,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            );
          }),
    );
  }

  void _showDiaryEntryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDiaryEntryDialog(); // Use your custom dialog widget here
      },
    );
  }
}

class CustomDiaryEntryDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(2.0),
        margin: EdgeInsets.symmetric(vertical: 2.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 80, 139, 171),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Icon(
                  LucideIcons.x,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "October",
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "2",
                        style: GoogleFonts.chivo(
                          color: Colors.white,
                          fontSize: 78,
                          height: 1,
                        ),
                      ),
                      Text(
                        "Sunday" + ", " + "18:30",
                        style: GoogleFonts.sora(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(LucideIcons.moreVertical,
                              color: Colors.white)),
                      Image.asset(
                        "lib/weather/icons8-storm-with-heavy-rain-48.png",
                        width: 30,
                      ),
                      Row(
                        children: [
                          Icon(
                            LucideIcons.mapPin,
                            color: Colors.white, // Location icon
                            size: 18.0, // Icon size
                          ),
                          SizedBox(width: 2),
                          Text(
                            "Home", // Text
                            style: GoogleFonts.nunito(
                              fontSize: 14.0, // Text font size
                              color: Colors.white,
                              fontWeight: FontWeight.bold, // Text font weight
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double containerHeight =
                      constraints.maxHeight; // 100% of screen height

                  return SingleChildScrollView(
                    child: Container(
                      height: containerHeight,
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(16)),
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Text(
                            "This is my diary. It's a long diary... (your long texthis is my diary. It's a long diary... (your long texthis is my diary. It's a long diary... (your long texthis is my diary. It's a long diary... (your long texthis is my diary. It's a long diary... (your long texthis is my diary. It's a long diary... (your long texthis is my diary. It's a long diary... (your long texthis is my diary. It's a long diary... (your long texthis is my diary. It's a long diary... (your long texthis is my diary. It's a long diary... (your long texthis is my diary. It's a long diary... (your long texthis is my diary. It's a long diary... (your long texthis is my diary. It's a long diary... (your long texthis is my diary. It's a long diary... (your long texthis is my diary. It's a long diary... (your long texthis is my diary. It's a long diary... (your long text here)",
                            style: GoogleFonts.nunito(fontSize: 18),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
