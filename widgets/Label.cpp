#include "Label.h"

#include "XMLUtils.h"

#include "UIProxy.h"

#include <QLabel>

Label::Label()
    : Widget("label")
{
}

Label::~Label()
{
}

void Label::parse(std::map<int, Widget*>& widgets, tinyxml2::XMLElement *e)
{
    Widget::parse(widgets, e);

    text = xmlutils::getAttrStr(e, "text", "");

    wordWrap = xmlutils::getAttrBool(e, "wordwrap", false);
}

QWidget * Label::createQtWidget(Proxy *proxy, UIProxy *uiproxy, QWidget *parent)
{
    QLabel *label = new QLabel(QString::fromStdString(text), parent);
    label->setWordWrap(wordWrap);
    setQWidget(label);
    setProxy(proxy);
    return label;
}

