import os
from transformers import AutoModelForCausalLM, AutoTokenizer

# Set the Hugging Face token for authentication
hf_token = os.environ.get("HF_TOKEN")
if hf_token is None:
    raise ValueError("Hugging Face token is not set")

model_name = "meta-llama/Llama-3.2-1B"

model = AutoModelForCausalLM.from_pretrained(model_name)
tokenizer = AutoTokenizer.from_pretrained(model_name)

print("Model loaded successfully!")
