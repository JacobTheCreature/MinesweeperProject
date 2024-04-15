#include "difficultyselect.h"

difficultySelect::difficultySelect() :
    m_windowWidth(500),
    m_windowHeight(565),
    m_fieldWidth(500),
    m_fieldHeight(500),
    m_cellWidth(50),
    m_cellHeight(50),
    m_numBombs(10),
    m_columns(10),
    m_rows(10)
{}

void difficultySelect::setEasy() {
    m_windowWidth = 500;
    m_windowHeight = 565;
    m_fieldWidth = 500;
    m_fieldHeight = 500;
    m_cellWidth = 50;
    m_cellHeight = 50;
    m_numBombs = 10;
    m_columns = 10;
    m_rows = 10;
    emit isWindowHeightChanged();
    emit isWidnowWidthChanged();
    emit isFieldWidthChanged();
    emit isFieldHeightChanged();
    emit isCellWidthChanged();
    emit isCellHeightChanged();
    emit isNumBombsChanged();
    emit isColumnsChanged();
    emit isRowsChanged();
}

void difficultySelect::setNormal() {
    m_windowWidth = 480;
    m_windowHeight = 545;
    m_fieldWidth = 480;
    m_fieldHeight = 480;
    m_cellWidth = 30;
    m_cellHeight = 30;
    m_numBombs = 40;
    m_columns = 16;
    m_rows = 16;
    emit isWindowHeightChanged();
    emit isWidnowWidthChanged();
    emit isFieldWidthChanged();
    emit isFieldHeightChanged();
    emit isCellWidthChanged();
    emit isCellHeightChanged();
    emit isNumBombsChanged();
    emit isColumnsChanged();
    emit isRowsChanged();
}

void difficultySelect::setHard() {
    m_windowWidth = 750;
    m_windowHeight = 465;
    m_fieldWidth = 750;
    m_fieldHeight = 750;
    m_cellWidth = 25;
    m_cellHeight = 25;
    m_numBombs = 99;
    m_columns = 30;
    m_rows = 16;
    emit isWindowHeightChanged();
    emit isWidnowWidthChanged();
    emit isFieldWidthChanged();
    emit isFieldHeightChanged();
    emit isCellWidthChanged();
    emit isCellHeightChanged();
    emit isNumBombsChanged();
    emit isColumnsChanged();
    emit isRowsChanged();
}

int difficultySelect::windowWidth() const {
    return m_windowWidth;
}

int difficultySelect::widnowHeight() const {
    return m_windowHeight;
}

int difficultySelect::fieldWidth() const {
    return m_fieldWidth;
}

int difficultySelect::fieldHeight() const {
    return m_fieldHeight;
}

int difficultySelect::cellWidth() const {
    return m_cellWidth;
}

int difficultySelect::cellHeight() const {
    return m_cellHeight;
}

int difficultySelect::numBombs() const {
    return m_numBombs;
}

int difficultySelect::columns() const {
    return m_columns;
}

int difficultySelect::rows() const {
    return m_rows;
}



