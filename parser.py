import argparse 

def parseLine(line):
    words = line.split(' ')
    for word in words:
        if '%' in word:
            res = float(word[1:len(word)-1])
            print('res is', res)
            if res > 90:
                print('OK')
            else:
                print('not ok :(')


def main(fileName):
    res = -1 
    with open(fileName, "r") as f:
        lines = f.readlines()
        for line in lines:
            if 'mapped' in line:
                res = parseLine(line)
                return res 
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('filepath', help='path to report')
    args = parser.parse_args()
    fileName = args.filepath
    main(fileName)
