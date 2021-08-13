/*
 *   SPDX-FileCopyrightText: 2019-2020 Aditya Mehra <aix.m@outlook.org>
 *   SPDX-FileCopyrightText: 2019-2020 Marco Martin <mart@kde.org>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kirigami 2.11 as Kirigami

Kirigami.AbstractListItem {
    background: Rectangle {
        color: Kirigami.Theme.backgroundColor
    }

    function listProperty(item)
    {
        for (var p in item)
        console.log(p + ": " + item[p]);
    }

    contentItem: RowLayout {
        anchors.fill: parent

        Kirigami.Icon {
            Layout.preferredHeight: Kirigami.Units.iconSizes.small
            Layout.preferredWidth: Kirigami.Units.iconSizes.small
            source: "choice-round"
        }

        Kirigami.Heading {
            id: exLabel
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.fillHeight: true
            level: 3
            maximumLineCount: 1
            elide: Text.ElideRight
            color: PlasmaCore.ColorScope.textColor
            font.capitalization: Font.Capitalize
            text: modelData
        }
    }
}
