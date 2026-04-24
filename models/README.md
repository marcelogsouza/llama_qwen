# Models

This folder contains the GGUF models used by the server. Model files are **not tracked in the repository** due to their size — download them manually following the instructions below.

## Available models

### Qwen3.6-35B-A3B (MoE, recommended)

Mixture-of-Experts model with 35B total parameters and 3B active per token. Best performance-to-resource ratio.

```bash
mkdir -p models/qwen3.6-35b-a3b
huggingface-cli download \
  unsloth/Qwen3-30B-A3B-GGUF \
  Qwen3.6-35B-A3B-UD-IQ2_M.gguf \
  --local-dir models/qwen3.6-35b-a3b
```

### Qwen3.6-27B (dense)

Dense 27B parameter model. Heavier on the GPU, but more predictable behavior.

```bash
mkdir -p models/qwen3.6-27b
huggingface-cli download \
  unsloth/Qwen3-30B-GGUF \
  Qwen3.6-27B-UD-IQ2_M.gguf \
  --local-dir models/qwen3.6-27b
```

## Installing huggingface-cli

```bash
pip install huggingface_hub
```

Or with `pipx`:

```bash
pipx install huggingface_hub
```

## Expected structure

After downloading, the folder structure should look like:

```
models/
├── qwen3.6-27b/
│   └── Qwen3.6-27B-UD-IQ2_M.gguf
└── qwen3.6-35b-a3b/
    └── Qwen3.6-35B-A3B-UD-IQ2_M.gguf
```

Set the `MODEL_PATH` variable in `.env` to point to the desired model.
