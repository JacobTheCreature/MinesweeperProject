#ifndef MINESWEEPERCELL_H
#define MINESWEEPERCELL_H

#include <QQuickItem>

class minesweepercell : public QQuickItem
{
    Q_OBJECT
    QML_ELEMENT    Q_PROPERTY(bool isBomb READ isBomb NOTIFY isBombChanged)
    Q_PROPERTY(bool isRevealed READ isRevealed NOTIFY isRevealedChanged)
    Q_PROPERTY(bool isFlagged READ isFlagged WRITE setFlagged NOTIFY isFlaggedChanged)
    Q_PROPERTY(int neighboringBombs READ neighboringBombs NOTIFY neighboringBombsChanged)
    Q_PROPERTY(int x READ x NOTIFY isXChanged)

public:
    minesweepercell();

    bool isBomb() const;
    bool isRevealed() const;
    bool isFlagged() const;
    int neighboringBombs() const;
    int x() const;

public slots:
    void setBomb(bool bomb);
    void setRevealed(bool revealed);
    void setFlagged(bool flagged);
    void setNeighboringBombs(int count);
    void setX(int index);

signals:
    void isBombChanged();
    void isRevealedChanged();
    void isFlaggedChanged();
    void neighboringBombsChanged();
    void isXChanged();

private:
    bool m_isBomb;
    bool m_isRevealed;
    bool m_isFlagged;
    int m_neighboringBombs;
    int m_x;
};

#endif // MINESWEEPERCELL_H
