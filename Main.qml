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
    property int numMines: 10
    property bool firstClick: true
    property int revealedTiles: 0
    property var bombPositions: []

    function updateRevealedTiles(value) {
            revealedTiles = value;
        }
    function checkWin() {
        var revealedCount = 0;
        var correctFlagsCount = 0;
        var totalFlagsCount = 0;

        for (var i = 0; i < grid.model; ++i) {
            var cell = grid.itemAtIndex(i);

            // Count revealed non-bomb cells
            if (!cell.isBomb && cell.isRevealed) {
                revealedCount++;
            }

            // Count correctly flagged bombs
            if (cell.isBomb && cell.isFlagged) {
                correctFlagsCount++;
            }

            // Count all flags
            if (cell.isFlagged) {
                totalFlagsCount++;
            }
        }

        // Check if all non-bomb cells are revealed and all bombs are correctly flagged
        if (revealedCount === (numRows * numColumns - numMines) &&
            correctFlagsCount === numMines &&
            correctFlagsCount === totalFlagsCount) {
            console.log("Win!");
            winOverlay.visible = true;
        }
    }
    function resetGame() {
            gameTime.secondsElapsed = 0;
            gameTime.running = false;
            updateRevealedTiles(0);
            firstClick = true; // Reset game state
            for (var i = 0; i < grid.model; i++) { // Reset the game board
                var cell = grid.itemAtIndex(i);
                cell.reset();
            }
            gameOverOverlay.visible = false;
            winOverlay.visible = false;
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
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
            }
            ComboBox {
                id: diffSelectBox
                width: 100
                height: 45
                anchors.centerIn: parent

                model: ["Easy", "Normal", "Hard"] // Options for the ComboBox

                padding: 10 // Padding

                onActivated: {
                    var selectedDifficulty = model[index]; // Get the selected difficulty
                    // Handle the selected difficulty here (you can emit a signal or call a function)
                    console.log("Selected difficulty:", selectedDifficulty);
                }
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
                // Give each cell a unique x value corrosponding to its index in the grid
                Component.onCompleted: {
                    cell.setX(index)
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
                        visible: cell.isRevealed   // Just to force the bomb to remain hidden
                        text: cell.isBomb ? "B" : ""
                    }
                    // If a cell is flagged it has an F
                    Text {
                        anchors.centerIn: parent
                        text: cell.isFlagged ? "F" : ""
                    }
                    Text {
                        anchors.centerIn: parent
                        text: cell.neighboringBombs > 0  && cell.isRevealed ? String(cell.neighboringBombs) : ""
                    }

                    HoverHandler {
                        id: mouseHover
                        acceptedDevices: PointerDevice.Mouse
                    }

                    // Clickable area. This area is responible for revealing cells
                    MouseArea {
                        anchors.fill: parent

                        function isValidIndex(initialCellIndex) {
                            const row = Math.floor(index / numColumns);
                            const column = index % numColumns;
                            const initialRow = Math.floor(initialCellIndex / numColumns);
                            const initialColumn = initialCellIndex % numColumns;


                            // Check if the cell is around the initial cell
                            if (Math.abs(row - initialRow) <= 1 && Math.abs(column - initialColumn) <= 1) {
                                return false;
                            }

                            return true;
                        }
                        function placeMines(initialCellIndex) {
                            let minesPlaced = 0;
                            while (minesPlaced < numMines) {
                                const randomIndex = Math.floor(Math.random() * numRows * numColumns);
                                if (randomIndex !== initialCellIndex && !grid.itemAtIndex(randomIndex).isBomb && isValidIndex(randomIndex, initialCellIndex, numRows, numColumns)) {
                                    grid.itemAtIndex(randomIndex).setBomb(true);
                                    minesPlaced++;
                                    bombPositions.push(randomIndex)
                                }
                            }
                        }
                        function countMinesAroundCell(cellIndex) {
                            if (!grid.itemAtIndex(cellIndex).isBomb) {
                                const row = Math.floor(cellIndex / numColumns);
                                const col = cellIndex % numColumns;
                                let mineCount = 0;

                                for (let i = Math.max(0, row - 1); i <= Math.min(row + 1, numRows - 1); i++) {
                                    for (let j = Math.max(0, col - 1); j <= Math.min(col + 1, numColumns - 1); j++) {
                                        if (!(i === row && j === col) && grid.itemAtIndex(i * numColumns + j).isBomb) {
                                            mineCount++;
                                        }
                                    }
                                }
                                return mineCount;
                            }
                            else {
                                return -1;
                            }
                        }

                        function openSafeArea(cellIndex) {
                            const row = Math.floor(cellIndex / numColumns);
                            const col = cellIndex % numColumns;

                            if (cell.neighboringBombs > 0) {
                                cell.setFlagged(false);
                                cell.setRevealed(true);
                                return;
                            }

                            for (let i = Math.max(0, row - 1); i <= Math.min(row + 1, numRows - 1); i++) {
                                for (let j = Math.max(0, col - 1); j <= Math.min(col + 1, numColumns - 1); j++) {
                                    if (!(i === row && j === col) && grid.itemAtIndex(i * numColumns + j).neighboringBombs === 0 && !grid.itemAtIndex(i * numColumns + j).isRevealed && cell.neighboringBombs == 0) {
                                        grid.itemAtIndex(i * numColumns + j).setFlagged(false);
                                        grid.itemAtIndex(i * numColumns + j).setRevealed(true);
                                        openSafeArea(grid.itemAtIndex(i * numColumns + j).cellX);
                                    }
                                    if (!(i === row && j === col) && grid.itemAtIndex(i * numColumns + j).neighboringBombs > 0) {
                                        grid.itemAtIndex(i * numColumns + j).setFlagged(false);
                                        grid.itemAtIndex(i * numColumns + j).setRevealed(true);
                                    }
                                }
                            }

                        }

                        onClicked: {
                            if (firstClick && !cell.isFlagged) {
                                firstClick = false;
                                gameTime.secondsElapsed = 0;
                                gameTime.restart();
                                gameTime.running = true;

                                // Places the mines
                                placeMines(cell.cellX);

                                // Upon the first click we ittereate through each cell and calculate the number of proximal bombs
                                for (let i = 0; i < 100; i++) {
                                    grid.itemAtIndex(i).setNeighboringBombs(countMinesAroundCell(grid.itemAtIndex(i).cellX))
                                }

                                // Lastly, opens the clicked cell
                                cell.setRevealed(true);
                                checkWin();

                                openSafeArea(cell.cellX);
                            }
                            else {
                                if (cell.isBomb && !cell.isFlagged) {
                                    for (let b = 0; b < bombPositions.length; b++) {
                                        grid.itemAtIndex(bombPositions[b]).setRevealed(true);
                                    }
                                    gameOverOverlay.visible = true;
                                }
                                if (!cell.isRevealed && !cell.isFlagged && !cell.isBomb) {
                                    cell.setRevealed(true);
                                    openSafeArea(cell.cellX);
                                    checkWin();
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
                                checkWin();
                            } else {
                                cell.setFlagged(false)
                            }
                        }
                    }
                }
            }
        }
        Rectangle {
            id: winOverlay
            visible: false
            color: "Green"
            anchors.fill: parent

            Text {
                id: winText
                text: "You win!"
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 20
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    winOverlay.visible = false;
                    resetGame();
                }
            }
        }
        Rectangle {
            id: gameOverOverlay
            visible: false
            color: "#80000000"
            anchors.fill: parent

            Text {
                id: gameOverText
                text: "Game Over! Hit reset to play again"
                font.pixelSize: 24
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
            // Just prevents passthrough clicks
            MouseArea {
                anchors.fill: parent
                onClicked: {
                }
            }
            HoverHandler {
                id: gameOverHover
                acceptedDevices: PointerDevice.Mouse
            }
        }
    }
}
