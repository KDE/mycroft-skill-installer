project(mycroft-skill-installer)

cmake_minimum_required(VERSION 3.16.00)
set(QT_MIN_VERSION "5.9.0")
set(KF5_MIN_VERSION "5.10.0")
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(AUTORCC_OPTIONS "/app/qml.qrc")

find_package(ECM REQUIRED NO_MODULE)

set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake")

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings)
include(ECMInstallIcons)
include(FeatureSummary)

#find_package(PkgConfig REQUIRED)

find_package(Qt5 ${QT_MIN_VERSION} REQUIRED COMPONENTS 
    Core
    Qml 
    Quick 
    Widgets
    QuickControls2
)

find_package(KF5 ${KF5_MIN_VERSION} REQUIRED 
    Kirigami2
    GuiAddons
    CoreAddons
    Config
    ConfigWidgets
)

add_subdirectory(app)

install(
    DIRECTORY preload/
    DESTINATION /opt/MycroftSkillInstaller/cache/
    PATTERN "*.json"
    PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ GROUP_WRITE WORLD_READ WORLD_WRITE
)
