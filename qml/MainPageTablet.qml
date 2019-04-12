import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3

/* library from github.com/mourner/suncalc  */
import "./js/suncalc.js" as Suncalc

import "./js/Storage.js" as Storage
import "./js/DateUtils.js" as Dateutils
import "./js/PrintUtils.js" as PrintUtils

/* used to get Moon phase description and zodiac constellation */
import "./js/mooncalc.js" as Mooncalc


/*
   Main page with the layout for tablets
*/
Page {

    id:mainPage

    Component.onCompleted: {

        //For users that have old version
        if(settings.removeOldLocationTable == true){
           Storage.dropLocationTable();
           Storage.createLocationTable();
           Storage.insertCityWithTimeZone();
           settings.removeOldLocationTable = false
           settings.defaultDataImported = true
           settings.isFirstUse = false //shuold be already false
        }

       //for new users
       else if(settings.isFirstUse == true) {
           Storage.createLocationTable();
           Storage.insertCityWithTimeZone();
           settings.isFirstUse = false
           settings.defaultDataImported = true
           settings.removeOldLocationTable = false
       }

       Storage.getCountryNames();

       /* if set, load favourite country,city */
       if(settings.favouriteCountry !=='' && settings.favouriteCity !=='')
       {
          countryChooserButton.text = settings.favouriteCountry;
          //load city of favourite country
          Storage.getCityNames(settings.favouriteCountry);
          cityChooserButton.text = settings.favouriteCity;

          cityChooserButton.enabled = true;
          dateButton.enabled = true;
       }
    }


    header: PageHeader {
        title: "iMoon"

        leadingActionBar.actions: [
            Action {
                id: infoPopover
                /* note: icons names are file names under: /usr/share/icons/suru */
                iconName: "info"
                text: i18n.tr("Info")
                onTriggered:{
                    PopupUtils.open(productInfoDialogue)
                }
            }
        ]

        trailingActionBar.actions: [

            /* add the chosen country, city as user favourite one */
            Action {
                iconName: "bookmark"
                text: i18n.tr("Favourite")
                onTriggered:{
                    PopupUtils.open(favouriteCountryCityDialogue,mainPage,{country:countryChooserButton.text, city:cityChooserButton.text})
                }
            },

            /* add a new city not available in the local database */
            Action {
                iconName: "add"
                text: "Add"
                onTriggered:{
                    pageStack.push(Qt.resolvedUrl("AddCityPage.qml"))
                }
            },

            Action {
                id: helpPopover
                /* note: icons names are file names under: /usr/share/icons/suru */
                iconName: "help"
                text: i18n.tr("Help")
                onTriggered:{
                    pageStack.push(Qt.resolvedUrl("TerminologyPage.qml"))
                }
            }
        ]
    }


    /* define how to render the entry in the OptionSelector */
    Component {
        id: countryListModelDelegate
        OptionSelectorDelegate { text: country; }
    }

    /* define how to render the entry in the OptionSelector */
    Component {
        id: cityListModelDelegate
        OptionSelectorDelegate { text: city; }
    }


    /* ------------- Country Chooser --------------- */
    Component {
             id: countryNameChooserComponent

             Dialog {
                 id: countryNameChooserDialog
                 title: i18n.tr("Found")+" "+countryNamesListModel.count+" "+ i18n.tr("country")

                 OptionSelector {
                     id: cityNameOptionSelector
                     expanded: true
                     multiSelection: false
                     delegate: countryListModelDelegate
                     model: countryNamesListModel
                     containerHeight: itemHeight * 6
                 }

                 Row {
                     spacing: units.gu(2)
                     Button {
                         text: i18n.tr("Close")
                         width: units.gu(14)
                         onClicked: {
                             PopupUtils.close(countryNameChooserDialog)
                         }
                     }

                     Button {
                         text: i18n.tr("Select")
                         width: units.gu(14)
                         onClicked: {
                            var targetCountry = countryNamesListModel.get(cityNameOptionSelector.selectedIndex).country;
                            Storage.getCityNames(targetCountry);
                            countryChooserButton.text = targetCountry;
                            PopupUtils.close(countryNameChooserDialog)

                            cityChooserButton.enabled = true

                            /* clean old choices in combo and  old results */
                            cityChooserButton.text = i18n.tr("City")
                            calculateButton.enabled = false
                            sunInfoRow.visible = false
                            moonInfoRow.visible = false
                            cityInfoRow.visible = false
                            alertRow.visible = false
                         }
                     }
                 }
           }
    }
    /* -------------------------------------------------------------------- */

    /* ---------------------------- City Chooser ------------------------- */
    Component {
              id: cityChooserComponent

              Dialog {
                  id: cityChooserDialog
                  title: i18n.tr("Found")+" "+cityNamesListModel.count+" "+ i18n.tr("city")

                  OptionSelector {
                      id: cityNameOptionSelector
                      expanded: true
                      multiSelection: false
                      delegate: cityListModelDelegate
                      model: cityNamesListModel
                      containerHeight: itemHeight * 6
                  }

                  Row {
                      spacing: units.gu(2)
                      Button {
                          text: i18n.tr("Close")
                          width: units.gu(14)
                          onClicked: {
                              PopupUtils.close(cityChooserDialog)
                          }
                      }

                      Button {
                          text: i18n.tr("Select")
                          width: units.gu(14)
                          onClicked: {
                              cityChooserButton.text = cityNamesListModel.get(cityNameOptionSelector.selectedIndex).city;
                              PopupUtils.close(cityChooserDialog)
                              dateButton.enabled = true;
                              //hide previous choice and result
                              sunInfoRow.visible = false
                              moonInfoRow.visible = false
                              cityInfoRow.visible = false
                              alertRow.visible = false
                          }
                      }
                  }
            }
      }

     /* --------------------------------------------------------------------- */


     /* ------------------------Date chooser ---------------------------------- */
     Component {
             id: popoverDatePickerComponent
             Popover {
                   id: popoverDatePicker

                    DatePicker {
                         id: timePicker
                         mode: "Days|Months|Years"
                         minimum: {
                             var time = new Date()
                             time.setFullYear(1900)
                             return time
                         }

                         /* when Datepicker is closed, is updated the date shown in the button */
                         Component.onDestruction: {
                             root.targetDate = timePicker.date;
                             dateButton.text = Qt.formatDateTime(timePicker.date, "dd MMMM yyyy")
                             calculateButton.enabled = true
                         }
                    }
              }
     }
    //-------------------------------------------------------

    Column{
          id: resultColumn
          spacing: units.gu(2)
          width: parent.width
          height: parent.height

          /* invisible placeholder */
          Rectangle {
             color: "transparent"
             width: parent.width
             height: units.gu(6)
         }

         Row{
            id:inputParameterRow
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: units.gu(3)
            height:units.gu(4)

            /* open the popOver component with DatePicker */
            Button {
                id: countryChooserButton
                iconName: "find"
                width: units.gu(25)
                text: i18n.tr("Country")
                onClicked: {
                    PopupUtils.open(countryNameChooserComponent, countryChooserButton)
                }
            }

            /* open the popOver component with DatePicker */
            Button {
                id: cityChooserButton
                iconName: "find"
                width: units.gu(25)
                text: i18n.tr("City")
                enabled: false /* enabled when a country is chosen */
                onClicked: {
                    PopupUtils.open(cityChooserComponent, cityChooserButton)
                }
            }

            /* open the popOver component with DatePicker */
            Button {
                 id: dateButton
                 width: units.gu(18)
                 text: i18n.tr("Date")
                 enabled: false /* enabled when a city is chosen */
                 onClicked: {
                    PopupUtils.open(popoverDatePickerComponent, dateButton)
                 }
            }

            Button {
                id:calculateButton

                width: units.gu(20)
                color: UbuntuColors.green
                text: i18n.tr("Calculate")
                enabled:false
                onClicked: {

                  var cityCoordinates = Storage.getCityCoordinates(countryChooserButton.text, cityChooserButton.text);
                  var chosenDate = new Date (root.targetDate);
                  var dlsTime = 'false';

                  /* target city geo parameters */
                  cityTimezone.text = i18n.tr("Timezone")+": "+cityCoordinates.timezone
                  cityUtcOffset.text = i18n.tr("UTC offset")+": "+cityCoordinates.utcoffset +" "+i18n.tr("hours")
                  cityLatitudeLabel.text = i18n.tr("Latitude")+": "+cityCoordinates.latitude + " °"
                  cityLongitudeLabel.text = i18n.tr("Longitude")+": "+cityCoordinates.longitude + " °"


                  /* ********************************** SUN ********************************* */
                  var times = Suncalc.getTimes(chosenDate, cityCoordinates.latitude, cityCoordinates.longitude);

                  sunriseLabel.text = i18n.tr("Sunrise")+": "+Dateutils.getLocalTime(times.sunrise,cityCoordinates.utcoffset);
                  sunsetLabel.text = i18n.tr("Sunset")+": "+Dateutils.getLocalTime(times.sunset,cityCoordinates.utcoffset);
                  solarNoonLabel.text = i18n.tr("Solar Noon")+": "+Dateutils.getLocalTime(times.solarNoon,cityCoordinates.utcoffset);

                  var sunPosition = Suncalc.getPosition(chosenDate, cityCoordinates.latitude, cityCoordinates.longitude);

                  /* convert to degrees */
                  var azimuthDegree = sunPosition.azimuth * 180 / Math.PI;
                  var altitudeDegree = sunPosition.altitude * 180 / Math.PI;

                  sunPositionAltitudeLabel.text = i18n.tr("Altitude")+": "+parseFloat(sunPosition.altitude).toFixed(3)+ " rad <br/> ("+parseFloat(altitudeDegree).toFixed(3)+" "+i18n.tr("degrees")+")"
                  sunPositionAzimuthLabel.text = i18n.tr("Azimuth")+": "+parseFloat(sunPosition.azimuth).toFixed(3)+ " rad <br/> ("+parseFloat(azimuthDegree).toFixed(3)+" "+i18n.tr("degrees")+")"

                  //DEBUG: PrintUtils.printSunReport(chosenDate, times, sunPosition);


                  /* ********************************** MOON (using Suncalc & Mooncalc lib) ******************************** */
                  var moonPosition = Suncalc.getMoonPosition(chosenDate, cityCoordinates.latitude, cityCoordinates.longitude);

                  /* convert to degrees */
                  var moonAltitudeDegree = moonPosition.altitude * 180 / Math.PI;
                  var moonAzimuthDegree = moonPosition.azimuth * 180 / Math.PI;
                  var moonParallacticAngleDegree = moonPosition.parallacticAngle * 180 / Math.PI;

                  /* Position */
                  moonAltitudeLabel.text = i18n.tr("Altitude")+": "+parseFloat(moonPosition.altitude).toFixed(3) + " rad <br/> ("+parseFloat(moonAltitudeDegree).toFixed(3)+" "+i18n.tr("degrees")+")"
                  moonAzimuthLabel.text = i18n.tr("Azimuth")+": "+parseFloat(moonPosition.azimuth).toFixed(3)+ " rad <br/> ("+parseFloat(moonAzimuthDegree).toFixed(3)+" "+i18n.tr("degrees")+")"
                  moonDistanceLabel.text = i18n.tr("Distance")+": "+parseInt(moonPosition.distance) + " Km"
                  parallacticAngleLabel.text = i18n.tr("Parallactic Angle")+": "+ parseFloat(moonPosition.parallacticAngle).toFixed(3) + " rad <br/> ("+parseFloat(moonParallacticAngleDegree).toFixed(3)+" "+i18n.tr("degrees")+")"

                  /* Illumination and Phase */
                  var moonPhase = Suncalc.getMoonIllumination(chosenDate);

                  /* NOTE: for precision reason, use Mooncalc js lib instead of Suncalc for moon phase label */
                  var moonCalcData = Mooncalc.getMoonInformations(chosenDate);

                  /* illuminated fraction: varies from 0.0 (new moon) to 1.0 (full moon) */
                  moonPhaseFractionLabel.text = i18n.tr("Illuminated fraction")+": "+ (parseFloat(moonPhase.fraction).toFixed(2)*100) +" %"

                  /* moon phase; varies from 0.0 to 1.0 if > 0.50 moon decrease */
                  //moonPhaseLabel.text = i18n.tr("Phase")+": "+parseInt(moonPhase.phase) + " <b> ("+moonCalcData.phase+ ")</b>"
                  moonPhaseLabel.text = i18n.tr("Phase")+": <b> ("+moonCalcData.phase+ ")</b>"

                  /* new: params available with  Mooncalc js */
                  constellationLabel.text = i18n.tr("Constellation")+": "+ moonCalcData.constellation
                  moonTrajectoryLabel.text = i18n.tr("Moon trajectory")+": "+ moonCalcData.trajectory

                  /* zodiac image to show */
                  root.zodiacImage = Qt.resolvedUrl("images/"+moonCalcData.constellation +".png")
                  zodiacImageButton.visible = true

                  var moonAngleDegree = moonPhase.angle * 180 / Math.PI;
                  //if > 0.50 moon decrease
                  moonAngleLabel.text = i18n.tr("Angle")+": "+parseFloat(moonPhase.angle).toFixed(3) + " rad <br/> ("+parseFloat(moonAngleDegree).toFixed(4)+" "+i18n.tr("degrees")+")"

                  var moonRise = Suncalc.getMoonTimes(chosenDate, cityCoordinates.latitude, cityCoordinates.longitude);
                  moonRiseLabel.text = i18n.tr("MoonRise")+": "+Dateutils.getLocalTime(moonRise.rise,cityCoordinates.utcoffset);
                  moonSetLabel.text = i18n.tr("MoonSet")+": "+Dateutils.getLocalTime(moonRise.set,cityCoordinates.utcoffset);

                  /*
                    NOTE: maybe for bug o the lib, moonRise.alwaysUp, moonRise.alwaysDown values are always undefined (?) don't show them
                  */

                  //DEBUG: PrintUtils.printMoonReport(chosenDate, moonPosition, moonPhase, moonRise);

                  sunImageContainer.visible = true
                  moonImageContainer.visible = true
                  resultColumn.visible = true
                  sunInfoRow.visible = true
                  moonInfoRow.visible = true
                  cityInfoRow.visible = true
                  cityTimeInfoRow.visible = true
                  cityUtcOffsetRow.visible = true
                  alertRow.visible = true
              }
           }
        }

        /* invisible line separator */
        Rectangle {
             color: "transparent"
             width: units.gu(100)
             height: units.gu(0.1)
        }

        Row{
            id: cityInfoRow
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: units.gu(1)

            Label{
                id: cityLatitudeLabel
                text: " " //placeholder
            }

            Label{
                id: cityLongitudeLabel
                text: " "
            }

            Label{
                id: cityTimezone
                text: " "
            }

            Label{
                id: cityUtcOffset
                text: " "
            }
        }

        /* in case of DLS show a warning */
        Row{
            id: alertRow
            visible: false
            anchors.horizontalCenter: parent.horizontalCenter

            Label{
                id: message
                text: i18n.tr("Times does not care of DayLight Saving: if used add +1 hour")
                color: "orange"
            }
        }


        /* invisible line separator */
        Rectangle {
            color: "transparent"
            width: units.gu(100)
            height: units.gu(0.1)
        }

        /* ------------------- SUN -------------------- */
        Row{
            id: sunInfoRow
            spacing: units.gu(2)
            height:parent.height/4
            width: parent.width/3

            Rectangle {
                id: sunImageContainer
                visible: false
                width: parent.width
                height:parent.height
                color: "transparent"
                border.color: "transparent"
                Image {
                    id: sunImage
                    source: Qt.resolvedUrl("images/sun.png")
                    width: parent.width
                    height: parent.height
                    fillMode: Image.PreserveAspectFit
                }
            }

            Column{

                spacing: units.gu(1)

                Label {
                    id: sunriseLabel
                    text: ""
                    font.bold: true
                }

                Label {
                    id: sunsetLabel
                    text: ""
                    font.bold: true
                }

                Label {
                    id: solarNoonLabel
                    text: ""
                }

                Label {
                    id: sunPositionAltitudeLabel
                    text: ""
                }

                Label {
                    id: sunPositionAzimuthLabel
                    text: ""
                }
            }
        }


        /* ------------------- Moon -------------------- */
        Row{
            id: moonInfoRow
            spacing: units.gu(2)
            height:parent.height/4
            width: parent.width/3

            Rectangle {
                id: moonImageContainer
                visible: false
                width: parent.width
                height:parent.height
                color: "transparent"
                border.color: "transparent"
                Image {
                    id: monImage
                    source: Qt.resolvedUrl("images/moon.png")
                    width: parent.width
                    height: parent.height
                    fillMode: Image.PreserveAspectFit
                }
            }

            Column{
                spacing: units.gu(1)

                //----------- Moon rise -------
                Label {
                    id: moonRiseLabel
                    text: ""
                    font.bold: true
                }

                Label {
                    id: moonSetLabel
                    text: ""
                    font.bold: true
                }

                //------- Moon Position ------
                Label {
                    id: moonAltitudeLabel
                    text: ""
                }

                Label {
                    id: moonDistanceLabel
                    text: ""
                }

                Label {
                    id: moonAzimuthLabel
                    text: ""
                }

                Label {
                    id: parallacticAngleLabel
                    text: ""
                }

                //-------- Moon illumination -------
                Label {
                    id: moonPhaseFractionLabel
                    text: ""
                }

                /* if > 0.50 moon decrease */
                Label {
                    id: moonPhaseLabel
                    text: ""
                }

                Label {
                    id: moonAngleLabel
                    text: ""
                }

                Label {
                   id: moonTrajectoryLabel
                   text: ""
                }

                Label {
                  id: constellationLabel
                  text : ""
                }

               Rectangle {
                   width: units.gu(14)
                   height:  units.gu(4)
                   Button {
                       id: zodiacImageButton
                       height:parent.height
                       visible: false
                       text: i18n.tr("Display")
                       onClicked: {
                           PopupUtils.open(zodiacImagePopUp)
                       }
                  }
               }

            }

        }
    }
}
