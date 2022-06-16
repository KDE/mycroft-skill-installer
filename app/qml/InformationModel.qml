/*
 *   SPDX-FileCopyrightText: 2019-2020 Aditya Mehra <aix.m@outlook.org>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.9
import org.kde.kirigami 2.12 as Kirigami
import org.kde.plasma.components 2.0 as PlasmaComponents
import GlobalConfiguration 1.0

Item {
    property var currentURL
    property var orignalFolder
    property var skillFolderName
    property var skillFolder
    property var branch
    property bool hasOrginal
    property bool hasSystemDeps
    property var supportedPlatforms
    property bool hasDesktopFile
    property var skillUpdatePath
    property Component highlighter: PlasmaComponents.Highlight{}
    property Component emptyHighlighter: Item{}
    property string categoryURL
    property var jlist: []
    property var fntSize: Kirigami.Units.gridUnit * 2
    property var backendType: GlobalConfiguration.backendConfig

    onBackendTypeChanged: {
        console.log("Backend type changed to: " + backendType)
    }

    signal skillModelChanged
}
