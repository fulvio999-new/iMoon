import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3


/* Notify messages at the user */
Dialog {
       id: userMessageDialogue

       property string message;

       title: i18n.tr("Message")
       text: i18n.tr("Operation result")+":  "+userMessageDialogue.message

       Button {
           text: i18n.tr("Close")
           onClicked: PopupUtils.close(userMessageDialogue)
       }
}
