#ifndef TREE_H_INCLUDED
#define TREE_H_INCLUDED

#include <vector>
#include <map>
#include <string>

#include <QWidget>
#include <QAbstractItemView>

#include "tinyxml2.h"

class Proxy;
class UIProxy;

#include "Widget.h"
#include "Event.h"

class QTreeWidgetItem;

struct TreeItem
{
    int id;
    int parent_id;
    std::vector<std::string> text;
};

class Tree : public Widget
{
protected:
    bool show_header;
    bool autosize_header;
    bool sortable;
    std::vector<std::string> header;
    std::map<int, TreeItem> items;
    std::string onSelectionChange;

private:
    void populateItems(const std::map<int, std::vector<int> > &by_parent, int parent_id, QTreeWidgetItem *parent);
    QTreeWidgetItem* makeItem(const TreeItem &item);
    std::map<int, QTreeWidgetItem*> widgetItemById;
    QTreeWidgetItem * getWidgetItemById(int id);

public:
    Tree();
    virtual ~Tree();

    void parse(Widget *parent, std::map<int, Widget*>& widgets, tinyxml2::XMLElement *e);
    QWidget * createQtWidget(Proxy *proxy, UIProxy *uiproxy, QWidget *parent);
    void clear();
    void setColumnCount(int count);
    void addItem(int id, int parent, std::vector<std::string> text);
    int getColumnCount();
    void removeItem(int id);
    void setColumnHeaderText(int column, std::string text);
    std::string saveState();
    bool restoreState(std::string state);
    void setColumnWidth(int column, int min_size, int max_size);

    friend class UIFunctions;
    friend class UIProxy;
};

#endif // TREE_H_INCLUDED
