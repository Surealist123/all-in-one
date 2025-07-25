// Hugging Face AI Interface JavaScript

// Global state
let modelStatus = {
    textGeneration: false,
    sentimentAnalysis: false
};

// Initialize the application
document.addEventListener('DOMContentLoaded', function() {
    checkModelStatus();
    
    // Set up event listeners
    document.getElementById('prompt-input').addEventListener('keypress', function(e) {
        if (e.key === 'Enter' && e.ctrlKey) {
            generateText();
        }
    });
    
    document.getElementById('sentiment-input').addEventListener('keypress', function(e) {
        if (e.key === 'Enter' && e.ctrlKey) {
            analyzeSentiment();
        }
    });
});

// Tab switching functionality
function showTab(tabName) {
    // Hide all tab contents
    const tabContents = document.querySelectorAll('.tab-content');
    tabContents.forEach(tab => tab.classList.remove('active'));
    
    // Remove active class from all tab buttons
    const tabButtons = document.querySelectorAll('.tab-button');
    tabButtons.forEach(button => button.classList.remove('active'));
    
    // Show selected tab content
    document.getElementById(tabName).classList.add('active');
    
    // Add active class to clicked button
    event.target.classList.add('active');
}

// Check model status
async function checkModelStatus() {
    try {
        const response = await fetch('/api/models');
        const data = await response.json();
        
        updateModelStatus('text-gen-status', data.text_generation.loaded);
        updateModelStatus('sentiment-status', data.sentiment_analysis.loaded);
        
        modelStatus.textGeneration = data.text_generation.loaded;
        modelStatus.sentimentAnalysis = data.sentiment_analysis.loaded;
        
    } catch (error) {
        console.error('Error checking model status:', error);
        updateModelStatus('text-gen-status', false);
        updateModelStatus('sentiment-status', false);
    }
}

// Update model status indicator
function updateModelStatus(elementId, isLoaded) {
    const element = document.getElementById(elementId);
    element.className = `status-indicator ${isLoaded ? 'loaded' : 'error'}`;
    element.textContent = isLoaded ? 'Loaded' : 'Error';
}

// Show/hide loading spinner
function showLoading(show = true) {
    const loading = document.getElementById('loading');
    loading.style.display = show ? 'flex' : 'none';
}

// Show error message
function showError(message) {
    const errorElement = document.getElementById('error-message');
    errorElement.textContent = message;
    errorElement.style.display = 'block';
    
    setTimeout(() => {
        errorElement.style.display = 'none';
    }, 5000);
}

// Generate text using Hugging Face model
async function generateText() {
    const promptInput = document.getElementById('prompt-input');
    const maxLengthInput = document.getElementById('max-length');
    const resultContainer = document.getElementById('generation-result');
    const resultText = document.getElementById('generated-text');
    
    const prompt = promptInput.value.trim();
    const maxLength = parseInt(maxLengthInput.value);
    
    if (!prompt) {
        showError('Please enter a prompt for text generation.');
        return;
    }
    
    if (!modelStatus.textGeneration) {
        showError('Text generation model is not loaded. Please check the model status.');
        return;
    }
    
    showLoading(true);
    
    try {
        const response = await fetch('/api/generate', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                prompt: prompt,
                max_length: maxLength
            })
        });
        
        const data = await response.json();
        
        if (!response.ok) {
            throw new Error(data.error || 'Failed to generate text');
        }
        
        // Display result
        resultText.textContent = data.generated_text;
        resultContainer.style.display = 'block';
        
        // Scroll to result
        resultContainer.scrollIntoView({ behavior: 'smooth' });
        
    } catch (error) {
        console.error('Error generating text:', error);
        showError(`Error generating text: ${error.message}`);
    } finally {
        showLoading(false);
    }
}

// Analyze sentiment of text
async function analyzeSentiment() {
    const sentimentInput = document.getElementById('sentiment-input');
    const resultContainer = document.getElementById('sentiment-result');
    const sentimentLabel = document.getElementById('sentiment-label');
    const confidenceBar = document.getElementById('confidence-bar');
    const confidenceText = document.getElementById('confidence-text');
    
    const text = sentimentInput.value.trim();
    
    if (!text) {
        showError('Please enter text for sentiment analysis.');
        return;
    }
    
    if (!modelStatus.sentimentAnalysis) {
        showError('Sentiment analysis model is not loaded. Please check the model status.');
        return;
    }
    
    showLoading(true);
    
    try {
        const response = await fetch('/api/sentiment', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                text: text
            })
        });
        
        const data = await response.json();
        
        if (!response.ok) {
            throw new Error(data.error || 'Failed to analyze sentiment');
        }
        
        // Display result
        const sentiment = data.sentiment.toLowerCase();
        const confidence = Math.round(data.confidence * 100);
        
        sentimentLabel.textContent = data.sentiment;
        sentimentLabel.className = `sentiment-value ${sentiment}`;
        
        confidenceBar.style.width = `${confidence}%`;
        confidenceText.textContent = `${confidence}%`;
        
        resultContainer.style.display = 'block';
        
        // Scroll to result
        resultContainer.scrollIntoView({ behavior: 'smooth' });
        
    } catch (error) {
        console.error('Error analyzing sentiment:', error);
        showError(`Error analyzing sentiment: ${error.message}`);
    } finally {
        showLoading(false);
    }
}

// Refresh model status
function refreshModels() {
    checkModelStatus();
}

// Export functions for global access
window.showTab = showTab;
window.generateText = generateText;
window.analyzeSentiment = analyzeSentiment;
window.refreshModels = refreshModels;