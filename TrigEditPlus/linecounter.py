import os


def endsWith(s, tail):
    return s[-len(tail):] == tail


def getLineNum(targetDir):
    totlinen = 0
    for root, dirs, files in os.walk(targetDir):
        for f in files:
            if endsWith(f, '.cpp') or endsWith(f, '.h') or endsWith(f, '.hpp'):
                finalpath = os.path.join(root, f)
                code = open(finalpath, 'rb').read()
                linen = code.count(b'\n') + 1
                print("%-40s : %4d" % (finalpath, linen))
                totlinen += linen

    return totlinen


totlinen = getLineNum('.')
totlinen -= getLineNum('Editor\\Scintilla')
totlinen -= getLineNum('Editor\\Lua\\lib')

print('Total lines: %d' % totlinen)
