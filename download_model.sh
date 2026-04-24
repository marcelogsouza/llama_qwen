#!/bin/sh
set -e

MODEL_FILE="/models/${MODEL_DIR}/${MODEL_FILENAME}"

if [ -f "$MODEL_FILE" ]; then
    echo "Model already present: ${MODEL_FILE}"
    exit 0
fi

echo "Model not found. Downloading ${MODEL_FILENAME} from ${HF_REPO}..."
mkdir -p "/models/${MODEL_DIR}"

wget \
    "https://huggingface.co/${HF_REPO}/resolve/main/${MODEL_FILENAME}" \
    -O "${MODEL_FILE}"

echo "Download complete: ${MODEL_FILE}"
