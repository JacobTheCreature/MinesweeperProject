#ifndef DIFFICULTYSELECT_H
#define DIFFICULTYSELECT_H

#include <QQuickItem>

class difficultySelect : public QQuickItem
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int windowWidth READ windowWidth NOTIFY isWindowHeightChanged)
    Q_PROPERTY(int windowHeight READ widnowHeight NOTIFY isWidnowWidthChanged)
    Q_PROPERTY(int fieldWidth READ fieldWidth NOTIFY isFieldWidthChanged)
    Q_PROPERTY(int fieldHeight READ fieldHeight NOTIFY isFieldHeightChanged)
    Q_PROPERTY(int cellWidth READ cellWidth NOTIFY isCellWidthChanged)
    Q_PROPERTY(int cellHeight READ cellHeight NOTIFY isCellHeightChanged)
    Q_PROPERTY(int numBombs READ numBombs NOTIFY isNumBombsChanged)
    Q_PROPERTY(int columns READ columns NOTIFY isColumnsChanged)
    Q_PROPERTY(int rows READ rows NOTIFY isRowsChanged)

public:
    difficultySelect();
    int windowWidth() const;
    int widnowHeight() const;
    int fieldWidth() const;
    int fieldHeight() const;
    int cellWidth() const;
    int cellHeight() const;
    int numBombs() const;
    int columns() const;
    int rows() const;

public slots:
    void setEasy();
    void setNormal();
    void setHard();
    void getDifficulty();

signals:
    void isDifficultyChanged();
    void isWindowHeightChanged();
    void isWidnowWidthChanged();
    void isFieldWidthChanged();
    void isFieldHeightChanged();
    void isCellWidthChanged();
    void isCellHeightChanged();
    void isNumBombsChanged();
    void isColumnsChanged();
    void isRowsChanged();

private:
    int m_windowWidth;
    int m_windowHeight;
    int m_fieldWidth;
    int m_fieldHeight;
    int m_cellWidth;
    int m_cellHeight;
    int m_numBombs;
    int m_columns;
    int m_rows;

};

#endif // DIFFICULTYSELECT_H
