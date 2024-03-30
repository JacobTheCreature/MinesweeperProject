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
                id: minesweeperCell
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (!minesweeperCell.isRevealed && !minesweeperCell.isFlagged && !minesweeperCell.isBomb) {
                            minesweeperCell.setRevealed(true)
                        }
                        if (firstClick) {
                            firstClick = false

                            var theCell = grid.itemAt(5,5)
                            theCell.setBomb(true)

                        }
                    }
                }
                MouseArea {
                    acceptedButtons: Qt.RightButton
                    anchors.fill: parent
                    onClicked: {
                        if (minesweeperCell.isFlagged === true)
                        {
                            minesweeperCell.setFlagged(false)
                        }else{
                            minesweeperCell.setFlagged(true)
                        }
                    }
                }
                Rectangle {
                    width: grid.cellWidth
                    height: grid.cellHeight
                    color: minesweeperCell.isRevealed ? "lightgrey" : "grey"
                    border.color: "black"
                    Text {
                        anchors.centerIn: parent
                        text: minesweeperCell.isBomb ? "B" : ""
                    }
                    Text {
                        anchors.centerIn: parent
                        text: minesweeperCell.isFlagged ? "F" : ""
                    }
                }
            }
        }

    }
}

