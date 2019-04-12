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

/*
  Some useful terminology about moon & sun
*/
Page{
    id:terminologyPage
    visible: false

    header: PageHeader {
        title: i18n.tr("Terminology and Notes")
    }

    Column{
        id: infoColumn
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
                text: i18n.tr("Azimuth: angular measurement in a spherical coordinate system")
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
                text: i18n.tr("Sun and Moon parameters are show with 4 decimal digits")
            }
        }

        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            Label{
                id: dayLight
                text: i18n.tr("Day light saving (DLS): advancing clocks during summer months")
            }
        }

        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            Label{
                id: hourInfo
                text: "<b>"+i18n.tr("Showed times don't consider DLS (add +1 hour to get it)")+"</b>"
            }
        }

        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            Label{
                id: radian
                text: i18n.tr("1 rad = 180°/π = 57.295779513°")
            }
        }

        Image {
              id: image
              anchors.horizontalCenter: parent.horizontalCenter
              width: parent.width * 0.8
              height: parent.width * 0.8
              source: Qt.resolvedUrl("images/azimuth-elevation.png")
              fillMode: Image.PreserveAspectCrop
              /* to reduce the amount of image pixel stored, to improve performance on load, NOT the scale of the image */
              sourceSize.width: 400
              sourceSize.height: 400
              asynchronous: true
         }

         Row{
             anchors.horizontalCenter: parent.horizontalCenter
             Label{
                 id: imageCredit
                 text: i18n.tr("Credit: photopills.com for the image")
             }
         }
    }
}
