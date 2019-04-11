import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3


/* show image of the zodiac */
Dialog {
       id: zodiacImageDialogue

       Image {
           id: zodiacImage
           source: root.zodiacImage
           fillMode: Image.PreserveAspectFit
       }

       Button {
          text: i18n.tr("Close")
          onClicked: PopupUtils.close(zodiacImageDialogue)
       }
}
