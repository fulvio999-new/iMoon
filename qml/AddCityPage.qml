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
import "./js/ValidationUtils.js" as ValidationUtils


/* Page to add a new city not present in the database */
Page {
    id:addCityPage
    visible: false

    header: PageHeader {
        title: i18n.tr("Add a new city")
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
                            /* get the available Timezone in the choosen country */
                            Storage.getTimeZonesForCountry(targetCountry);

                            addCountryChooserButton.text = targetCountry;
                            timeZoneChooserButton.text = i18n.tr("Choose");
                            utcOffsetText.text = "";
                            timeZoneChooserButton.enabled = true;
                            PopupUtils.close(countryNameChooserDialog)
                         }
                     }
                 }
           }
    }
    /* -------------------------------------------------------------------- */

    /* ------------- Time zone Chooser (used in add new City page) --------------- */
    Component {
             id: timeZoneChooserComponent

             Dialog {
                 id: timeZoneChooserDialog
                 title: i18n.tr("Found")+" "+timeZoneListModel.count+" "+ i18n.tr("zones")

                 OptionSelector {
                     id: timeZoneOptionSelector
                     expanded: true
                     multiSelection: false
                     delegate: OptionSelectorDelegate { text: zone; }
                     model: timeZoneListModel
                     containerHeight: itemHeight * 6
                 }

                 Row {
                     spacing: units.gu(2)
                     Button {
                         text: i18n.tr("Close")
                         width: units.gu(14)
                         onClicked: {
                             PopupUtils.close(timeZoneChooserDialog)
                         }
                     }

                     Button {
                         text: i18n.tr("Select")
                         width: units.gu(14)
                         onClicked: {
                            var targetTimeZone = timeZoneListModel.get(timeZoneOptionSelector.selectedIndex).zone;
                            var utcoffset = timeZoneListModel.get(timeZoneOptionSelector.selectedIndex).utcoffset;
                            utcOffsetText.text = utcoffset;
                            timeZoneChooserButton.text = targetTimeZone;
                            PopupUtils.close(timeZoneChooserDialog)
                         }
                     }
                 }
           }
    }
    /* --------------------------------------------- */

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
                anchors.verticalCenter: timeZoneChooserButton.verticalCenter
                text: "* "+i18n.tr("TimeZone")+":"
            }

            Button {
                id: timeZoneChooserButton
                enabled:false
                iconName: "find"
                width: units.gu(23)
                text: i18n.tr("Choose")
                onClicked: {
                    PopupUtils.open(timeZoneChooserComponent, timeZoneChooserButton)
                }
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
                readOnly: true
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
                              ValidationUtils.isInputTextEmpty(timeZoneChooserButton.text)    ||
                              ValidationUtils.isInputTextEmpty(utcOffsetText.text))

                    {
                        PopupUtils.open(notificationInputInvalidDialogue)

                    }else if(Storage.isCityDuplicated(addCountryChooserButton.text, newCityNameText.text) ){
                        PopupUtils.open(notificationCityDuplicatedDialogue)

                    }else{
                        Storage.addNewCity(addCountryChooserButton.text, newCityNameText.text, latitudeText.text, longitudeText.text, timeZoneChooserButton.text,utcOffsetText.text)

                        PopupUtils.open(notificationSuccessDialogue)

                        //clean input fields
                        addCountryChooserButton.text = i18n.tr("Choose")
                        newCityNameText.text = ""
                        latitudeText.text = ""
                        longitudeText.text = ""
                        timeZoneChooserButton.text = ""
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
