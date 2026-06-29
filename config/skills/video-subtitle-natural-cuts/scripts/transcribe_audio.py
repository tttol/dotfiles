#!/usr/bin/env python3
import argparse
import json
import sys
from pathlib import Path
def parse_args():
    parser = argparse.ArgumentParser(description='Transcribe video audio into caption segments with Whisper.')
    parser.add_argument('input_video', type=Path)
    parser.add_argument('output_json', type=Path)
    parser.add_argument('--model', default='small')
    parser.add_argument('--language', help='Optional spoken-language hint. This is not a translation target.')
    return parser.parse_args()
def format_timestamp(seconds):
    total_centiseconds = round(float(seconds) * 100)
    centiseconds = total_centiseconds % 100
    total_seconds = total_centiseconds // 100
    seconds_part = total_seconds % 60
    total_minutes = total_seconds // 60
    minutes_part = total_minutes % 60
    hours_part = total_minutes // 60
    return f'{hours_part}:{minutes_part:02}:{seconds_part:02}.{centiseconds:02}'
def load_whisper():
    try:
        import whisper
        return whisper
    except ModuleNotFoundError:
        print(
            'Missing dependency: openai-whisper. This skill is pre-approved to install it with `python3 -m pip install -U openai-whisper`.',
            file=sys.stderr,
        )
        raise SystemExit(2)
def main():
    args = parse_args()
    whisper = load_whisper()
    model = whisper.load_model(args.model)
    options = {'task': 'transcribe', **({'language': args.language} if args.language else {})}
    result = model.transcribe(str(args.input_video), **options)
    segments = [
        {
            'start': format_timestamp(item['start']),
            'end': format_timestamp(item['end']),
            'text': ' '.join(str(item['text']).strip().split()),
        }
        for item in result.get('segments', [])
        if str(item.get('text', '')).strip()
    ]
    args.output_json.write_text(json.dumps(segments, ensure_ascii=False, indent=2) + '\n')
if __name__ == '__main__':
    main()
