# STaRK Evaluation Makefile

# Default values
DATASET ?= amazon
MODEL ?= VSS
EMB_DIR ?= emb/
OUTPUT_DIR ?= output/
EMB_MODEL ?= text-embedding-ada-002
SPLIT ?= test
LLM_MODEL ?= gpt-4-1106-preview

# Common arguments
COMMON_ARGS = --dataset $(DATASET) --emb_dir $(EMB_DIR) --output_dir $(OUTPUT_DIR) --split $(SPLIT) --save_pred

# VSS Evaluations
eval-amazon-vss:
	python eval.py $(COMMON_ARGS) --dataset amazon --model VSS --emb_model $(EMB_MODEL)

eval-prime-vss:
	python eval.py $(COMMON_ARGS) --dataset prime --model VSS --emb_model $(EMB_MODEL)

eval-mag-vss:
	python eval.py $(COMMON_ARGS) --dataset mag --model VSS --emb_model $(EMB_MODEL)

# BM25 Evaluations
eval-amazon-bm25:
	python eval.py $(COMMON_ARGS) --dataset amazon --model BM25

eval-prime-bm25:
	python eval.py $(COMMON_ARGS) --dataset prime --model BM25

eval-mag-bm25:
	python eval.py $(COMMON_ARGS) --dataset mag --model BM25

# LLM Reranker Evaluations
eval-amazon-llm-gpt4:
	python eval.py $(COMMON_ARGS) --dataset amazon --model LLMReranker --emb_model $(EMB_MODEL) --llm_model gpt-4-1106-preview

eval-prime-llm-gpt4:
	python eval.py $(COMMON_ARGS) --dataset prime --model LLMReranker --emb_model $(EMB_MODEL) --llm_model gpt-4-1106-preview

eval-mag-llm-gpt4:
	python eval.py $(COMMON_ARGS) --dataset mag --model LLMReranker --emb_model $(EMB_MODEL) --llm_model gpt-4-1106-preview

# Ollama Evaluations
eval-amazon-llm-ollama:
	python eval.py $(COMMON_ARGS) --dataset amazon --model LLMReranker --emb_model $(EMB_MODEL) --llm_model llama3.2

eval-prime-llm-ollama:
	python eval.py $(COMMON_ARGS) --dataset prime --model LLMReranker --emb_model $(EMB_MODEL) --llm_model llama3.2

eval-mag-llm-ollama:
	python eval.py $(COMMON_ARGS) --dataset mag --model LLMReranker --emb_model $(EMB_MODEL) --llm_model llama3.2

# Ollama with 8B model (when available)
eval-amazon-llm-ollama-8b:
	python eval.py $(COMMON_ARGS) --dataset amazon --model LLMReranker --emb_model $(EMB_MODEL) --llm_model llama3:8b

eval-prime-llm-ollama-8b:
	python eval.py $(COMMON_ARGS) --dataset prime --model LLMReranker --emb_model $(EMB_MODEL) --llm_model llama3:8b

eval-mag-llm-ollama-8b:
	python eval.py $(COMMON_ARGS) --dataset mag --model LLMReranker --emb_model $(EMB_MODEL) --llm_model llama3:8b

# MultiVSS Evaluations
eval-amazon-multivss:
	python eval.py $(COMMON_ARGS) --dataset amazon --model MultiVSS --emb_model $(EMB_MODEL)

eval-prime-multivss:
	python eval.py $(COMMON_ARGS) --dataset prime --model MultiVSS --emb_model $(EMB_MODEL)

eval-mag-multivss:
	python eval.py $(COMMON_ARGS) --dataset mag --model MultiVSS --emb_model $(EMB_MODEL)

# Embedding generation
emb-download-amazon:
	python emb_download.py --dataset amazon --emb_dir $(EMB_DIR)

emb-download-prime:
	python emb_download.py --dataset prime --emb_dir $(EMB_DIR)

emb-download-mag:
	python emb_download.py --dataset mag --emb_dir $(EMB_DIR)

emb-generate-amazon-query:
	python emb_generate.py --dataset amazon --mode query --emb_dir $(EMB_DIR) --emb_model $(EMB_MODEL)

emb-generate-amazon-doc:
	python emb_generate.py --dataset amazon --mode doc --emb_dir $(EMB_DIR) --emb_model $(EMB_MODEL)

# Ollama setup
ollama-setup:
	@echo "Setting up Ollama..."
	@which ollama > /dev/null || (echo "Please install ollama first: brew install ollama" && exit 1)
	@echo "Starting ollama service..."
	@ollama serve &
	@echo "Pulling llama3.2 model..."
	@ollama pull llama3.2
	@echo "Pulling llama3:8b model..."
	@ollama pull llama3:8b

ollama-pull-3b:
	ollama pull llama3.2:3b

ollama-pull-8b:
	ollama pull llama3:8b

ollama-pull-70b:
	ollama pull llama3:70b

ollama-list:
	ollama list

# Help
help:
	@echo "STaRK Evaluation Makefile"
	@echo "========================"
	@echo ""
	@echo "Common targets:"
	@echo "  eval-amazon-vss        - Run Amazon VSS evaluation"
	@echo "  eval-prime-vss         - Run Prime VSS evaluation"
	@echo "  eval-mag-vss           - Run MAG VSS evaluation"
	@echo "  eval-*-bm25            - Run BM25 evaluations"
	@echo "  eval-*-llm-gpt4        - Run LLM reranker with GPT-4"
	@echo "  eval-*-llm-ollama      - Run LLM reranker with Ollama"
	@echo "  eval-*-llm-ollama-8b   - Run LLM reranker with Ollama 8B"
	@echo "  eval-*-multivss        - Run MultiVSS evaluations"
	@echo ""
	@echo "Embedding targets:"
	@echo "  emb-download-*         - Download pre-computed embeddings"
	@echo "  emb-generate-*-query   - Generate query embeddings"
	@echo "  emb-generate-*-doc     - Generate document embeddings"
	@echo ""
	@echo "Ollama targets:"
	@echo "  ollama-setup           - Setup ollama with common models"
	@echo "  ollama-pull-3b         - Pull llama3.2:3b model"
	@echo "  ollama-pull-8b         - Pull llama3:8b model"
	@echo "  ollama-pull-70b        - Pull llama3:70b model"
	@echo "  ollama-list            - List available ollama models"
	@echo ""
	@echo "Variables:"
	@echo "  DATASET=$(DATASET)"
	@echo "  MODEL=$(MODEL)"
	@echo "  EMB_DIR=$(EMB_DIR)"
	@echo "  OUTPUT_DIR=$(OUTPUT_DIR)"
	@echo "  EMB_MODEL=$(EMB_MODEL)"
	@echo "  SPLIT=$(SPLIT)"
	@echo "  LLM_MODEL=$(LLM_MODEL)"

.PHONY: help eval-* emb-* ollama-*