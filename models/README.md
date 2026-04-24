# Models

This folder stores the GGUF model files. They are **not tracked in the repository** due to their size.

**Models are downloaded automatically** on `docker compose up` if not already present, based on the `HF_REPO`, `MODEL_DIR`, and `MODEL_FILENAME` variables in `.env`.

To download manually or use a different model, follow the instructions below.

## Switching models

Edit `.env`:

```env
HF_REPO=unsloth/Qwen3-30B-A3B-GGUF
MODEL_DIR=qwen3.6-35b-a3b
MODEL_FILENAME=Qwen3.6-35B-A3B-UD-IQ2_M.gguf
```

You can use any public GGUF model on HuggingFace — just copy the repository path and the exact filename from the Files tab of the model page.

## Tested models

### Qwen3.6-35B-A3B (MoE, recommended)

Mixture-of-Experts with 35B total / 3B active parameters. Best performance-to-resource ratio.

```env
HF_REPO=unsloth/Qwen3-30B-A3B-GGUF
MODEL_DIR=qwen3.6-35b-a3b
MODEL_FILENAME=Qwen3.6-35B-A3B-UD-IQ2_M.gguf
```

### Qwen3.6-27B (dense)

Dense 27B parameter model. Heavier on the GPU, but more predictable behavior.

```env
HF_REPO=unsloth/Qwen3-30B-GGUF
MODEL_DIR=qwen3.6-27b
MODEL_FILENAME=Qwen3.6-27B-UD-IQ2_M.gguf
```

## Manual download

If you prefer to download manually using `huggingface-cli`:

```bash
pip install huggingface_hub

huggingface-cli download unsloth/Qwen3-30B-A3B-GGUF \
  Qwen3.6-35B-A3B-UD-IQ2_M.gguf \
  --local-dir models/qwen3.6-35b-a3b
```

## Expected structure

```
models/
├── qwen3.6-27b/
│   └── Qwen3.6-27B-UD-IQ2_M.gguf
└── qwen3.6-35b-a3b/
    └── Qwen3.6-35B-A3B-UD-IQ2_M.gguf
```
