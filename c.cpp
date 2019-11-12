#include "stubs.h"
#include "simPlusPlus/Plugin.h"

SIM_DLLEXPORT int customUi_msgBox(int type, int buttons, const char *title, const char *message)
{
    msgBox_in in;
    in.type = type;
    in.buttons = buttons;
    in.title = title;
    in.message = message;

    msgBox_out out;

    msgBox(nullptr, "", &in, &out);

    return out.result;
}

SIM_DLLEXPORT char * customUi_fileDialog(int type, const char *title, const char *startPath, const char *initName, const char *extName, const char *ext, int native)
{
    fileDialog_in in;
    in.type = type;
    in.title = title;
    in.startPath = startPath;
    in.initName = initName;
    in.extName = extName;
    in.ext = ext;
    in.native = !!native;

    fileDialog_out out;

    fileDialog(nullptr, "", &in, &out);

    if(out.result.empty()) return nullptr;

    int sz = 0;
    for(auto &x : out.result) sz += x.length() + 1;
    simChar *ret = simCreateBuffer(sz), *tmp = ret;
    for(auto &x : out.result)
    {
        strcpy(tmp, x.c_str());
        tmp += x.length();
        *tmp = ';';
        tmp++;
    }
    tmp--;
    *tmp = '\0';
    return ret;
}

