#!/usr/bin/env python3
import argparse
import json
from pathlib import Path
def parse_args():
    parser = argparse.ArgumentParser(description='Create an ASS subtitle file from caption segments.')
    parser.add_argument('segments_json', type=Path)
    parser.add_argument('output_ass', type=Path)
    parser.add_argument('--width', type=int, required=True)
    parser.add_argument('--height', type=int, required=True)
    parser.add_argument('--font-size', type=int, default=64)
    parser.add_argument('--margin-v', type=int)
    return parser.parse_args()
def escape_ass_text(text):
    return str(text).replace('\n', r'\N')
def build_ass(segments, width, height, font_size, margin_v):
    style = f'Style: Default,Arial,{font_size},&H00FFFFFF,&H00FFFFFF,&H00000000,&H99000000,-1,0,0,0,100,100,0,0,1,5,1,2,80,80,{margin_v},1'
    events = [f'Dialogue: 0,{item["start"]},{item["end"]},Default,,0,0,0,,{escape_ass_text(item["text"])}' for item in segments]
    return '\n'.join([
        '[Script Info]',
        'Title: Natural subtitle cuts',
        'ScriptType: v4.00+',
        f'PlayResX: {width}',
        f'PlayResY: {height}',
        'WrapStyle: 2',
        'ScaledBorderAndShadow: yes',
        'YCbCr Matrix: TV.709',
        '',
        '[V4+ Styles]',
        'Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, Bold, Italic, Underline, StrikeOut, ScaleX, ScaleY, Spacing, Angle, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, Encoding',
        style,
        '',
        '[Events]',
        'Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text',
        *events,
        ''
    ])
def main():
    args = parse_args()
    segments = json.loads(args.segments_json.read_text())
    margin_v = args.margin_v if args.margin_v is not None else round(args.height * 0.30)
    args.output_ass.write_text(build_ass(segments, args.width, args.height, args.font_size, margin_v))
if __name__ == '__main__':
    main()
