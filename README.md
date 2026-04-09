# 学术论文中文导读生成器

> 将 arXiv 论文转化为结构化、有洞察力的中文导读 PDF

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**🌐 语言**: **中文** | [English](README_en.md)

---

## 📖 项目简介

本项目提供一套完整的工作流，利用Agent自动将 arXiv 论文转化为**结构化、有洞察力的中文导读 PDF**。通过 LaTeX 排版，生成包含关键洞察、方法解析和实验分析的导读文档。


### 我的使用场景
- 粗读的时候，我更喜欢看英文的Abstract&Intro，然后直奔图表，看个大概。但细读的时候，全看中文会比较割裂，全看英文，会经常“丢失上下文”，忘记自己读到哪里了，所以需要一个中文的导引来帮助我建立结构和记忆的节点。

### 核心文件
- `zh_guide.md`
---

## 📋 环境要求

### 必需

- **LaTeX编译环境** 
- **中文字体**
- **Agent** - 推荐`OpenCode`, 其自动的权限比较高，基本能一直跑而不是请求权限；对应的基模要求不高，我平时就用qwen3.5-plus、glm这些模型。

### 可选

- **Python 3.12+** - 用于扩展功能
- **uv** - Python 包管理

---
## 迭代更新

### 说明
- 这里的`zh_guide.md`和`other_pipelines/large_tex_translate_pipeline.md`都是AI和我迭代而来
- 所以并不反对在AI辅助下，进行流程的优化和迭代，但是希望能经过真人的review和效果的主观测试，有一些demo文章的输出pdf。

### 基本原则
- 核心就一个指导流程的Markdown文件，这里只是抛砖引玉，作一个简单的分享。
- 我希望感兴趣的人可以自己优化流程，修改对应的流程，实测观察效果，然后分享即可。
  

### 一些实验版本
- [完全翻译几十页的综述，引导使用subagents](other_pipelines/large_tex_translate_pipeline.md)