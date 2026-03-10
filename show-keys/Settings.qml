import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
    id: root

    property var pluginApi: null

    property var cfg: pluginApi?.pluginSettings || ({})
    property var def: pluginApi?.manifest?.metadata?.defaultSettings || ({})

    // ── Local edit state ─────────────────────────────────
    property bool   editCapture:  cfg.captureEnabled ?? def.captureEnabled ?? true
    property string editDevice:    cfg.evtestDevice   || def.evtestDevice   || "/dev/input/event3"
    property string editPillColor: cfg.pillColor  || def.pillColor  || "#ffffff"
    property string editPillBg:    cfg.pillBg     || def.pillBg     || "#000000"
    property string editPosition:  cfg.position   || def.position   || "bottom"
    property int    editMargin:    cfg.marginPx   ?? def.marginPx   ?? 60
    property int    editDelay:     cfg.hideDelaySec ?? def.hideDelaySec ?? 2

    spacing: Style.marginL

    // ── Capture Toggle ───────────────────────────────────
    NToggle {
        Layout.fillWidth: true
        label: "Capture Enabled"
        description: "Start or stop keyboard event capture"
        checked: root.editCapture
        onToggled: checked => root.editCapture = checked
    }

    // ── IPC Information ──────────────────────────────────
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: infoCol.implicitHeight + Style.marginM * 2
        color: Color.mSurfaceVariant
        radius: Style.radiusM

        ColumnLayout {
            id: infoCol
            anchors {
                fill: parent
                margins: Style.marginM
            }
            spacing: Style.marginS

            RowLayout {
                spacing: Style.marginS

                NIcon {
                    icon: "info-circle"
                    pointSize: Style.fontSizeS
                    color: Color.mPrimary
                }

                NText {
                    text: "IPC Commands"
                    pointSize: Style.fontSizeS
                    font.weight: Font.Medium
                    color: Color.mOnSurface
                }
            }

            NText {
                Layout.fillWidth: true
                text: "Toggle Capture: qs -c noctalia-shell ipc call plugin:show-keys toggle"
                pointSize: Style.fontSizeXS
                font.family: Settings.data.ui.fontFixed
                color: Color.mOnSurfaceVariant
                wrapMode: Text.WrapAnywhere
            }
        }
    }

    NDivider {
        Layout.fillWidth: true
        Layout.topMargin: Style.marginS
        Layout.bottomMargin: Style.marginS
    }



    // ── Device Path Input  ──────────────────
    NTextInput {
        Layout.fillWidth: true
        label: "Device Path (IMPORTANT)"
        description: "Your keyboard device event path, RESTART noctalia-shell to apply changes."
        placeholderText: "/dev/input/event3"
        text: root.editDevice
        onTextChanged: root.editDevice = text
    }

    // ── Setup Guide  ───────────────────────
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: guideCol.implicitHeight + Style.marginM * 2
        color: Color.mSurfaceVariant
        radius: Style.radiusM

        ColumnLayout {
            id: guideCol
            anchors {
                fill: parent
                margins: Style.marginM
            }
            spacing: Style.marginS

            RowLayout {
                spacing: Style.marginS

                NIcon {
                    icon: "terminal"
                    pointSize: Style.fontSizeS
                    color: Color.mPrimary
                }

                NText {
                    text: "Setup Guide"
                    pointSize: Style.fontSizeS
                    font.weight: Font.Medium
                    color: Color.mOnSurface
                }
            }

            NText {
                Layout.fillWidth: true
                text: "• FIRST-TIME users: RUN 'sudo evtest' (requirement) to find your device path.\n• ADD your user to the 'input' group (RUN 'sudo usermod -aG input $USER'), then REBOOT (only required once)."
                pointSize: Style.fontSizeXS
                font.family: Settings.data.ui.fontFixed
                color: Color.mOnSurfaceVariant
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.2
            }
        }
    }

    // ── Position ─────────────────────────────────────────
    ColumnLayout {
        Layout.fillWidth: true
        spacing: Style.marginS

        NLabel {
            label: "OSD Position"
            description: "Where the key overlay appears on screen"
        }

        NComboBox {
            Layout.fillWidth: true
            model: [
                { key: "bottom", name: "Bottom" },
                { key: "top",    name: "Top" }
            ]
            currentKey: root.editPosition
            onSelected: key => root.editPosition = key
        }
    }

    // ── Margin ───────────────────────────────────────────
    ColumnLayout {
        Layout.fillWidth: true
        spacing: Style.marginS

        NLabel {
            label: "Edge Margin"
            description: "Distance from screen edge: " + root.editMargin + " px"
        }

        NSlider {
            Layout.fillWidth: true
            from: 20
            to: 300
            stepSize: 10
            value: root.editMargin
            onValueChanged: root.editMargin = value
        }
    }

    // ── Auto-hide Delay ──────────────────────────────────
    ColumnLayout {
        Layout.fillWidth: true
        spacing: Style.marginS

        NLabel {
            label: "Auto-hide Delay"
            description: "Seconds before OSD fades out: " + root.editDelay + " s"
        }

        NSlider {
            Layout.fillWidth: true
            from: 1
            to: 10
            stepSize: 1
            value: root.editDelay
            onValueChanged: root.editDelay = value
        }
    }

    NDivider {
        Layout.fillWidth: true
        Layout.topMargin: Style.marginS
        Layout.bottomMargin: Style.marginS
    }

    // ── Colors ───────────────────────────────────────────
    ColumnLayout {
        Layout.fillWidth: true
        spacing: Style.marginS

        NLabel {
            label: "Pill Text Color"
            description: "Color of the key label text"
        }

        NColorPicker {
            Layout.preferredWidth: Style.sliderWidth
            Layout.preferredHeight: Style.baseWidgetSize
            selectedColor: root.editPillColor
            onColorSelected: function(color) { root.editPillColor = color }
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Style.marginS

        NLabel {
            label: "Pill Background Color"
            description: "Background color of each key pill"
        }

        NColorPicker {
            Layout.preferredWidth: Style.sliderWidth
            Layout.preferredHeight: Style.baseWidgetSize
            selectedColor: root.editPillBg
            onColorSelected: function(color) { root.editPillBg = color }
        }
    }

    NDivider {
        Layout.fillWidth: true
        Layout.topMargin: Style.marginS
        Layout.bottomMargin: Style.marginS
    }

    // ── Preview ──────────────────────────────────────────
    NLabel {
        label: "Preview"
    }

    Row {
        Layout.alignment: Qt.AlignHCenter
        spacing: 6

        Repeater {
            model: ["󰴈 +a", "CTRL+c", "H", "e", "l", "l", "o"]

            Rectangle {
                width: previewText.implicitWidth + 20
                height: 36
                radius: 8
                color: Qt.alpha(root.editPillBg, 0.8)
                border.color: Qt.alpha(root.editPillColor, 0.27)
                border.width: 1

                Text {
                    id: previewText
                    anchors.centerIn: parent
                    text: modelData
                    color: root.editPillColor
                    font.pixelSize: 16
                    font.family: "monospace"
                    font.bold: true
                }
            }
        }
    }

    // ── Save ─────────────────────────────────────────────
    function saveSettings() {
        if (!pluginApi) return;

        pluginApi.pluginSettings.captureEnabled = root.editCapture;
        pluginApi.pluginSettings.evtestDevice   = root.editDevice;
        pluginApi.pluginSettings.pillColor      = root.editPillColor.toString();
        pluginApi.pluginSettings.pillBg         = root.editPillBg.toString();
        pluginApi.pluginSettings.position       = root.editPosition;
        pluginApi.pluginSettings.marginPx       = root.editMargin;
        pluginApi.pluginSettings.hideDelaySec   = root.editDelay;

        pluginApi.saveSettings();
    }
}
