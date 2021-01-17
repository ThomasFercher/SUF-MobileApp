import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/climate/editWaterSoil.dart';
import 'package:sgs/customwidgets/general/appBarHeader.dart';
import 'package:sgs/customwidgets/climate/dayslider.dart';
import 'package:sgs/customwidgets/climate/editVariable.dart';
import 'package:sgs/customwidgets/climate/input.dart';
import 'package:sgs/objects/climateControl.dart';
import 'package:sgs/providers/dataProvider.dart';
import 'package:sgs/providers/climateControlProvider.dart';
import 'package:sgs/providers/settingsProvider.dart';
import 'package:weather_icons/weather_icons.dart';
import '../styles.dart';
import 'package:sgs/objects/appTheme.dart';

class EditEnvironment extends StatelessWidget {
  ClimateControl initialSettings;
  bool create;

  EditEnvironment({@required this.initialSettings, @required this.create});

  save(ClimateControl settings, context) {
    print(settings);
    create
        ? Provider.of<DataProvider>(context, listen: false)
            .createClimate(settings)
        : Provider.of<DataProvider>(context, listen: false)
            .editClimate(this.initialSettings, settings);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var name = initialSettings.name;
    return ListenableProvider(
      create: (_) => ClimateControlProvider(initialSettings),
      builder: (context, child) {
        AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
        //   EnvironmentSettings settings = d.getSettings();
        return Consumer<ClimateControlProvider>(builder: (context, pr, child) {
          return AppBarHeader(
            title: create ? "Create Climate" : "Edit $name",
            isPage: true,
            contentPadding: false,
            bottomBarColor: theme.cardColor,
            bottomAction: Container(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(0.0, -2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: RaisedButton(
                  onPressed: () => save(pr.getSettings(), context),
                  color: theme.primaryColor,
                  textColor: Colors.white,
                  child: Text(
                    create ? "Create" : "Save",
                    style: GoogleFonts.nunito(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            body: [
              Input(
                theme: theme,
                initialValue: pr.climateSettings.name,
                valChanged: (val) => pr.changeName(val),
              ),
              EditVariable(
                value: pr.climateSettings.temperature,
                color: Colors.redAccent,
                title: "Temperature",
                unit: "°C",
                icon: WeatherIcons.thermometer,
                min: 0,
                max: 50,
                onValueChanged: (v) {
                  pr.changeTemperature(v);
                },
              ),
              EditVariable(
                value: pr.climateSettings.humidity,
                color: Colors.blueAccent,
                title: "Humidty",
                unit: "%",
                icon: WeatherIcons.humidity,
                min: 0,
                max: 100,
                onValueChanged: (v) {
                  pr.changeHumidity(v);
                },
              ),
             /* EditVariable(
                value: pr.climateSettings.soilMoisture,
                color: Colors.brown,
                title: "Soil Moisture",
                unit: "%",
                icon: WeatherIcons.barometer,
                min: 0,
                max: 100,
                onValueChanged: (v) {
                  pr.changeSoilMoisture(v);
                },
              ),*/
          /*    EditVariable(
                value: pr.climateSettings.waterConsumption,
                color: Colors.lightBlueAccent,
                title: "Water Consumption",
                unit: "l/d",
                icon: WeatherIcons.barometer,
                min: 0,
                max: 100,
                onValueChanged: (v) {
                  pr.changeWaterConsumption(v);
                },
              ),*/
              EditWaterSoil(
                pr: pr,
              ),
              DaySlider(
                onValueChanged: (v) => pr.changeSuntime(v),
                initialTimeString: pr.climateSettings.suntime,
              ),
            ],
          );
        });
      },
    );
  }
}

class PlaceDivider extends StatelessWidget {
  double height;

  PlaceDivider({height}) : height = height ?? 8.0;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
    return Container(
      color: Colors.green[50],
      height: height,
      width: MediaQuery.of(context).size.width,
    );
  }
}
