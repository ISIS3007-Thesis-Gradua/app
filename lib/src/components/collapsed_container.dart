import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

void Function() createHandler(PanelController controller) {
  void handlePanelChevronTap() {
    if (controller.isPanelClosed) {
      controller.animatePanelToPosition(1,
          curve: const Cubic(0.17, 0.67, 0.83, 0.67),
          duration: const Duration(milliseconds: 400));
    } else {
      controller.close();
    }
  }

  return handlePanelChevronTap;
}

Widget CollapsedContainer(
        PanelController controller, double screenHeight, double screenWidth) =>
    Container(
      decoration: const BoxDecoration(
        color: Color(0xEEF6F5F5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0x8C8C2C8C), Color(0x8C0071BC)],
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(screenWidth * 0.07, 0, 0, 0),
                child: Text(
                  "Instrucciones",
                  style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ),
            Center(
              child: IconButton(
                onPressed: createHandler(controller),
                icon: Icon(
                  CupertinoIcons.chevron_up,
                  size: screenHeight * 0.025,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
