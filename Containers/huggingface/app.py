from flask import Flask, render_template, request, jsonify
from flask_cors import CORS
from transformers import pipeline, AutoTokenizer, AutoModelForCausalLM
import torch
import os
import logging

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)
CORS(app)

# Global variables for models
text_generator = None
sentiment_analyzer = None

def load_models():
    """Load Hugging Face models on startup"""
    global text_generator, sentiment_analyzer
    
    try:
        logger.info("Loading Hugging Face models...")
        
        # Load a small text generation model
        text_generator = pipeline(
            "text-generation",
            model="microsoft/DialoGPT-small",
            device=0 if torch.cuda.is_available() else -1
        )
        
        # Load sentiment analysis model
        sentiment_analyzer = pipeline(
            "sentiment-analysis",
            model="cardiffnlp/twitter-roberta-base-sentiment-latest"
        )
        
        logger.info("Models loaded successfully!")
        
    except Exception as e:
        logger.error(f"Error loading models: {e}")
        # Fall back to simpler models
        try:
            text_generator = pipeline("text-generation", model="gpt2")
            sentiment_analyzer = pipeline("sentiment-analysis")
            logger.info("Fallback models loaded successfully!")
        except Exception as e2:
            logger.error(f"Error loading fallback models: {e2}")

@app.route('/')
def index():
    """Main interface page"""
    return render_template('index.html')

@app.route('/api/generate', methods=['POST'])
def generate_text():
    """Generate text using Hugging Face model"""
    try:
        data = request.get_json()
        prompt = data.get('prompt', '')
        max_length = int(data.get('max_length', 50))
        
        if not prompt:
            return jsonify({'error': 'No prompt provided'}), 400
        
        if text_generator is None:
            return jsonify({'error': 'Text generation model not loaded'}), 500
        
        # Generate text
        result = text_generator(
            prompt,
            max_length=max_length,
            num_return_sequences=1,
            do_sample=True,
            temperature=0.7,
            pad_token_id=text_generator.tokenizer.eos_token_id
        )
        
        generated_text = result[0]['generated_text']
        
        return jsonify({
            'generated_text': generated_text,
            'original_prompt': prompt
        })
        
    except Exception as e:
        logger.error(f"Error generating text: {e}")
        return jsonify({'error': str(e)}), 500

@app.route('/api/sentiment', methods=['POST'])
def analyze_sentiment():
    """Analyze sentiment of text"""
    try:
        data = request.get_json()
        text = data.get('text', '')
        
        if not text:
            return jsonify({'error': 'No text provided'}), 400
        
        if sentiment_analyzer is None:
            return jsonify({'error': 'Sentiment analysis model not loaded'}), 500
        
        # Analyze sentiment
        result = sentiment_analyzer(text)
        
        return jsonify({
            'sentiment': result[0]['label'],
            'confidence': result[0]['score'],
            'text': text
        })
        
    except Exception as e:
        logger.error(f"Error analyzing sentiment: {e}")
        return jsonify({'error': str(e)}), 500

@app.route('/api/health')
def health():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'models_loaded': {
            'text_generator': text_generator is not None,
            'sentiment_analyzer': sentiment_analyzer is not None
        }
    })

@app.route('/api/models')
def list_models():
    """List available models and their status"""
    return jsonify({
        'text_generation': {
            'loaded': text_generator is not None,
            'model_name': 'microsoft/DialoGPT-small' if text_generator else None
        },
        'sentiment_analysis': {
            'loaded': sentiment_analyzer is not None,
            'model_name': 'cardiffnlp/twitter-roberta-base-sentiment-latest' if sentiment_analyzer else None
        }
    })

if __name__ == '__main__':
    # Load models on startup
    load_models()
    
    # Run the app
    port = int(os.environ.get('PORT', 8000))
    app.run(host='0.0.0.0', port=port, debug=False)