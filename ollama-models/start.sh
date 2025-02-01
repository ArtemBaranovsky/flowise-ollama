#!/bin/bash
# Pull the Ollama model
ollama pull llama3.2:1b
# Run the Ollama model
ollama run llama3.2:1b &
# Serve the Ollama model
ollama serve
