import QtQuick
import QtQuick.Controls
import Minesweeper
import QtQuick.Layouts
import difficultySelect

Window {
    visible: true
    minimumHeight: mode.windowHeight
    maximumHeight: mode.windowHeight
    minimumWidth: mode.windowWidth
    maximumWidth: mode.windowWidth
    width: mode.windowWidth
    height: mode.windowHeight 
    title: "Minesweeper"

    property bool mineExploded: false
    property int flagsPlaced: 0
    property int numRows: mode.rows
    property int numColumns: mode.columns
    property int numMines: mode.numBombs
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
            mineExploded = false;
            flagsPlaced = 0;
            firstClick = true; // Reset game state
            for (var i = 0; i < grid.model; i++) { // Reset the game board
                var cell = grid.itemAtIndex(i);
                cell.reset();
            }
                bombPositions = []

            gameOverOverlay.visible = false;
            winOverlay.visible = false;
        }
    function setDifficulty(difficulty) {
           switch (difficulty) {
                case "Easy":
                    resetGame();
                    mode.setEasy();
                    break;
                case "Normal":
                    resetGame();
                    mode.setNormal();
                    break;
                case "Hard":
                    resetGame();
                    mode.setHard();
                    break;
            }
        }

    DifficultySelect {
        id: mode
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
        width: mode.windowWidth
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
            bottom: fieldFrame.top
        }
        Rectangle {
            id: diffWrapper
            height: 65
            width: mode.windowWidth / 4
            color: "#9fac8f"
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
            }
            // Difficulty selection button
            Rectangle {
                id: diffSelect
                width: 125
                height: 65
                color: "#9fac8f"
                anchors.left: parent.left
                ComboBox {
                    id: diffSelectBox
                    width: 100
                    height: 44
                    anchors.centerIn: parent
                    model: ["Easy", "Normal", "Hard"]
                    padding: 10
                    onActivated: {
                        var selectedDifficulty = diffSelectBox.currentText;
                        setDifficulty(selectedDifficulty);
                    }
                }
            }
        }
        Rectangle {
            id: resetWrapper
            height: 65
            width: mode.windowWidth / 4
            color: "#9fac8f"
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: diffWrapper.right
            }
            Column {
                anchors.centerIn: parent
                spacing: 1
                // if/else pretty much: If game over state = sad otherwise smile
                Image {
                    source: mineExploded ? "icons/sad-face.png" : "icons/smiley-face.png"
                    width: 24
                    height: 24
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: 1
                }

                Text {
                    text: "Reset";
                    color: "red"
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: resetGame()
            }
        }
        Rectangle {
            id: flagsWrapper
            height: 65
            width: mode.windowWidth / 4
            color: "#9fac8f"
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: resetWrapper.right
            }
            Row {
                spacing: 10
                anchors.centerIn: parent
                Image {
                    source: "icons/flag-icon.png"
                    width: 35
                    height: 35
                }
                Text {
                    width: 35
                    height: 35
                    text:": " + (numMines - flagsPlaced) + ""
                    verticalAlignment: Text.AlignVCenter
                    color: "white"
                }
            }
        }

        Rectangle {
            id: timerWrapper
            height: 65
            width: mode.windowWidth / 4
            color: "#9fac8f"
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: flagsWrapper.right
            }
            // Timer to show how long the game lasts !Look into Timer!
            Rectangle {
                id: timer
                width: 100
                height: 44
                color: "darkslategrey"
                border.width: 4
                border.color: "black"
                Text {
                    text: {
                        var minutes = Math.floor(gameTime.secondsElapsed / 60);
                        var seconds = gameTime.secondsElapsed % 60;
                        var Seconds = seconds < 10 ? "0" + seconds : seconds;
                        return gameTime.running ? minutes + ":" + Seconds : "0:00";
                    }
                    font.pointSize: 22
                    color: "#ad9f8e"

                    anchors.centerIn: parent
                }
                anchors {
                    right: parent.right
                    rightMargin: 12.5
                    top: parent.top
                    topMargin: 10
                }
            }
        }
        }


    // The minesweeper feild


    Rectangle {
        id: fieldFrame
        height: mode.fieldHeight
        width: mode.fieldWidth
        anchors {
            top: topbar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        // A grid that holds all the cells in an array. Indices are 0-99
        GridView {
            id: grid
            interactive: false
            width: parent.width
            height: parent.height
            model: numRows * numColumns
            cellWidth: mode.cellWidth
            cellHeight: mode.cellHeight
            // Create a Minesweepercell item for each cell
            delegate: Minesweepercell {
                id: cell
                // Give each cell a unique x value corrosponding to its index in the grid
                Component.onCompleted: {
                    cell.setX(index)
                }
                // Create a rectangle within each Minesweepercell to give it visual properties
                Rectangle {
                    id: cellRect
                    width: grid.cellWidth
                    height: grid.cellHeight
                    color: mouseHover.hovered && !cell.isRevealed ? "#526935" : cell.isRevealed ? "#926c4d" : "#637f40"
                    border.color: "black"
                    border.width: 0.5
                    // If a cell is a bomb it has a Bombicon
                    Image {
                        id: bombIcon
                        anchors.centerIn: parent
                        visible: cell.isRevealed && cell.isBomb
                        source: "icons/bomb-icon.png"
                        width: parent.width * 0.6
                        height: parent.height * 0.6
                    }
                    // If a cell is flagged it has an Flagicon
                    Image {
                        id: flagIcon
                        anchors.centerIn: parent
                        visible: cell.isFlagged
                        source: "icons/flag-icon.png"
                        width: parent.width * 0.6
                        height: parent.height * 0.6
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
                                if (randomIndex !== initialCellIndex && !grid.itemAtIndex(randomIndex).isBomb && isValidIndex(randomIndex)) {
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
                                // flag removal function before first click
                                for (let h = 0; h < numRows * numColumns; h++) {
                                            let cell = grid.itemAtIndex(h);
                                            if (cell.isFlagged) {
                                                cell.setFlagged(false);
                                                flagsPlaced--;
                                            }
                                        }
                                // Places the mines
                                placeMines(cell.cellX);

                                // Upon the first click we ittereate through each cell and calculate the number of proximal bombs
                                for (let i = 0; i < numRows* numColumns; i++) {
                                    grid.itemAtIndex(i).setNeighboringBombs(countMinesAroundCell(grid.itemAtIndex(i).cellX))
                                }

                                // Lastly, opens the clicked cell
                                cell.setRevealed(true);
                                checkWin();

                                openSafeArea(cell.cellX);
                            }
                            else {
                                if (cell.isBomb && !cell.isFlagged) {
                                    mineExploded = true;
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
                            if (!cell.isRevealed) {
                                if (!cell.isFlagged && flagsPlaced < numMines) {
                                    cell.setFlagged(true);
                                    flagsPlaced++;
                                } else if (cell.isFlagged) {
                                    cell.setFlagged(false);
                                    flagsPlaced--;
                                }
                                checkWin();
                            }
                        }
                    }
                }
            }
        }
        Rectangle {
            id: winOverlay
            visible: false
            color: "#80000000"
            anchors.fill: parent

            AnimatedImage {
                id: winIcon
                anchors.centerIn: parent
                source: "icons/3aO.gif"
                width: parent.width * 0.6
                height: parent.height * 0.6
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
    Component.onCompleted: {
        console.log(mode.numBombs)
        console.log(mode.rows)
        console.log(mode.columns)
    }
}
