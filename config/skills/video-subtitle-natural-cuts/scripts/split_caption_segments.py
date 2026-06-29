#!/usr/bin/env python3
import argparse
import json
from pathlib import Path
def parse_args():
    parser = argparse.ArgumentParser(description='Split caption segments into shorter word-count chunks.')
    parser.add_argument('input_json', type=Path)
    parser.add_argument('output_json', type=Path)
    parser.add_argument('--max-words', type=int, default=3)
    return parser.parse_args()
def parse_timestamp(value):
    hours_text, minutes_text, seconds_text = str(value).split(':')
    return (int(hours_text) * 3600) + (int(minutes_text) * 60) + float(seconds_text)
def format_timestamp(seconds):
    total_centiseconds = round(float(seconds) * 100)
    centiseconds = total_centiseconds % 100
    total_seconds = total_centiseconds // 100
    seconds_part = total_seconds % 60
    total_minutes = total_seconds // 60
    minutes_part = total_minutes % 60
    hours_part = total_minutes // 60
    return f'{hours_part}:{minutes_part:02}:{seconds_part:02}.{centiseconds:02}'
def split_words(words, max_words):
    return [words[index:index + max_words] for index in range(0, len(words), max_words)]
def split_segment(segment, max_words):
    words = str(segment['text']).split()
    if len(words) <= max_words:
        return [segment]
    chunks = split_words(words, max_words)
    start = parse_timestamp(segment['start'])
    end = parse_timestamp(segment['end'])
    duration = max(end - start, 0.01)
    total_words = sum(len(chunk) for chunk in chunks)
    offsets = [sum(len(chunk) for chunk in chunks[:index]) / total_words for index in range(len(chunks) + 1)]
    return [
        {
            'start': format_timestamp(start + (duration * offsets[index])),
            'end': format_timestamp(start + (duration * offsets[index + 1])),
            'text': ' '.join(chunk),
        }
        for index, chunk in enumerate(chunks)
    ]
def main():
    args = parse_args()
    segments = json.loads(args.input_json.read_text())
    short_segments = [
        short_segment
        for segment in segments
        for short_segment in split_segment(segment, args.max_words)
    ]
    args.output_json.write_text(json.dumps(short_segments, ensure_ascii=False, indent=2) + '\n')
if __name__ == '__main__':
    main()
