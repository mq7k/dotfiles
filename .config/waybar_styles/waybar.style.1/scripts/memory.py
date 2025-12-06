#!/usr/bin/python3.13

import os
import sys

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
    return val / 1024 / 1024

def show_minimal():
    with open('/proc/meminfo', 'r') as file:
        c = file.read()

    lines = c.split('\n')
    memtotal = find_line(lines, 'MemTotal')
    memfree = find_line(lines, 'MemFree')
    memcached = find_line(lines, 'Cached')
    membuffers = find_line(lines, 'Buffers')
    memk = find_line(lines, 'KReclaimable')

    memtotal_val = parse_val(memtotal)
    memfree = parse_val(memfree)
    memcached = parse_val(memcached)
    membuffers = parse_val(membuffers)
    memk = parse_val(memk)

    memused_val = memtotal_val - memfree - memcached - membuffers - memk
    memused_val = kB_to_GB(memused_val)

    print(f'{memused_val:3.2f} GB')

def show_extended():
    with open('/proc/meminfo', 'r') as file:
        c = file.read()

    lines = c.split('\n')
    memtotal = find_line(lines, 'MemTotal')
    memfree = find_line(lines, 'MemFree')
    memcached = find_line(lines, 'Cached')
    membuffers = find_line(lines, 'Buffers')
    memk = find_line(lines, 'KReclaimable')

    memtotal_val = parse_val(memtotal)
    memfree = parse_val(memfree)
    memcached = parse_val(memcached)
    membuffers = parse_val(membuffers)
    memk = parse_val(memk)

    memused_val = memtotal_val - memfree - memcached - membuffers - memk
    memused_val = kB_to_GB(memused_val)
    memtotal_val = kB_to_GB(memtotal_val)

    print(f'{memused_val:3.2f} / {memtotal_val:3.2f} GB')

def change_mode():
    if os.path.exists('.memextended'):
        os.unlink('.memextended')
        return

    open('.memextended', 'w').close()

def main():
    if len(sys.argv) > 1 and sys.argv[1].lower() == 'changemode':
        change_mode()
        return

    if os.path.exists('.memextended'):
        show_extended()
        return

    show_minimal()

if __name__ == '__main__':
    main()

