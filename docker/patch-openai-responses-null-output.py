#!/usr/bin/env python3
from pathlib import Path

target = Path("/opt/hermes/venv/lib/python3.11/site-packages/openai/lib/_parsing/_responses.py")

text = target.read_text(encoding="utf-8")
old = "    for output in response.output:\n"
new = "    for output in (response.output or []):\n"

if new in text:
    print(f"OpenAI Responses parser already patched: {target}")
elif old in text:
    target.write_text(text.replace(old, new, 1), encoding="utf-8")
    print(f"Patched OpenAI Responses parser null output guard: {target}")
else:
    raise SystemExit(f"Could not find expected parser loop in {target}")
