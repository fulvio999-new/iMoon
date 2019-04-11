import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3


/* Ask if save current country, city as favourites */
Dialog {
    id: favouriteCountryCityDialog
    title: i18n.tr("Confirmation")

    /* the chosen values to save */
    property string country;
    property string city;

    Component.onCompleted:{

      //check for valid values
      if(country === i18n.tr("Country") && city === i18n.tr("City"))
      {
         confirmButton.enabled = false;
         resultLabel.color = "red";
         resultLabel.text = i18n.tr("Set a valid country and city");
      }
    }

    Column{
        spacing: units.gu(2)

        Row{
           anchors.horizontalCenter: parent.horizontalCenter
          Text {
              text: i18n.tr("Set country and city as favourite ?")+"<br/> "+i18n.tr("(will be loaded at startup)")
              color: "navy"
           }
        }

        Row {
            spacing: units.gu(2)
            Button {
                text: i18n.tr("Close")
                width: units.gu(14)
                onClicked: {
                  PopupUtils.close(favouriteCountryCityDialog)
                }
            }

            Button {
                id: confirmButton
                text: i18n.tr("Confirm")
                width: units.gu(14)
                onClicked: {
                     settings.favouriteCountry = country;
                     settings.favouriteCity = city;

                     resultLabel.color = "green";
                     resultLabel.text = i18n.tr("Operation executed successfully");
                }
            }
       }

       Row {
         id: operationResultRow
         anchors.horizontalCenter: parent.horizontalCenter

         Label{
           id:resultLabel
           text: " "
         }
       }
   }
}
