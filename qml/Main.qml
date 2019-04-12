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


/*!
   App MainView
*/

MainView {

    id: root

    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "imoon.fulvio"

    /*------- Tablet (width >= 110) -------- */
    //vertical
    //width: units.gu(75)
    //height: units.gu(111)

    //horizontal (rel)
    //width: units.gu(111)
    //height: units.gu(90)

    /* ----- phone: 4.5 (the smallest one) ---- */
    //vertical
    width: units.gu(50)
    height: units.gu(96)

    //horizontal
    //width: units.gu(96)
    //height: units.gu(50)

    /* ----- phone: N5  ---- */
    //vertical
    //width: units.gu(108)
    //height: units.gu(192)

    //horizontal
    //width: units.gu(192)
    //height: units.gu(108)

    /* ----- phone: One plus One  ---- */
    //vertical
    //width: units.gu(108)
    //height: units.gu(216)

    //horizontal
    //width: units.gu(216)
    //height: units.gu(108)

    /* ----- phone: Fairphone  ---- */
    //vertical
    //width: units.gu(108)
    //height: units.gu(192)

    //horizontal
    //width: units.gu(192)
    //height: units.gu(108)
    /* ---------------------------- */

    //true if horizontal screen
    property bool landscapeWindow: root.width > root.height

    anchorToKeyboard: true

    property string appVersion : "1.6.2"
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
        /* user favourite city and country to load at start-up */
        property string favouriteCountry : '';
        property string favouriteCity : '';
    }

    /* the file name with the zodia image to show: set after performing calculations */
    property string zodiacImage : ""

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

              if(root.width <= units.gu(54)) {
                 pageStack.push(Qt.resolvedUrl("MainPagePhone.qml")) //BQ E4.5
              }else if(root.width > units.gu(110)) {
                  pageStack.push(Qt.resolvedUrl("MainPageTablet.qml"))
               }else{
                   pageStack.push(Qt.resolvedUrl("MainPagePhone.qml")) //phones other than E4.5
               }
          }

          /* The country names loaded at App startUp form Phone or Tablet main page */
          ListModel {
              id: countryNamesListModel
          }

          /* the world time zone list (used in Add new city page) */
          ListModel {
              id: timeZoneListModel
          }

          /* The available city names for the choosen country */
          ListModel {
              id: cityNamesListModel
          }

          Component {
              id: zodiacImagePopUp
              ZodiacImage{}
          }
     }

}
