#!/usr/bin/python

def find_line(lines, key):
    for line in lines:
        if key in line:
            return line

    return None

def parse_val(line):
    idx = line.index(':') + 1
    line = line[idx:]
    line = ''.join(line.split(' '))
    line = line[:-2]
    return int(line)

def kB_to_GB(val):
    return val / 1000 / 1000

def main():
    with open('/proc/meminfo', 'r') as file:
        c = file.read()

    lines = c.split('\n')
    memtotal = find_line(lines, 'MemTotal')
    memavb = find_line(lines, 'MemAvailable')

    memtotal_val = parse_val(memtotal)
    memavb_val = parse_val(memavb)

    memtotal_val = kB_to_GB(memtotal_val)
    memavb_val = kB_to_GB(memavb_val)
    memused_val = memtotal_val - memavb_val

    print(f'{memused_val:3.2f} / {memtotal_val:3.2f}')

if __name__ == '__main__':
    main()

