import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenity/src/services/navigation_service.dart';
import 'package:serenity/src/views/scroll_sheet.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GetIt locator = GetIt.instance;
  @override
  Widget build(BuildContext context) {
    final navigationService = locator<NavigationService>();
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final width = MediaQuery.of(context).size.width;
    print("nolas");
    print(height * 0.6);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFEDCCEE),
        body: ScrollSheet(
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.05),
                  child: Container(
                    height: height * 0.22,
                    width: width * 0.84,
                    decoration: BoxDecoration(
                      color: Color(0x547400B8),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(width * 0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Recommended\n Meditation",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: height * 0.03,
                              height: 1,
                            ),
                          ),
                          Text(
                            "Recommendation of the day",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              fontSize: height * 0.019,
                              height: 1,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: OutlinedButton(
                              onPressed: () {
                                print('Received click');
                              },
                              child: Text(
                                'Listen Meditation',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: height * 0.023,
                                  height: 1,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: height * 0.02),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(height * 0.02),
                                ),
                                backgroundColor: Colors.transparent,
                                side: BorderSide(
                                    color: Colors.black,
                                    width: 3,
                                    style: BorderStyle.solid),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          panel: Container(
            child: Text("Paneles"),
          ),
          isDraggable: false,
          maxHeight: height * 0.67,
          minHeight: height * 0.67,
        ),
      ),
    );
  }
}
