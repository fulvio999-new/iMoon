import QtQuick 2.0
import Qt.labs.settings 1.0

Settings {

    /* if 'true' means that is the first time that the user open teh application: is necessary create the Database */
    property bool isFirstUse:true;
    property bool defaultDataImported:false;
    property bool removeOldLocationTable:true;
    /* favourite city, country to load at start-up so that user don't need to search them */
    property string favouriteCountry : '';
    property string favouriteCity : ''; 

}
