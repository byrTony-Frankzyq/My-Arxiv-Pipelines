# 学术论文中文导读生成工作流

> **目标**：将 arXiv 论文转化为结构化、有洞察力的中文导读 PDF  
> **输入**：arXiv 论文链接或 ID  
> **输出**：中文导读 PDF（LaTeX 格式，包含关键洞察）

---

## 一、环境验证

```bash
# 验证 TeX 环境
xelatex --version

# 验证 Python 环境, 一般用不到，加在这里只是为了确保隔离，让agent自由使用
./.venv/bin/python --version

# 如果没有Python 环境又想使用，可以使用uv创建
uv venv --python 3.12
source .venv/bin/activate


# 验证下载脚本
ls download_arxiv.sh
```

---

## 二、标准工作流

### Step 1: 下载论文源码

```bash
# 使用下载脚本
cd /path/to/paper_sharing/
./download_arxiv.sh <arxiv_url_or_id>

# 支持的输入格式：
# - https://arxiv.org/abs/2603.25681
# - https://arxiv.org/pdf/2603.25681
# - 2603.25681

# 下载完成后重命名目录
mv 2603.25681 Paper_Short_Name/
cd Paper_Short_Name/
```

**脚本自动完成**：
1. 提取 arXiv ID
2. 下载源码压缩包
3. 解压到独立目录
4. 识别主 tex 文件
5. 提取论文标题

### Step 2: 结构分析与术语提取

```bash
# 2.1 确认关键文件
ls -la *.tex figures/  # 或 fig/, images/

# 2.2 识别章节结构
grep -r "\\\\input{" *.tex | sed 's/.*input{//;s/}//'
find . -name "*.tex" -type f | sort

# 2.3 查看章节标题
grep -n "^\\\\section{" chapters/*.tex
```

**关键检查点**：
- [ ] 主 tex 文件已识别（main.tex / arxiv.tex / tmlr.tex 等）
- [ ] 图片目录已定位（figures / fig / images / imgs 等）
- [ ] 参考文献文件存在（.bbl 或 .bib）
- [ ] 章节组织方式明确（单文件 vs 多文件 \input{}）

### Step 3: 生成中文导读 LaTeX

#### 3.1 创建导读主文件

```latex
% paper_reading_guide.tex
\documentclass[12pt,a4paper]{article}

% 中文支持
\usepackage{xeCJK}
\setCJKmainfont{STSong}
\setCJKsansfont{STHeiti}

% 页面设置
\usepackage{geometry}
\geometry{left=1in,right=1in,top=1in,bottom=1in}

% 必要宏包
\usepackage{graphicx}
\usepackage{hyperref}
\usepackage{booktabs}
\usepackage{amsmath}
\usepackage{float}
\usepackage{caption}
\usepackage{tcolorbox}

% 论文信息
\title{\huge 论文标题\\[0.5em] \large 副标题}
\author{原作者信息\\导读整理：AI Assistant}
\date{arXiv:xxxx.xxxxx}

\begin{document}
\maketitle
\tableofcontents
\newpage

% 各章节内容
\section{论文总览}
...
\section{核心方法}
...
\section{关键洞察}
...

\end{document}
```

#### 3.2 导读内容框架

```markdown
## 必含内容

1. 论文总览
   - 研究背景与动机
   - 核心定义
   - 主要贡献

2. 方法解析
   - 核心框架图（含图片）
   - 关键技术路径
   - 方法对比表格

3. 实验分析
   - 实验设计
   - 关键结果
   - 消融实验

4. 洞察与建议
   - 核心洞察（用 tcolorbox 高亮）
   - 实践建议
   - 局限与未来方向

5. 总结
   - 核心贡献
   - 关键引用
```

#### 3.3 翻译规范

**必须翻译**：
- `\section{}`, `\subsection{}` 标题
- 所有普通文本段落
- `\caption{}` 图表标题
- `\textbf{}`, `\textit{}` 内容

**保持不翻译**：
- `\cite{key}` 引用键
- `\ref{label}` 交叉引用
- `\label{label}` 标签
- 数学公式和环境
- 文件名、路径、URL

### Step 4: 编译与质量检查

#### 4.1 编译脚本

```bash
#!/bin/bash
# compile_guide.sh

set -e
cd "$(dirname "$0")")

echo "📄 清理旧文件..."
rm -f *.aux *.log *.out *.toc

echo "🔨 第一次编译..."
xelatex -interaction=nonstopmode paper_reading_guide.tex

echo "🔨 第二次编译（生成目录）..."
xelatex -interaction=nonstopmode paper_reading_guide.tex

if [ -f "paper_reading_guide.pdf" ]; then
    echo "✅ 编译成功!"
    ls -lh paper_reading_guide.pdf
else
    echo "❌ 编译失败"
    exit 1
fi
```

#### 4.2 增量编译验证

```bash
# 每完成 2-3 个章节后测试编译
chmod +x compile_guide.sh
./compile_guide.sh

# 检查错误
grep -i "error" paper_reading_guide.log | tail -10
```

#### 4.3 质量检查清单

**编译前**：
- [ ] 所有章节文件存在
- [ ] 图片路径正确
- [ ] 中文字体配置正确

**编译后**：
- [ ] PDF 成功生成
- [ ] 目录正常显示
- [ ] 图片正常显示
- [ ] 表格格式正确
- [ ] 中文无乱码

### Step 5: 归档与维护

```bash
# 目录结构
Paper_Short_Name/
├── chapters/                 # 原论文章节
├── figures/                  # 图片（PDF格式，LaTeX直接支持）
├── paper_reading_guide.tex   # 导读源码
├── paper_reading_guide.pdf   # 导读PDF ⭐
├── compile_guide.sh          # 编译脚本
└── TITLE.txt                 # 论文标题
```

---

## 三、模板文件

### 3.1 LaTeX 主文件模板

```latex
\documentclass[12pt,a4paper]{article}

% ===== 中文支持 =====
\usepackage{xeCJK}
\setCJKmainfont{STSong}
\setCJKsansfont{STHeiti}
\setCJKmonofont{STFangsong}

% ===== 页面设置 =====
\usepackage{geometry}
\geometry{left=1in,right=1in,top=1in,bottom=1in}

% ===== 必要宏包 =====
\usepackage{graphicx}
\usepackage{hyperref}
\usepackage{booktabs}
\usepackage{amsmath}
\usepackage{float}
\usepackage{caption}
\usepackage{tcolorbox}

% ===== 超链接样式 =====
\hypersetup{
    colorlinks=true,
    linkcolor=blue,
    citecolor=blue,
    urlcolor=blue
}

% ===== 自定义命令 =====
\newcommand{\keypoint}[1]{\textbf{核心观点：}#1}
\newcommand{\insight}[1]{\textbf{洞察：}#1}
\newcommand{\suggestion}[1]{\textbf{建议：}#1}

% ===== 论文信息 =====
\title{\huge 论文标题\\[0.5em] \large 英文副标题}
\author{原作者\\[0.2cm]\small 导读整理：AI Assistant}
\date{arXiv:xxxx.xxxxx}

\begin{document}
\maketitle
\begin{abstract}
摘要内容...
\end{abstract}
\tableofcontents
\newpage

% ===== 正文 =====
\section{论文总览}
\subsection{研究背景}
\subsection{核心定义}
\subsection{主要贡献}

\section{核心方法}
% 框架图（LaTeX 直接支持 PDF 图片）
\begin{figure}[h]
    \centering
    \includegraphics[width=0.9\textwidth]{figures/framework.pdf}
    \caption{方法框架图}
\end{figure}

\section{实验分析}
% 表格示例
\begin{table}[h]
\centering
\caption{方法对比}
\begin{tabular}{lcc}
\toprule
方法 & 指标1 & 指标2 \\
\midrule
Baseline & xx.x & xx.x \\
Ours & \textbf{yy.y} & \textbf{yy.y} \\
\bottomrule
\end{tabular}
\end{table}

\section{关键洞察}
\begin{tcolorbox}[colback=blue!5,colframe=blue!50,title=核心洞察]
\begin{enumerate}
    \item 洞察1
    \item 洞察2
\end{enumerate}
\end{tcolorbox}

\section{总结}
\suggestion{实践建议...}

\end{document}
```

### 3.2 编译脚本模板

```bash
#!/bin/bash
# compile_guide.sh

set -e
cd "$(dirname "$0")"

# 清理
rm -f *.aux *.log *.out *.toc

# 编译两次（生成目录）
xelatex -interaction=nonstopmode paper_reading_guide.tex
xelatex -interaction=nonstopmode paper_reading_guide.tex

# 验证
if [ -f "paper_reading_guide.pdf" ]; then
    echo "✅ 成功: paper_reading_guide.pdf"
    ls -lh paper_reading_guide.pdf
else
    echo "❌ 编译失败"
    grep -i "error" paper_reading_guide.log | tail -10
    exit 1
fi
```

---

## 四、常见问题 FAQ

### Q1: 中文字体找不到？

```latex
% macOS 备选方案
\setCJKmainfont{PingFang SC}  % 或 STSong
\setCJKsansfont{STHeiti}

% Linux 需安装
sudo apt-get install fonts-noto-cjk
\setCJKmainfont{Noto Sans CJK SC}
```

### Q2: 编译报错 "Undefined control sequence"？

原因：缺少宏包。在导言区添加：
```latex
\usepackage{booktabs}   % 三线表
\usepackage{longtable}  % 跨页表格
\usepackage{tcolorbox}  % 彩色框
```

### Q3: 图片不显示？

```bash
# 检查路径和文件名
ls -la figures/*.pdf

# LaTeX 直接支持 PDF 图片
\includegraphics{figures/name.pdf}  # 推荐
```

### Q4: 如何引用原文公式？

```latex
% 保持 LaTeX 格式，不翻译
原论文给出损失函数：
$$L = -\sum_{i} y_i \log(\hat{y}_i)$$
```

### Q5: 编译太慢？

```bash
# 使用 draft 模式快速预览
\documentclass[draft]{article}

# 或只编译前几章
% \input{section_later}  % 注释后续章节
```

---

## 五、术语翻译对照表

### 通用术语

| 英文 | 中文 | 备注 |
|------|------|------|
| Large Language Model (LLM) | 大语言模型 | |
| In-Context Learning (ICL) | 上下文学习 | |
| Fine-tuning | 微调 | |
| Pre-training | 预训练 | |
| Reinforcement Learning | 强化学习 | |
| Self-Supervised Learning | 自监督学习 | |
| Transfer Learning | 迁移学习 | |

### 方法相关

| 英文 | 中文 | 备注 |
|------|------|------|
| Self-Improvement | 自我改进 | |
| Self-Evolution | 自我进化 | |
| Data Augmentation | 数据增强 | |
| Reward Model | 奖励模型 | |
| Preference Learning | 偏好学习 | |
| Alignment | 对齐 | |

### 评估相关

| 英文 | 中文 | 备注 |
|------|------|------|
| Benchmark | 基准测试 | |
| Evaluation | 评估/评测 | |
| Metric | 指标 | |
| Ablation Study | 消融实验 | |
| Baseline | 基线 | |
| State-of-the-Art (SOTA) | 最先进 | 可保留英文 |

---

## 六、参考资源

- [LaTeX 中文支持指南](https://ctan.org/pkg/xecjk)
- [arXiv API 文档](https://arxiv.org/help/api/)
- [XeLaTeX 编译器](https://www.tug.org/xetex/)

---

*最后更新：2026-03-31*  
*版本：v3.0（合并 paper_understanding.md 和 large_tex_translate_pipeline_v2.md）*
