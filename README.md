# llama-qwen

Local inference server running [llama.cpp](https://github.com/ggml-org/llama.cpp) with Qwen models via Docker, with NVIDIA GPU support.

On `docker compose up`, the model is downloaded automatically from HuggingFace if not already present locally.

## Requirements

- Docker + Docker Compose
- NVIDIA GPU with driver installed
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)

## Quickstart

```bash
# Clone and start — model downloads automatically on first run
docker compose up -d
```

The server will be available at `http://localhost:8080` (Web UI + OpenAI-compatible API).

## Using a different model

Edit the following variables in `.env`:

```env
HF_REPO=unsloth/Qwen3-30B-A3B-GGUF
MODEL_DIR=qwen3.6-35b-a3b
MODEL_FILENAME=Qwen3.6-35B-A3B-UD-IQ2_M.gguf
```

- `HF_REPO`: the HuggingFace repository path (found in the URL of the model page)
- `MODEL_FILENAME`: the exact `.gguf` filename listed on the repo's Files tab
- `MODEL_DIR`: local folder name where the file will be stored under `models/`

See [`models/README.md`](models/README.md) for tested models.

## Quantization comparison

Perplexity measured on WikiText-2 test set (50 chunks, ctx=512) — model: Qwen3.6-35B-A3B, RTX 4070 (12 GB VRAM).

> This branch uses a custom llama.cpp fork ([TheTom/llama-cpp-turboquant](https://github.com/TheTom/llama-cpp-turboquant)) for TurboQuant KV cache support (`turbo4`/`turbo3`).

| Quantization | PPL (↓ better) | Δ vs Q8_0 | Speed (s/pass) | Size   | CPU RAM (experts) | N_CPU_MOE |
|--------------|----------------|-----------|----------------|--------|-------------------|-----------|
| IQ2_M        | 6.6773 ± 0.147 | +7.4%     | 2.14s          | 11.5 GB | ~5 GB            | 35        |
| **Q4_K_M**   | **6.2402 ± 0.136** | **+0.4%** | **2.91s**  | 22.1 GB | 12.1 GB          | **28**    |
| Q8_0         | 6.2181 ± 0.135 | baseline  | 4.63s          | 36.9 GB | 27.4 GB          | 33        |

**Q4_K_M is the recommended configuration**: virtually identical quality to Q8_0 (+0.4% perplexity), 37% faster, uses 15 GB less RAM and fits 5 more expert layers on GPU.

## Configuration

Key variables in `.env`:

| Variable         | Description                                                       |
|------------------|-------------------------------------------------------------------|
| `LLAMA_PORT`     | Port exposed by the server (default: `8080`)                      |
| `HF_REPO`        | HuggingFace repository to download the model from                 |
| `MODEL_DIR`      | Local subfolder under `models/`                                   |
| `MODEL_FILENAME` | Exact `.gguf` filename                                            |
| `N_GPU_LAYERS`   | Layers offloaded to GPU (`-1` = all)                              |
| `N_CPU_MOE`      | MoE expert layers kept on CPU (tune to fit VRAM; see table above) |
| `CTX_SIZE`       | Context size in tokens (max 262144 for this model)                |
| `KV_OFFLOAD`     | KV cache on GPU (`true`) or RAM (`false`)                         |
| `NO_MMAP`        | Load model fully into RAM (`true` = faster, needs more RAM)       |
| `MLOCK`          | Pin model in RAM to prevent OS swap                               |
| `CACHE_TYPE_K/V` | KV-cache quantization (`turbo4`/`turbo3` with this fork)          |
| `TEMPERATURE`    | Sampling temperature                                              |
| `MAX_TOKENS`     | Maximum tokens generated per response                             |

The `.env` file includes commented presets for different use cases (thinking, coding, general chat).

## Usage

```bash
# Start (downloads model automatically on first run)
docker compose up -d

# View logs
docker compose logs -f

# Stop
docker compose down
```

## Troubleshooting

### Cannot access from another machine on the network

The server is accessible at `http://<host-ip>:8080` from any machine on the same network. If it isn't responding, the container is likely not running:

```bash
docker ps --filter name=llama-cpp-qwen
```

If it shows `Exited` or nothing, start it:

```bash
docker compose up -d
```

> **Note:** `docker compose down` disables the automatic restart policy. If you only want to pause the server (keeping auto-restart on reboot), use `docker stop llama-cpp-qwen` instead.

## Structure

```
.
├── docker-compose.yml
├── download_model.sh
├── .env
└── models/
    ├── README.md
    ├── qwen3.6-27b/
    │   └── Qwen3.6-27B-UD-IQ2_M.gguf
    └── qwen3.6-35b-a3b/
        └── Qwen3.6-35B-A3B-UD-IQ2_M.gguf
```
