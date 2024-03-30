import QtQuick
import QtQuick.Controls
import Minesweeper
import QtQuick.Layouts

Window {
    visible: true
    width: 1200
    height: 600
    title: "Counter App"

    property int numRows: 10
    property int numColumns: 10
    property bool firstClick: true

    property var cellPositions: []
    property var bombPositions: []

    Rectangle {
        height: 250
        width: 250
        anchors.centerIn: parent
        GridView {
            id: grid
            interactive: false
            width: parent.width
            height: parent.height
            model: numRows * numColumns
            cellWidth: 25
            cellHeight: 25
            delegate: Minesweepercell {
                id: cell
                Rectangle {
                    width: grid.cellWidth
                    height: grid.cellHeight
                    color: cell.isRevealed ? "lightgrey" : "grey"
                    border.color: "black"
                    Text {
                        anchors.centerIn: parent
                        text: cell.isBomb ? "B" : ""
                    }
                    Text {
                        anchors.centerIn: parent
                        text: cell.isFlagged ? "F" : ""
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if(!cell.isRevealed && !cell.isFlagged && !cell.isBomb) {
                                cell.setRevealed((true))
                            }
                        }
                    }
                    MouseArea {
                        acceptedButtons: Qt.RightButton
                        anchors.fill: parent
                        onClicked: {
                            if (cell.isFlagged === true) {
                                cell.setFlagged(false)
                            } else {
                                cell.setFlagged(true)
                            }
                        }
                    }
                }
            }
        }
    }
}

