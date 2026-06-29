---
name: video-subtitle-natural-cuts
description: Add burned-in subtitles to a user-provided video from a script, transcript, or automatically transcribed audio, preserving the spoken language without translation, with caption timing aligned to speech, Instagram-safe placement about 30% above the bottom edge, and short caption cuts of about 2 to 3 words chosen as a native speaker would naturally read them. Use when Codex needs to subtitle short videos, create social-video captions, transcribe video audio when no script is provided, keep speech-to-text subtitles in the original language, split long script lines into short word-level or phrase-sized captions, preserve the original audio, and export a new MP4 rather than overwriting prior outputs.
---
# Video Subtitle Natural Cuts
## Goal
Create a new subtitled MP4 from a source video and either a user-provided script/transcript or the video's automatically transcribed audio. Burn captions into the video, keep the original audio, preserve the spoken language without translation, place captions safely for Instagram-style uploads, and choose short caption units of about 2 to 3 words that feel natural to a native speaker of that language.
## Workflow
1. Inspect the video with `ffprobe` to confirm duration, orientation, resolution, audio stream, and codec details.
2. If the user did not provide a script or transcript, transcribe the video audio with `scripts/transcribe_audio.py` and use the generated caption segments as the starting point.
3. Detect speech/silence with `ffmpeg -af silencedetect` when timing is not already supplied or when the transcript needs timing refinement. Use the first non-silent point as the earliest caption start so opening captions do not appear before the speaker begins.
4. Segment the script or transcript into short caption units in the original language. Target 2 to 3 words per caption, allow 1-word captions for natural emphasis or pauses, and avoid captions longer than 3 words unless a fixed expression would become awkward.
5. Create an ASS subtitle file. Use `PlayResX` and `PlayResY` matching the rendered orientation, readable white bold text with a black outline, and a bottom margin of about 30% of the video height for Instagram-safe placement.
6. Encode a new MP4 with subtitles burned in. Preserve the original audio stream content by mapping the primary audio stream and encoding to AAC for compatibility.
7. Extract representative frames around important caption boundaries and visually verify no caption appears too early, too large, clipped, too low for Instagram UI, or awkwardly split.
8. Return only the new MP4 path from the outputs directory, and mention the key verification points.

## Automatic Transcription
Use `scripts/transcribe_audio.py` when the user does not provide a script or asks to generate subtitles from the video audio.

Never translate automatic speech-to-text output unless the user explicitly asks for translation. Captions must stay in the spoken language: English speech stays English, Japanese speech stays Japanese, and mixed-language speech stays mixed. When correcting obvious transcription errors, keep the correction in the same language as the speech.

The script uses the local `openai-whisper` Python package. The user has pre-approved installing this dependency for this skill, so do not ask for separate confirmation before running the install command. If the execution sandbox requires elevated permissions because the command needs network access or package-cache writes, request escalation with a concise justification and proceed.
```bash
python3 -m pip install -U openai-whisper
```

Run transcription like:
```bash
python3 scripts/transcribe_audio.py input.mp4 work/transcript_segments.json --model small --language en
```

The output is a JSON array compatible with `scripts/create_ass_subtitles.py`:
```json
[
  {"start":"0:00:01.50","end":"0:00:02.24","text":"hello world"}
]
```

Prefer `--model small` for a balance of speed and accuracy on short social videos. Use `base` or `tiny` when speed matters more than accuracy, and `medium` only when the local machine can handle the extra runtime. If the spoken language is unknown, omit `--language` and let Whisper detect it. Treat `--language` only as a spoken-language hint, not as a target translation language.

After transcription, still review and adjust the generated segments. Whisper word grouping is useful but usually too long for burned-in captions. Run `scripts/split_caption_segments.py` as a first pass when transcript segments exceed 3 words, then manually refine the split points to match speech rhythm. During review, do not localize, summarize, or translate the text unless the user explicitly requests that behavior.
## Natural Caption Splitting
Default to micro-captions for social video:
- Target 2 to 3 words per caption.
- Allow 1-word captions for discourse markers, emphasis, short verbs, conjunctions, or clear audio pauses.
- Avoid captions longer than 3 words unless a proper noun, time expression, idiom, or fixed expression would become unnatural.
- Preserve the spoken language and original wording. Do not translate, localize, or summarize.
- Split by native reading rhythm and speech cadence, not only by grammar.
- Keep fixed expressions intact when splitting would feel distracting, such as `5:13 a.m.`, `June 29`, `Let's GO`, or a short product/name phrase.
- Prefer one visual line per caption. Use `\N` only when the user explicitly wants two-line captions.

Example:
```text
The biggest change is that I now use LLMs to produce entire PRs in areas I’m familiar with.
```
Natural micro-caption cuts:
```text
The biggest change
is
that
I now use
LLMs
to produce
entire PRs
in areas
I’m familiar with.
```

Use the example as a style target: not every caption must be exactly 2 or 3 words, but the final MP4 should feel like fast, readable spoken captions rather than sentence subtitles.
For non-English scripts or transcripts, apply the same principle in that language: split by native reading rhythm and speech pauses, while preserving the original wording and language.
## Segment Splitting Helper
Use `scripts/split_caption_segments.py` to convert long transcript segments into shorter caption segments before creating ASS subtitles:
```bash
python3 scripts/split_caption_segments.py transcript_segments.json short_segments.json --max-words 3
```

The helper distributes the original segment duration across the shorter chunks in proportion to word count. Treat it as a first pass: review the JSON afterward and adjust boundaries for actual speech pauses, emphasis, fixed expressions, and the user's preferred style.
## Caption Position
Default to Instagram-safe caption placement: set the ASS bottom margin to about 30% of the rendered video height. For a 1080x1920 vertical video, use `MarginV: 576`. Increase or decrease this only when the visual content requires it or the user asks for a different placement.
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
The script defaults to a bottom margin of 30% of `--height`. Override with `--margin-v` only when needed. Use `\N` inside `text` only when a deliberate two-line caption is needed.
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
- At the longest caption, to confirm text is not clipped, does not dominate the image, and sits around 30% above the bottom edge.
