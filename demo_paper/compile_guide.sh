#!/bin/bash
# compile_guide.sh

set -e
cd "$(dirname "$0")"

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
    grep -i "error" paper_reading_guide.log | tail -10
    exit 1
fi
