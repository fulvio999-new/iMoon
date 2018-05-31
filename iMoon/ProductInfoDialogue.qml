import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3


/* General info about the application */
Dialog {
       id: aboutProductDialogue
       title: i18n.tr("Product Info")
       text: "iMoon "+root.appVersion+"<br/>"+i18n.tr("A simple offline Moon phases and Sun parameters calculator based on SunCalc and Mooncalc, a BSD-licensed JS library")+"<br/> Author: fulvio"

       Button {
           text: i18n.tr("Close")
           onClicked: PopupUtils.close(aboutProductDialogue)
       }
}
