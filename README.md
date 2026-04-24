# llama-qwen

Local inference server running [llama.cpp](https://github.com/ggml-org/llama.cpp) with Qwen models via Docker, with NVIDIA GPU support.

## Requirements

- Docker + Docker Compose
- NVIDIA GPU with driver installed
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)

## Supported models

| Folder                       | Model                           |
|------------------------------|---------------------------------|
| `models/qwen3.6-27b/`        | Qwen3.6-27B-UD-IQ2_M.gguf      |
| `models/qwen3.6-35b-a3b/`    | Qwen3.6-35B-A3B-UD-IQ2_M.gguf  |

See [`models/README.md`](models/README.md) for download instructions.

## Configuration

Copy `.env.example` (or edit `.env` directly) and adjust the variables for your GPU and desired model:

```bash
cp .env.example .env
```

Key variables:

| Variable         | Description                                                  |
|------------------|--------------------------------------------------------------|
| `LLAMA_PORT`     | Port exposed by the server (default: `8080`)                 |
| `MODEL_PATH`     | Model path inside the container (e.g. `/models/qwen3.6-35b-a3b/Qwen3.6-35B-A3B-UD-IQ2_M.gguf`) |
| `N_GPU_LAYERS`   | Layers offloaded to GPU (`-1` = all)                         |
| `CTX_SIZE`       | Context size in tokens                                       |
| `REASONING`      | Enables chain-of-thought (`on` / `off`)                      |
| `CACHE_TYPE_K/V` | KV-cache quantization (`q8_0`, `f16`, etc.)                  |
| `TEMPERATURE`    | Sampling temperature                                         |
| `MAX_TOKENS`     | Maximum tokens generated per response                        |

The `.env` file includes commented presets for different use cases (thinking, coding, general chat).

## Usage

```bash
# Start the server
docker compose up -d

# View logs
docker compose logs -f

# Stop
docker compose down
```

The server exposes an OpenAI-compatible API at `http://localhost:8080` and a Web UI at `http://localhost:8080`.

## Structure

```
.
├── docker-compose.yml
├── .env
└── models/
    ├── README.md
    ├── qwen3.6-27b/
    │   └── Qwen3.6-27B-UD-IQ2_M.gguf
    └── qwen3.6-35b-a3b/
        └── Qwen3.6-35B-A3B-UD-IQ2_M.gguf
```
