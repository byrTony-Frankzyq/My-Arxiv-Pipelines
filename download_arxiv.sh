#!/bin/bash
# 从 arxiv 链接或 ID 自动下载论文源码

set -e

# 输入可以是:
# - 完整链接: https://arxiv.org/abs/2509.12508 或 https://arxiv.org/pdf/2509.12508
# - 纯 ID: 2509.12508
# - 带版本: 2509.12508v1

INPUT="$1"

if [ -z "$INPUT" ]; then
    echo "Usage: $0 <arxiv_url_or_id>"
    echo "Examples:"
    echo "  $0 https://arxiv.org/abs/2509.12508"
    echo "  $0 https://arxiv.org/pdf/2509.12508"
    echo "  $0 2509.12508"
    exit 1
fi

# 提取 arxiv ID
echo "🔍 Extracting arxiv ID from: $INPUT"

# 从 URL 中提取 ID
if [[ "$INPUT" == *"arxiv.org"* ]]; then
    # 从链接中提取 (支持 /abs/ 或 /pdf/ 格式)
    ARXIV_ID=$(echo "$INPUT" | grep -oE '[0-9]+\.[0-9]+(v[0-9]+)?' | head -1)
else
    # 直接是 ID
    ARXIV_ID="$INPUT"
fi

if [ -z "$ARXIV_ID" ]; then
    echo "❌ Could not extract arxiv ID from: $INPUT"
    exit 1
fi

echo "📄 Arxiv ID: $ARXIV_ID"

# 检查是否已存在同名目录
if [ -d "$ARXIV_ID" ]; then
    echo "⚠️  Directory '$ARXIV_ID' already exists. Remove it first or use a different location."
    exit 1
fi

# 创建临时目录下载
TEMP_DIR=$(mktemp -d)
echo "📦 Downloading source package to temporary directory..."

DOWNLOAD_URL="https://arxiv.org/src/${ARXIV_ID}"
echo "🔗 Download URL: $DOWNLOAD_URL"

if ! curl -L -o "${TEMP_DIR}/source.tar.gz" "$DOWNLOAD_URL"; then
    echo "❌ Download failed. Please check if the arxiv ID is correct."
    rm -rf "$TEMP_DIR"
    exit 1
fi

# 验证下载的文件
if [ ! -f "${TEMP_DIR}/source.tar.gz" ] || [ ! -s "${TEMP_DIR}/source.tar.gz" ]; then
    echo "❌ Downloaded file is empty or missing"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# 解压
mkdir -p "$ARXIV_ID"
echo "📂 Extracting to: $ARXIV_ID/"
tar -xzf "${TEMP_DIR}/source.tar.gz" -C "$ARXIV_ID/"

# 清理临时文件
rm -rf "$TEMP_DIR"

# 查找主 tex 文件
echo "🔍 Looking for main tex file..."
MAIN_TEX=$(find "$ARXIV_ID" -name "*.tex" -type f | grep -E "(main|arxiv)" | head -1)

if [ -z "$MAIN_TEX" ]; then
    # 如果没找到 main/arxiv，找最大的 tex 文件
    MAIN_TEX=$(find "$ARXIV_ID" -name "*.tex" -type f -exec ls -l {} + | sort -k5 -nr | head -1 | awk '{print $NF}')
fi

if [ -n "$MAIN_TEX" ]; then
    echo "✅ Main tex file found: $MAIN_TEX"
    
    # 提取标题
    echo "📋 Extracting paper title..."
    TITLE=$(grep -A 2 "title{" "$MAIN_TEX" | head -3 | tr -d '\n' | sed 's/.*title{//;s/}//;s/\\//g;s/  */ /g')
    if [ -n "$TITLE" ]; then
        echo "📝 Title: $TITLE"
        echo "$TITLE" > "$ARXIV_ID/TITLE.txt"
    fi
else
    echo "⚠️  Could not identify main tex file automatically"
fi

# 列出目录内容
echo ""
echo "📁 Directory structure:"
ls -la "$ARXIV_ID/"

echo ""
echo "✅ Successfully downloaded and extracted arxiv:$ARXIV_ID"
echo ""
echo "Next steps:"
echo "  1. cd $ARXIV_ID/"
echo "  2. Review the extracted files"
echo "  3. Check TITLE.txt for the paper title"
echo "  4. Rename directory if desired: mv $ARXIV_ID <paper_short_name>/"
echo "  5. Follow the paper_understanding.md workflow"
