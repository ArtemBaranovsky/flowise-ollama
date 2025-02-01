# Use the official Python image as the base image
FROM ollama/ollama

# Install necessary dependencies
RUN apt-get update && apt-get install -y curl

# Set the working directory in the container
RUN mkdir /app

# Set the working directory
WORKDIR /app

# Copy the script to download the model
COPY load_model.py /app/load_model.py

# Set Hugging Face token for authentication
ARG HF_TOKEN
ENV HF_TOKEN=${HF_TOKEN}

COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Use the start.sh script as the entrypoint
ENTRYPOINT ["/app/start.sh"]