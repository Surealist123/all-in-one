# Hugging Face AI Container for Nextcloud AIO

This container provides AI-powered text generation and sentiment analysis capabilities using Hugging Face transformers, integrated into the Nextcloud All-in-One ecosystem.

## Features

- **Text Generation**: Generate contextual text using advanced language models
- **Sentiment Analysis**: Analyze the emotional tone of text with confidence scores
- **Web Interface**: Modern, responsive IDE-like interface for easy interaction
- **Model Management**: Real-time status monitoring of loaded AI models
- **AIO Integration**: Seamlessly integrated with Nextcloud AIO container management

## Technical Details

- **Base Image**: Python 3.11 slim
- **Framework**: Flask with CORS support
- **AI Library**: Hugging Face Transformers
- **Models Used**:
  - Text Generation: microsoft/DialoGPT-small (fallback: gpt2)
  - Sentiment Analysis: cardiffnlp/twitter-roberta-base-sentiment-latest
- **Port**: 8000 (internal)
- **Memory Requirements**: ~2GB additional RAM

## API Endpoints

- `GET /` - Main web interface
- `POST /api/generate` - Generate text from prompt
- `POST /api/sentiment` - Analyze text sentiment
- `GET /api/health` - Health check
- `GET /api/models` - Model status information

## Usage

1. Enable the "Hugging Face AI" option in the Nextcloud AIO optional containers section
2. Start the containers
3. Access the interface through the AIO web interface
4. Use the tabbed interface to:
   - Generate text by entering prompts
   - Analyze sentiment of text snippets

## Requirements

- At least 3GB RAM when enabled (2GB additional for AI models)
- Docker with sufficient resources
- Internet connection for initial model downloads

## Security

- Runs as non-root user (UID 65534)
- Network capabilities dropped (NET_RAW)
- Health checks for container monitoring
- CORS enabled for web interface integration