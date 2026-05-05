#!/bin/sh
set -e

MODEL_FILE="/models/${MODEL_DIR}/${MODEL_FILENAME}"
MODEL_URL="https://huggingface.co/${HF_REPO}/resolve/main/${MODEL_FILENAME}"

mkdir -p "/models/${MODEL_DIR}"

echo "Downloading ${MODEL_FILENAME} from ${HF_REPO} (resumes if partial)..."

WGET_OUTPUT=$(wget -c "$MODEL_URL" -O "$MODEL_FILE" 2>&1) && WGET_EXIT=0 || WGET_EXIT=$?

if [ $WGET_EXIT -eq 0 ]; then
    echo "Download complete: ${MODEL_FILE}"
elif echo "$WGET_OUTPUT" | grep -q "416" && [ -s "${MODEL_FILE}" ]; then
    # HTTP 416 = Range Not Satisfiable = file already fully downloaded
    echo "Model already fully downloaded: ${MODEL_FILE}"
else
    echo "Download failed:"
    echo "$WGET_OUTPUT"
    exit 1
fi
