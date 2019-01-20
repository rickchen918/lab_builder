# filename: test1.py
import argparse 
def process_command():
    parser = argparse.ArgumentParser()
    parser.add_argument('--foo', help='foo help')
    parser.add_argument('--text', '-t', type=str, required=True, help='Text for program')
    return parser.parse_args()
if __name__ == '__main__':
    args = process_command()
    print(args.text)
