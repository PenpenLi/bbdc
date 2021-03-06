#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import json
import os, os.path, errno
import sys
import zipfile
import shutil

def export(jsonFile, codeFile):
    f = open(jsonFile)
    s = f.read()
    jsonStr = json.loads(s)
    texts = jsonStr['text']
    k = 0
    outStr = ''.encode('utf8')

    for text in texts:
        key = text['key']
        # outStr += '#define ' + key.upper() + ' ' + str(k) + '    //' + text['cn'].encode('gbk') + '\n'
        # outStr += 'TEXT_ID_' + key.upper() + ' = ' + str(k + 1) + '\n' #+ '// ' + str(json.dumps(text['cn'])) + '\n'
        # print(text['cn'].encode("utf-8"))
        outStr += 'TEXT__'.encode('utf8') + key.upper().encode('utf8') + ' = "'.encode('utf8') + text['cn'].encode("utf-8") + '"\n'.encode('utf8')
        k = k + 1

    out = open(codeFile, 'w')
    out.write(outStr)
    out.close()
    print('text: ' + codeFile)
    pass
                
if __name__ == "__main__":
    export(sys.argv[1], sys.argv[2])

