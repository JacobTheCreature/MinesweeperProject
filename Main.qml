import QtQuick
import QtQuick.Controls
import Minesweeper
import QtQuick.Layouts


Window {
    visible: true
    width: 500
    height: 565
    title: "Counter App"

    property int numRows: 10
    property int numColumns: 10
    property bool firstClick: true

    property var cellPositions: []
    property var bombPositions: []

    // Top navigation bar
    Rectangle {
        id: topbar
        height: 65
        width: 500
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
            bottom: fieldFrame.top
        }
        // Difficulty selection button !Look into ComboButton!
        Rectangle {
            id: diffSelect
            width: 125
            height: 65
            color: "Yellow"
            Text {
                text: "Difficulty Select"
                anchors.fill: parent
            }
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
            }
        }
        // Reset button to reset field !Need to make a reset method for Minesweepercell class!
        Rectangle {
            id: reset
            width: 125
            height: 65
            color: "Grey"
            Text {
                text: "Reset"
                anchors.fill: parent
            }
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: diffSelect.right
            }
        }
        // Shows how many flags you have left !Look into making a flag class that acts as a counter maybe!
        Rectangle {
            id: flags
            width: 125
            height: 65
            color: "Tan"
            Text {
                text: "flags"
                anchors.fill: parent
            }
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: reset.right
            }
        }
        // Timer to show how long the game lasts !Look into Timer!
        Rectangle {
            id: timer
            width: 125
            height: 65
            color: "Cyan"
            Text {
                text: "Timer"
                anchors.fill: parent
            }
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: flags.right
            }
        }
    }


    // The minesweeper feild


    Rectangle {
        id: fieldFrame
        height: 500
        width: 500
        anchors {
            top: topbar.bottom
            left: parent.left
            right:parent.right
            bottom: parent.bottom
        }
        // A grid that holds all the cells in an array. Indices are 0-99
        GridView {
            id: grid
            interactive: false
            width: parent.width
            height: parent.height
            model: numRows * numColumns
            cellWidth: 50
            cellHeight: 50
            // Create a Minesweepercell item for each cell
            delegate: Minesweepercell {
                id: cell
                // Give each cell a unique x value corrosponding to its index in the grid
                Component.onCompleted: {
                    cell.setX(index)
                }
                // Create a rectangle within each Minesweepercell to give it visual properties
                Rectangle {
                    width: grid.cellWidth
                    height: grid.cellHeight
                    color: cell.isRevealed ? "lightgrey" : "grey"
                    border.color: "black"
                    // If a cell is a bomb it has a B
                    Text {
                        anchors.centerIn: parent
                        text: cell.isBomb ? "B" : ""
                    }
                    // If a cell is flagged it has an F
                    Text {
                        anchors.centerIn: parent
                        text: cell.isFlagged ? "F" : ""
                    }
                    // Clickable area. This area is responible for revealing cells
                    MouseArea {
                        anchors.fill: parent
                        // If a cell is unrevealed, not flagged, and not a bomb, it will reveal it
                        onClicked: {
                            if(!cell.isRevealed && !cell.isFlagged && !cell.isBomb) {
                                cell.setRevealed((true))


                                // !TODO upon the first reveal bombs cannot spawn in or around the cell!
                                // Currently this onnly makes it so bombs wont spawn in the selected cell

                                // Upon the first reveal it generates bombs
                                if (firstClick) {
                                    firstClick = false
                                    for (var i = 0; i < 10; i++) {
                                        var randomIndex = Math.floor(Math.random()*100)
                                        while (randomIndex == cell.cellX) {
                                            randomIndex = Math.floor(Math.random()*100)
                                        }
                                        var randomCell = grid.itemAtIndex(randomIndex)
                                        randomCell.setBomb(true)
                                    }
                                }
                            }
                            // There needs to be special nehboring bomb counting for edge and corner cells. This is for only the top left cell
                            if (cell.cellX == 0) {
                                if (grid.itemAtIndex(cell.cellX+1).isBomb) {
                                    cell.setNeighboringBombs()
                                }
                                if (grid.itemAtIndex(cell.cellX+10).isBomb) {
                                    cell.setNeighboringBombs()
                                }
                                if (grid.itemAtIndex(cell.cellX+11).isBomb) {
                                    cell.setNeighboringBombs()
                                }
                            }
                        }
                    }
                    // Clickable area that only accepts right clicks. Flags cells
                    MouseArea {
                        acceptedButtons: Qt.RightButton
                        anchors.fill: parent
                        onClicked: {
                            if ((cell.isFlagged == false) && !cell.isRevealed ) {
                                cell.setFlagged(true)
                            } else {
                                cell.setFlagged(false)
                            }
                        }
                    }
                }
            }
        }
    }
}


