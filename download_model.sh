#!/bin/sh
set -e

download_file() {
    local hf_repo="$1"
    local filename="$2"
    local dest="$3"

    local url="https://huggingface.co/${hf_repo}/resolve/main/${filename}"
    mkdir -p "$(dirname "$dest")"
    echo "Downloading ${filename} from ${hf_repo} (resumes if partial)..."

    WGET_OUTPUT=$(wget -c "$url" -O "$dest" 2>&1) && WGET_EXIT=0 || WGET_EXIT=$?

    if [ $WGET_EXIT -eq 0 ]; then
        echo "Download complete: ${dest}"
    elif echo "$WGET_OUTPUT" | grep -q "416" && [ -s "${dest}" ]; then
        echo "Already fully downloaded: ${dest}"
    else
        echo "Download failed:"
        echo "$WGET_OUTPUT"
        exit 1
    fi
}

download_file "${HF_REPO}" "${MODEL_FILENAME}" "/models/${MODEL_DIR}/${MODEL_FILENAME}"

if [ -n "${MTP_FILENAME}" ]; then
    download_file "${HF_REPO}" "${MTP_FILENAME}" "/models/${MODEL_DIR}/${MTP_FILENAME}"
fi
