#!/bin/sh
set -e

KV_FLAG=""
if [ "${KV_OFFLOAD}" = "false" ]; then
    KV_FLAG="--no-kv-offload"
fi

MOE_FLAG=""
if [ -n "${N_CPU_MOE}" ] && [ "${N_CPU_MOE}" -gt 0 ]; then
    MOE_FLAG="--n-cpu-moe ${N_CPU_MOE}"
fi

MMAP_FLAG=""
if [ "${NO_MMAP}" = "true" ]; then
    MMAP_FLAG="--no-mmap"
fi

MLOCK_FLAG=""
if [ "${MLOCK}" = "true" ]; then
    MLOCK_FLAG="--mlock"
fi

exec /app/llama-server \
    -m "/models/${MODEL_DIR}/${MODEL_FILENAME}" \
    --host 0.0.0.0 \
    --port 8080 \
    --webui \
    --jinja \
    --reasoning "${REASONING}" \
    -ngl "${N_GPU_LAYERS}" \
    -c "${CTX_SIZE}" \
    --cache-type-k "${CACHE_TYPE_K}" \
    --cache-type-v "${CACHE_TYPE_V}" \
    --temp "${TEMPERATURE}" \
    --top-p "${TOP_P}" \
    --top-k "${TOP_K}" \
    --min-p "${MIN_P}" \
    --presence-penalty "${PRESENCE_PENALTY}" \
    --repeat-penalty "${REPEAT_PENALTY}" \
    -n "${MAX_TOKENS}" \
    $KV_FLAG \
    $MOE_FLAG \
    $MMAP_FLAG \
    $MLOCK_FLAG
