import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets
import qs.Services.System

ColumnLayout {
    id: root
    property var pluginApi: null

    property int draftWidth: pluginApi?.pluginSettings?.widgetWidth ?? 215
    property int draftSpeed: pluginApi?.pluginSettings?.scrollSpeed ?? 70
    property string draftMode: pluginApi?.pluginSettings?.scrollMode ?? "always"
    property int draftFontSize: pluginApi?.pluginSettings?.fontSize ?? 10
    property bool draftHideWhenEmpty: pluginApi?.pluginSettings?.hideWhenEmpty ?? true
    property string draftFontFamily: pluginApi?.pluginSettings?.fontFamily ?? "Inter"
    property bool draftAdaptScrollSpeed: pluginApi?.pluginSettings?.adaptScrollSpeed ?? true
    property bool draftShowWhenPaused: pluginApi?.pluginSettings?.showWhenPaused ?? true

    spacing: Style.marginM

    function saveSettings() {
        if (pluginApi) {
            pluginApi.pluginSettings.widgetWidth = draftWidth;
            pluginApi.pluginSettings.scrollSpeed = draftSpeed;
            pluginApi.pluginSettings.scrollMode = draftMode;
            pluginApi.pluginSettings.adaptScrollSpeed = draftAdaptScrollSpeed;
            pluginApi.pluginSettings.showWhenPaused = draftShowWhenPaused;
            pluginApi.pluginSettings.fontSize = draftFontSize;
            pluginApi.pluginSettings.hideWhenEmpty = draftHideWhenEmpty;
            // Save the selected font
            pluginApi.pluginSettings.fontFamily = draftFontFamily;
            pluginApi.saveSettings();
        }
    }

    NSearchableComboBox {
        label: pluginApi?.tr("settings.font.title") || "Font Family"
        description: pluginApi?.tr("settings.font.desc") || "Select the font for lyrics."
        Layout.fillWidth: true

        model: FontService.availableFonts

        currentKey: draftFontFamily
        placeholder: pluginApi?.tr("settings.font.placeholder") || "Select a font..."
        searchPlaceholder: pluginApi?.tr("settings.font.search-placeholder") || "Search fonts..."
        popupHeight: 300

        onSelected: key => draftFontFamily = key
    }

    NLabel {
        label: pluginApi?.tr("settings.font.size") || "Font Size"
        description: pluginApi?.tr("settings.font.size-desc") || "Text size in points."
    }

    RowLayout {
        Layout.fillWidth: true
        NSlider {
            Layout.fillWidth: true
            from: 8
            to: 32
            value: draftFontSize
            onValueChanged: draftFontSize = value
        }
        NText {
            text: Math.round(draftFontSize) + "pt"
        }
    }

    NDivider {
        Layout.fillWidth: true
    }

    NLabel {
        label: pluginApi?.tr("settings.width") || "Widget Width"
    }
    RowLayout {
        Layout.fillWidth: true
        NSlider {
            Layout.fillWidth: true
            from: 100
            to: 500
            value: draftWidth
            onValueChanged: draftWidth = value
        }
        NText {
            text: Math.round(draftWidth) + "px"
        }
    }

    NLabel {
        label: pluginApi?.tr("settings.scroll.speed") || "Scroll Speed"
    }
    RowLayout {
        Layout.fillWidth: true
        NSlider {
            Layout.fillWidth: true
            from: 10
            to: 200
            value: draftSpeed
            onValueChanged: draftSpeed = value
        }
        NText {
            text: Math.round(draftSpeed) + " px/s"
        }
    }

    NComboBox {
        label: pluginApi?.tr("settings.scroll.mode.title") || "Scroll Mode"
        Layout.fillWidth: true
        model: [
            {
                name: pluginApi?.tr("settings.scroll.mode.always") || "Always Scroll",
                key: "always"
            },
            {
                name: pluginApi?.tr("settings.scroll.mode.hover") || "Scroll on Hover",
                key: "hover"
            },
            {
                name: pluginApi?.tr("settings.scroll.mode.never") || "Don't Scroll",
                key: "none"
            }
        ]
        currentKey: draftMode
        onSelected: key => draftMode = key
    }

    NToggle {
        label: pluginApi?.tr("settings.scroll.adapt") || "Adapt scroll speed to line"
        description: pluginApi?.tr("settings.scroll.adapt-desc") || "Change scroll speed based on length of line"
        checked: draftAdaptScrollSpeed
        onToggled: newState => {
            draftAdaptScrollSpeed = newState;
        }
    }

    NToggle {
        label: pluginApi?.tr("settings.hide-when-empty") || "Hide when empty"
        checked: draftHideWhenEmpty
        onToggled: newState => {
            draftHideWhenEmpty = newState;
        }
    }

    NToggle {
        label: pluginApi?.tr("show-when-paused") || "Show display when paused"
        checked: draftShowWhenPaused
        onToggled: newState => {
            draftShowWhenPaused = newState;
        }
    }
}
