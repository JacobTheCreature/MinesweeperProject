#include "minesweepercell.h"

minesweepercell::minesweepercell() {}


int minesweepercell::x() const
{
    return m_x;
}

bool minesweepercell::isBomb() const
{
    return m_isBomb;
}

bool minesweepercell::isRevealed() const
{
    return m_isRevealed;
}

bool minesweepercell::isFlagged() const
{
    return m_isFlagged;
}

int minesweepercell::neighboringBombs() const
{
    return m_neighboringBombs;
}

void minesweepercell::setX(int index)
{
    m_x = index;
    emit isXChanged();
}


void minesweepercell::setBomb(bool bomb)
{
    if (m_isBomb != bomb) {
        m_isBomb = bomb;
        emit isBombChanged();
    }
}

void minesweepercell::setRevealed(bool revealed)
{
    if (m_isRevealed != revealed) {
        m_isRevealed = revealed;
        emit isRevealedChanged();
    }
}

void minesweepercell::setFlagged(bool flagged)
{
    if (m_isFlagged != flagged) {
        m_isFlagged = flagged;
        emit isFlaggedChanged();
    }
}

void minesweepercell::setNeighboringBombs(int count)
{
    if (m_neighboringBombs != count) {
        m_neighboringBombs = count;
        emit neighboringBombsChanged();
    }
}
