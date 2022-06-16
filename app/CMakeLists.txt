qt5_add_resources(mycroft_skill_installer_SRCS qml.qrc)
add_executable(MycroftSkillInstaller ${mycroft_skill_installer_SRCS}
    main.cpp
    filereader.cpp
    sysinfo.cpp
    installerlistmodel.cpp
    processcommander.cpp
    globalconfiguration.cpp
)

target_link_libraries(MycroftSkillInstaller 
    Qt5::Quick
    Qt5::Widgets
    Qt5::Core 
    Qt5::Qml
    Qt5::QuickControls2
    KF5::Kirigami2
    KF5::GuiAddons
    KF5::ConfigWidgets
)

install(TARGETS MycroftSkillInstaller ${INSTALL_TARGETS_DEFAULT_ARGS})

set(DesktopNoDisplay "false")
set(DesktopMimeType "application/vnd.debian.binary-package;application/x-rpm;")
set(DesktopExec "MycroftSkillInstaller %F")
configure_file(org.mycroft.skill.installer.desktop.cmake ${CMAKE_CURRENT_BINARY_DIR}/org.mycroft.skill.installer.desktop)
install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/org.mycroft.skill.installer.desktop DESTINATION ${XDG_APPS_INSTALL_DIR})
