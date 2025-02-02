#!/bin/bash

MODEL_NAME="llama3.2:1b"

if ! ollama list | grep -q "$MODEL_NAME"; then
  echo "Model is not found. Loading..."
  ollama pull "$MODEL_NAME"
else
  echo "Model is already loaded."
fi

ollama run "$MODEL_NAME" &
ollama serve