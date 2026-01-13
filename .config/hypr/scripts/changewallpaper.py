#!/bin/python

import os
import random
import sys
import time
import argparse

def update_wallpaper(directory):
    wallpapers = os.listdir(directory)
    the_chosen_one = random.choice(wallpapers)
    icon_path = "~/dotresources/arch-linux.png"
    abs_path = f"{directory}/{the_chosen_one}"
    filename_no_ext = the_chosen_one[:the_chosen_one.rfind('.')]

    code = os.system(f"hyprctl hyprpaper wallpaper ', {abs_path}, cover'")
    if code != 0:
        return code

    return os.system(f"notify-send -n {icon_path} -t 3000 'Wallpaper: \'{filename_no_ext}\''")

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--dir', required=True)
    parser.add_argument('--defer', type=int, default=0)
    args = parser.parse_args()

    if args.defer > 0:
        pid = os.fork()
        if pid == 0:
            # The child process.
            time.sleep(args.defer)
            return update_wallpaper(args.dir)
        else:
            # The parent process.
            return 0

    update_wallpaper(args.dir)

if __name__ == '__main__':
    code = main()
    sys.exit(code)
