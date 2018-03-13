TEMPLATE = aux
TARGET = iMoon

RESOURCES +=  imoon.qrc \

QML_FILES += $$files(*.qml,true) \
             $$files(*.png,true) \
             $$files(*.js,true)


CONF_FILES +=  iMoon.apparmor \
               iMoon.png

AP_TEST_FILES += tests/autopilot/run \
                 $$files(tests/*.py,true)               

OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
               $${AP_TEST_FILES} \
               iMoon.desktop

#specify where the qml/js files are installed to
qml_files.path = /iMoon
qml_files.files += $${QML_FILES}

#specify where the config files are installed to
config_files.path = /iMoon
config_files.files += $${CONF_FILES}

#install the desktop file, a translated version is 
#automatically created in the build directory
desktop_file.path = /iMoon
desktop_file.files = $$OUT_PWD/iMoon.desktop
desktop_file.CONFIG += no_check_exist

INSTALLS+=config_files qml_files desktop_file

DISTFILES += \
    Settings.qml \
    moon.png \
    ProductInfoDialogue.qml \
    PrintUtils.js \
    MoonPhaseUtil.js \
    MainPageTablet.qml \
    MainPagePhone.qml \
    ValidationUtils.js \
    NotificationMessage.qml
