/*
 *  Copyright 2019 Aditya Mehra <aix.m@outlook.com>
 *  Copyright 2019 Marco Martin <mart@kde.org>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  2.010-1301, USA.
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
