---
name: video-subtitle-natural-cuts
description: Add burned-in subtitles to a user-provided video from a script or transcript, with caption timing aligned to speech and line breaks chosen as a native English speaker would naturally read them. Use when Codex needs to subtitle short videos, create social-video captions, split long script lines into natural phrase-sized captions, preserve the original audio, and export a new MP4 rather than overwriting prior outputs.
---
# Video Subtitle Natural Cuts
## Goal
Create a new subtitled MP4 from a source video and a user-provided script. Burn captions into the video, keep the original audio, and choose caption units that feel natural to a native English speaker.
## Workflow
1. Inspect the video with `ffprobe` to confirm duration, orientation, resolution, audio stream, and codec details.
2. Detect speech/silence with `ffmpeg -af silencedetect` when timing is not already supplied. Use the first non-silent point as the earliest caption start so opening captions do not appear before the speaker begins.
3. Segment the script into natural caption units. Prefer short clauses and meaning groups over full sentences when a sentence is long.
4. Create an ASS subtitle file. Use `PlayResX` and `PlayResY` matching the rendered orientation, and set readable white bold text with a black outline.
5. Encode a new MP4 with subtitles burned in. Preserve the original audio stream content by mapping the primary audio stream and encoding to AAC for compatibility.
6. Extract representative frames around important caption boundaries and visually verify no caption appears too early, too large, clipped, or awkwardly split.
7. Return only the new MP4 path from the outputs directory, and mention the key verification points.
## Natural Caption Splitting
Prefer these splitting rules for English scripts:
- Keep short independent lines intact, such as `hello world`, `it's 5:00 a.m.`, and `Let's GO`.
- Split date or context lines by meaning: `This is Sunday` then `June 28`.
- Split long identity or routine lines by phrase: `This is DAY 1` then `of my morning routine`.
- Avoid splitting inside fixed expressions, times, names, dates, or idioms unless the line would otherwise be too long.
- Favor 1 to 2 lines per caption, with each line short enough to scan quickly on a phone screen.
- If a sentence has a natural pause in the audio, align the split to that pause even when the text could fit as one caption.
## Timing Guidance
Use detected silence as a guide, not an absolute source of truth. If the user says a caption appears too early, move the start to the first audible speech frame. If the user asks for shorter cuts, split at natural phrase boundaries and keep each caption on screen long enough to read.
## ASS Subtitle Generation
Use `scripts/create_ass_subtitles.py` when you have explicit caption segments. Create a JSON file like:
```json
[
  {"start":"0:00:01.22","end":"0:00:02.00","text":"hello world"},
  {"start":"0:00:03.05","end":"0:00:04.20","text":"This is Sunday"}
]
```
Then run:
```bash
python3 scripts/create_ass_subtitles.py segments.json subtitles.ass --width 1080 --height 1920
```
Use `\N` inside `text` only when a deliberate two-line caption is needed.
## Encoding Pattern
Use an output filename that does not overwrite a previous result unless the user explicitly asks for overwrite:
```bash
ffmpeg -y -i input.mov -vf "subtitles=work/subtitles.ass:fontsdir=/System/Library/Fonts" -map 0:v:0 -map 0:a:0 -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p -c:a aac -b:a 192k -movflags +faststart outputs/new_subtitled_video.mp4
```
If the source has rotation metadata, confirm the rendered output orientation with `ffprobe` and representative screenshots.
## Verification
Always verify at least these frames:
- Before the first caption start, to confirm no early caption appears.
- Shortly after the first caption start, to confirm the opening caption appears when speech begins.
- At each user-requested split point, to confirm the expected caption unit appears.
- At the longest caption, to confirm text is not clipped and does not dominate the image.
