#include "Tabs.h"

#include "UIProxy.h"

#include <QWidget>
#include <QTabWidget>

Tab::Tab()
    : Widget()
{
}

Tab::~Tab()
{
}

bool Tab::parse(tinyxml2::XMLElement *e, std::vector<std::string>& errors)
{
    if(!Widget::parse(e, errors)) return false;

    std::string tag(e->Value());
    if(tag != "tab")
    {
        errors.push_back("element must be <tab>");
        return false;
    }

    if(e->Attribute("title")) title = e->Attribute("title");
    else title = "???";

    return LayoutWidget::parse(e, errors);
}

QWidget * Tab::createQtWidget(Proxy *proxy, UIProxy *uiproxy, QWidget *parent)
{
    QWidget *tab = new QWidget(parent);
    LayoutWidget::createQtWidget(proxy, uiproxy, tab);
    qwidget = tab;
    Widget::widgetByQWidget[qwidget] = this;
    this->proxy = proxy;
    return tab;
}

Tabs::Tabs()
    : Widget()
{
}

Tabs::~Tabs()
{
    for(std::vector<Tab*>::const_iterator it = tabs.begin(); it != tabs.end(); ++it)
    {
        delete *it;
    }
}

bool Tabs::parse(tinyxml2::XMLElement *e, std::vector<std::string>& errors)
{
    if(!Widget::parse(e, errors)) return false;

    std::string tag(e->Value());
    if(tag != "tabs")
    {
        errors.push_back("element must be <tabs>");
        return false;
    }

    for(tinyxml2::XMLElement *e1 = e->FirstChildElement(); e1; e1 = e1->NextSiblingElement())
    {
        Tab *tab = new Tab();
        tabs.push_back(tab);

        if(!tab->parse(e1, errors))
            return false;
    }

    return true;
}

QWidget * Tabs::createQtWidget(Proxy *proxy, UIProxy *uiproxy, QWidget *parent)
{
    QTabWidget *tabwidget = new QTabWidget(parent);
    for(std::vector<Tab*>::const_iterator it = tabs.begin(); it != tabs.end(); ++it)
    {
        QWidget *tab = (*it)->createQtWidget(proxy, uiproxy, tabwidget);
        tabwidget->addTab(tab, QString::fromStdString((*it)->title));
    }
    qwidget = tabwidget;
    Widget::widgetByQWidget[qwidget] = this;
    this->proxy = proxy;
    return tabwidget;
}
