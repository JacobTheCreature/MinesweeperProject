import QtQuick
import QtQuick.Controls
import Minesweeper
import QtQuick.Layouts


Window {
    visible: true
    width: 500
    height: 565
    title: "Counter App"
    minimumHeight: 565
    maximumHeight: 565
    minimumWidth: 500
    maximumWidth: 500


    property int numRows: 10
    property int numColumns: 10
    property bool firstClick: true

    property var cellPositions: []
    property var bombPositions: []

    function resetGame() {
            gameTime.secondsElapsed = 0;
            gameTime.running = false;
            firstClick = true; // Reset game state
            for (var i = 0; i < grid.model; i++) { // Reset the game board
                var cell = grid.itemAtIndex(i);
                cell.reset();
            }
        }

    //timer function
    Timer {
            id: gameTime
            interval: 1000 // updates every second
            repeat: true
            property int secondsElapsed: 0 // tracker

            onTriggered: {
                secondsElapsed += 1; // increase timer
            }
        }

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
            MouseArea {
               anchors.fill: parent
               onClicked: resetGame() // Call resetGame when the reset button is clicked
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
                text: {
                    var minutes = Math.floor(gameTime.secondsElapsed / 60);
                    var seconds = gameTime.secondsElapsed % 60;
                    var Seconds = seconds < 10 ? "0" + seconds : seconds;
                    return gameTime.running ? "Time: " + minutes + ":" + Seconds : "Time: 0:00";
                }
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
                // Give each cell a unique x value corrosponding to its index in the grid and assignit a position value
                Component.onCompleted: {
                    cell.setX(index)

                    if (cell.cellX == 0) {cell.setPlacement(0); // top left
                    } else if (cell.cellX > 0 && cell.cellX < numRows - 1) {
                        cell.setPlacement(1); // top row
                    } else if (cell.cellX == numColumns - 1) {
                        cell.setPlacement(2); // top right
                    } else if (cell.cellX % numRows == 0 && cell.cellX != numRows * numColumns - numRows) {
                        cell.setPlacement(3); // left side
                    } else if ((cell.cellX + 1) % numRows == 0 && cell.cellX != numRows*numColumns-1) {
                        cell.setPlacement(5); // right side
                    } else if (cell.cellX == numRows * numColumns - numRows) {
                        cell.setPlacement(6); // bottom left
                    } else if (cell.cellX > numRows * numRows - numRows && cell.cellX < numRows * numColumns - 1) {
                        cell.setPlacement(7); // bottom row
                    } else if (cell.cellX == numRows * numColumns - 1) {
                        cell.setPlacement(8); // bottom right
                    } else {
                        cell.setPlacement(4); // center
                    }
                }
                // Create a rectangle within each Minesweepercell to give it visual properties
                Rectangle {
                    width: grid.cellWidth
                    height: grid.cellHeight
                    color: mouseHover.hovered && !cell.isRevealed ? "darkslategrey" : cell.isRevealed ? "lightgrey" : "grey"
                    border.color: "black"
                    // If a cell is a bomb it has a B
                    Text {
                        anchors.centerIn: parent
                        // visible: cell.isRevealed   // Just to force the bomb to remain hidden
                        text: cell.isBomb ? "B" : ""
                    }
                    // If a cell is flagged it has an F
                    Text {
                        anchors.centerIn: parent
                        text: cell.isFlagged ? "F" : ""
                    }
                    HoverHandler {
                        id: mouseHover
                        acceptedDevices: PointerDevice.Mouse
                    }

                    // Clickable area. This area is responible for revealing cells
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (firstClick) {
                                firstClick = false;
                                gameTime.secondsElapsed = 0;
                                gameTime.restart();
                                gameTime.running = true;
                                cell.setRevealed(true);
                                for (var i = 0; i < 10; i++) {
                                    var randomIndex = Math.floor(Math.random()*100)
                                    while (randomIndex == cell.cellX || grid.itemAtIndex(randomIndex).isBomb) {
                                        randomIndex = Math.floor(Math.random()*100)
                                    }
                                    var randomCell = grid.itemAtIndex(randomIndex)
                                    randomCell.setBomb(true)
                                }
                            }
                            else {
                                if (!cell.isRevealed || cell.isFlagged) {
                                cell.setRevealed(true);
                                    console.log(cell.placement)
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
