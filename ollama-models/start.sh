#!/bin/bash
# start.sh

if ! ollama list | grep -q "$MODEL_NAME"; then
  echo "Model is not found. Loading..."
  HUGGING_FACE_HUB_TOKEN=${HF_TOKEN} ollama pull "$MODEL_NAME"
else
  echo "Model is already loaded."
fi

ollama serve &
sleep 10
ollama run "$MODEL_NAME"

tail -f /dev/null