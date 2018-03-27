import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3

/* library from github.com/mourner/suncalc  */
import "suncalc.js" as Suncalc

import "Storage.js" as Storage
import "DateUtils.js" as Dateutils
import "PrintUtils.js" as PrintUtils
import "MoonPhaseUtil.js" as MoonPhaseUtil
import "ValidationUtils.js" as ValidationUtils


/*!
    \brief MainView with a Label and Button elements
*/

MainView {

    id: root

    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "imoon.fulvio"

    //width: units.gu(100)
    //height: units.gu(76)

    /* phone */
    width: units.gu(50)
    height: units.gu(96)

    anchorToKeyboard: true

    property string appVersion : "1.3"
    property int rectangle_container_size: Math.min (width / 1, height / 2) * 0.8

    /* the chosen Date saved as Javascript date object  */
    property date targetDate: new Date();

    /* Settings file is saved in ~user/.config/<applicationName>/<applicationName>.conf  File */
    Settings {
        id:settings
        /* flag to create or not the database and fill with default data */
        property bool isFirstUse : true;
        property bool defaultDataImported : false;
        property bool removeOldLocationTable : true;
        /* favourite city, country to load at start-up so that user don't need to search them */
        property string favouriteCountry : '';
        property string favouriteCity : '';
    }

    Component {
        id: productInfoDialogue
        ProductInfoDialogue{}
    }

    /* to set default, country city to load on startup */
    Component {
        id: favouriteCountryCityDialogue
        FavouriteCountryCityDialogue{country:country; city:city}
    }

    Component {
        id: notificationSuccessDialogue
        NotificationMessage{message:i18n.tr("Success")}
    }

    Component {
       id: notificationNotNumericValueDialogue
       NotificationMessage{message:i18n.tr("Latitude, Longitude must be numeric with '.' decimal separator")}
    }

    Component {
       id: notificationInputInvalidDialogue
       NotificationMessage{message:i18n.tr("Missing required value")}
    }

    Component {
        id: notificationCityDuplicatedDialogue
        NotificationMessage{message:i18n.tr("City already exist in the country")}
    }


    PageStack {
        id: pageStack

        /* set the firts page of the application depending on the page width */
        Component.onCompleted: {

          if(root.width > units.gu(80)) {
              pageStack.push(mainPageTablet)
           }else{
               pageStack.push(mainPagePhone)
           }
        }

        /* The available country names loaded at App startUp */
        ListModel {
            id: countryNamesListModel
        }

        /* The available city names for the choosen country */
        ListModel {
            id: cityNamesListModel
        }

        Component {
            id: mainPageTablet
            MainPageTablet{}
        }

        Component {
            id: mainPagePhone
            MainPagePhone{}
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
                         delegate: OptionSelectorDelegate { text: country; }
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
                                addCountryChooserButton.text = targetCountry;
                                PopupUtils.close(countryNameChooserDialog)
                             }
                         }
                     }
               }
        }
        /* -------------------------------------------------------------------- */


        /* Page to add a new city not present in the database */
        Page {
            id:addCityPage
            visible: false

            header: PageHeader {
                title: i18n.tr("Add a new city")
            }

            Column{
                spacing: units.gu(2)
                //anchors.leftMargin: units.gu(5)
                width: parent.width
                height: parent.height

                /* placeholder */
                Rectangle {
                    color: "transparent"
                    width: parent.width
                    height: units.gu(6)
                }

                //---------- Country -------
                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: units.gu(3)

                    Label{
                        id:countryNameLabel
                        text: "* "+i18n.tr("Country")+":"
                    }

                    Button {
                        id: addCountryChooserButton
                        iconName: "find"
                        width: units.gu(23)
                        text: i18n.tr("Choose")
                        onClicked: {
                            PopupUtils.open(countryNameChooserComponent, addCountryChooserButton)
                        }
                    }
                }

                //---------- City -------
                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: units.gu(6)

                    Label{
                        id:cityNameLabel
                        text: "* "+i18n.tr("City")+":"
                    }

                    TextField{
                        id: newCityNameText
                        width: units.gu(23)
                    }
                }

                //---------- Latitude -------
                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: units.gu(3)

                    Label{
                        id:latitudeLabel
                        anchors.verticalCenter: latitudeText.verticalCenter
                        text: "* "+i18n.tr("Latitude")+":"
                    }

                    TextField{
                        id: latitudeText
                        width: units.gu(23)
                    }
                }

                //---------- Longitude -------
                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: units.gu(2)

                    Label{
                        id: longitudeLabel
                        anchors.verticalCenter: longitudeText.verticalCenter
                        text: "* "+i18n.tr("Longitude")+":"
                    }

                    TextField{
                        id: longitudeText
                        width: units.gu(23)
                    }
                }

                //---------- TimeZone -------
                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: units.gu(2)

                    Label{
                        id: timezoneLabel
                        anchors.verticalCenter: timeZoneText.verticalCenter
                        text: "* "+i18n.tr("TimeZone")+":"
                    }

                    TextField{
                        id: timeZoneText
                        width: units.gu(23)
                    }
                }

                //---------- UTC offset -------
                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: units.gu(2)

                    Label{
                        id: utcOffsetLabel
                        anchors.verticalCenter: utcOffsetText.verticalCenter
                        text: "* "+i18n.tr("UTC offset")+":"
                    }

                    TextField{
                        id: utcOffsetText
                        width: units.gu(23)
                    }
                }

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: units.gu(2)

                    Button{
                        id: addButton
                        text:i18n.tr("Insert")
                        width: units.gu(25)
                        color: UbuntuColors.green
                        onClicked: {

                            if(ValidationUtils.isNotNumeric(latitudeText.text) || ValidationUtils.isNotNumeric(longitudeText.text)){
                                PopupUtils.open(notificationNotNumericValueDialogue)

                            } else if(ValidationUtils.isInputTextEmpty(addCountryChooserButton.text) ||
                                      ValidationUtils.isInputTextEmpty(newCityNameText.text) ||
                                      ValidationUtils.isInputTextEmpty(latitudeText.text)    ||
                                      ValidationUtils.isInputTextEmpty(longitudeText.text)   ||
                                      ValidationUtils.isInputTextEmpty(timeZoneText.text)    ||
                                      ValidationUtils.isInputTextEmpty(utcOffsetText.text))

                            {
                                PopupUtils.open(notificationInputInvalidDialogue)

                            }else if(Storage.isCityDuplicated(addCountryChooserButton.text, newCityNameText.text) ){
                                PopupUtils.open(notificationCityDuplicatedDialogue)

                            }else{
                                Storage.addNewCity(addCountryChooserButton.text, newCityNameText.text, latitudeText.text, longitudeText.text, timeZoneText.text,utcOffsetText.text)

                                PopupUtils.open(notificationSuccessDialogue)

                                //clean input fields
                                addCountryChooserButton.text = i18n.tr("Choose")
                                newCityNameText.text = ""
                                latitudeText.text = ""
                                longitudeText.text = ""
                                timeZoneText.text = ""
                                utcOffsetText.text = ""

                                //reload listmodels
                                Storage.getCountryNames()
                            }
                          }
                       }
               }


               Row{
                    anchors.horizontalCenter: parent.horizontalCenter

                    Label{
                        id: messageLabel
                        text: "* "+i18n.tr("Field Required")
                    }
                }
            }
       }

        //----------- some useful terminology ---------------
        Page{
            id:terminologyPage
            visible: false

            header: PageHeader {
                title: i18n.tr("Terminology and Notes")
            }

            Column{
                spacing: units.gu(2)

                width: parent.width
                height: parent.height

                /* placeholder */
                Rectangle {
                    color: "transparent"
                    width: parent.width
                    height: units.gu(6)
                }

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Label{
                        id: solarNoon
                        text: i18n.tr("Solar-noon: time when the sun is in the highest position")
                    }
                }

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Label{
                        id: azimuth
                        text: i18n.tr("Azimuth is an angular measurement in a spherical coordinate system")
                    }
                }

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Label{
                        id: latitudeLongitude
                        text: i18n.tr("Latitude and Longitude values uses Decimal Degree (DD) scale")
                    }
                }

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Label{
                        id: parameterRound
                        text: i18n.tr("Sun and Moon parameters are show with 10 decimal digits")
                    }
                }

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Label{
                        id: dayLight
                        text: i18n.tr("Day light saving (DLS): of advancing clocks during summer months")
                    }
                }

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Label{
                        id: hourInfo
                        text: "<b>"+i18n.tr("The showed times don't consider DLS (add +1 hour to get it)")+"</b>"
                    }
                }

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Label{
                        id: radian
                        text: i18n.tr("1 rad = 180°/π = 57.295779513°")
                    }
                }

            }
        }
   }

}
