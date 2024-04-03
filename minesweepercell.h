#ifndef MINESWEEPERCELL_H
#define MINESWEEPERCELL_H

#include <QQuickItem>

class minesweepercell : public QQuickItem
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(bool isBomb READ isBomb NOTIFY isBombChanged)
    Q_PROPERTY(bool isRevealed READ isRevealed NOTIFY isRevealedChanged)
    Q_PROPERTY(bool isFlagged READ isFlagged WRITE setFlagged NOTIFY isFlaggedChanged)
    Q_PROPERTY(int neighboringBombs READ neighboringBombs NOTIFY neighboringBombsChanged)
    Q_PROPERTY(int cellX READ cellX NOTIFY isXChanged)
    Q_PROPERTY(int placement READ placement NOTIFY isPlacementChanged)

public:
    minesweepercell();

    bool isBomb() const;
    bool isRevealed() const;
    bool isFlagged() const;
    int neighboringBombs() const;
    int cellX() const;
    int placement() const;

public slots:
    void setBomb(bool bomb);
    void setRevealed(bool revealed);
    void setFlagged(bool flagged);
    void setNeighboringBombs(int count);
    void setX(int index);
    void setPlacement(int zone);
    void reset();

signals:
    void isBombChanged();
    void isRevealedChanged();
    void isFlaggedChanged();
    void neighboringBombsChanged();
    void isXChanged();
    void isPlacementChanged();
    void gameOver();
private:
    bool m_isBomb;
    bool m_isRevealed;
    bool m_isFlagged;
    int m_neighboringBombs;
    int m_x;
    int m_placement;
};

#endif // MINESWEEPERCELL_H
