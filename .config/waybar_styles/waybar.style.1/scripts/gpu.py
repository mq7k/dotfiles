#!/usr/bin/python3.13

def read_amd_card_info():
    path = '/sys/class/drm/card1/device/gpu_busy_percent'
    with open(path, 'r') as file:
        c = file.read()

    # print(f'{c}% \udb82\udcae'.encode('utf-8', errors='surrogatepass'))
    print(f'{c}')

def main():
    read_amd_card_info()

if __name__ == '__main__':
    main()

