import QtQuick 2.15
import SddmComponents 2.0

Clock {
  id: time
  color: config.text
  timeFont.family: config.Font
  dateFont.family: config.Font
  anchors {
    topMargin: 20
    top: parent.top
    horizontalCenter: parent.horizontalCenter
  }
}
