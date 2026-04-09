# Academic Paper Chinese Reading Guide Generator

> Transform arXiv papers into structured, insightful Chinese reading guide PDFs

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**🌐 Language**: [中文](README.md) | **English**

---

## 📖 About This Project

This project provides a complete workflow using AI agents to automatically transform arXiv papers into **structured, insightful Chinese reading guide PDFs**. With LaTeX typesetting, it generates reading guides containing key insights, method analysis, and experimental breakdowns.

### My Use Case

- When **skimming**, I prefer reading the English Abstract & Intro, then jumping straight to figures to get the gist. 
- But when **reading deeply**, reading everything in Chinese feels fragmented, while reading everything in English often causes me to "lose context" and forget where I am. 
- So I need a **Chinese guide** to help me build structure and memory anchors.

### Core File
- `zh_guide.md` (Chinese workflow guide)

---

## 📋 Requirements

### Essential

- **LaTeX Compilation Environment** (TeX Live 2026 or higher)
- **Chinese Fonts** - STSong, STHeiti (built-in on macOS) or Noto Sans CJK SC (Linux)
- **AI Agent** - Recommended: `OpenCode` (has higher automatic permissions, runs continuously without constant permission requests). The base model requirement is not high - I typically use qwen3.5-plus, glm, etc.

### Optional

- **Python 3.12+** - for extended features
- **uv** - Python package management

---

## 🔄 Iterative Development

### Philosophy

- Both `zh_guide.md` and `other_pipelines/large_tex_translate_pipeline.md` were iteratively developed with AI assistance.
- We encourage optimizing and iterating the workflow with AI assistance, but hope for **human review** and **subjective testing** with demo PDF outputs.

### Core Principle

- There's just **one core Markdown file** guiding the workflow. This is merely a starting point - a simple sharing of our approach.
- We hope interested individuals will **optimize the workflow themselves**, modify corresponding processes, test results empirically, and share their findings.

### Experimental Versions

- [Full translation of multi-page surveys, guiding subagents usage](other_pipelines/large_tex_translate_pipeline.md)

---
