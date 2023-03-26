from datetime import datetime
import openai
import os
from fastapi import Body, FastAPI
from typing import Dict, List, Optional
from pydantic import BaseModel
import uvicorn
from fastapi.middleware.cors import CORSMiddleware
from newspaper import Article

origins = ["*"]

class Flashcard(BaseModel):
    dynamic: bool = False
    front: str = None
    back: str = None
    prompt: str = None
    source_url: str = None
    last_reviewed: datetime = None


app = FastAPI()
flash_cards: List[Dict] = [
    Flashcard(front="What is the capital of France?", back="Paris"),
    Flashcard(dynamic=True, prompt="A simple arithmetic problem"),
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)

openai.api_key = os.getenv('OPENAI_API_KEY')
if openai.api_key is None:
    print("Warning: no OpenAI API key found. Set the OPENAI_API_KEY environment variable.")


def chat_history(prompt, data):
    return [
        {
            "role": "user",
            "content": prompt
        },
        {
            "role": "assistant",
            "content": "Yes, I understand the instructions."
        },
        {
            "role": "user",
            "content": data
        }
    ]

def chatgpt(prompt, data):
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=chat_history(prompt, data)
    )
    return str(response['choices'][0]['message']['content'])

@app.get("/flashcards/")
async def get_flashcards():
    return flash_cards

@app.post("/add")
async def add_flashcard(card: Flashcard):
    flash_cards.append(card)
    return{"message":"Flashcard added successfully"}

dynamic_prompt = """
I'm going to give you a description of a flashcard. Please respond with text for the front and back of the card, liek this: "front | back".
Do you understand the instructions?
"""

def generate_dynamic(prompt):
    response = chatgpt(dynamic_prompt, prompt)
    [front, back] = response.split(' | ')
    new_flashcard = Flashcard(dynamic=True, front=front, back=back)
    flash_cards.append(new_flashcard)
    return new_flashcard

@app.get("/flashcards-dynamic")
async def get_flashcards_dynamic():
    dynamic_flashcards = []
    for card in flash_cards:
        if card.dynamic:
            dynamic_flashcards.append(generate_dynamic(card.prompt))
        else:
            dynamic_flashcards.append(card)
    return dynamic_flashcards

@app.post("/generate")
def generate_response(prompt:str):
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=chat_history(dynamic_prompt, prompt)
    )
    output_gpt: str = str(response['choices'][0]['message']['content'])
    [front, back] = output_gpt.split(' | ')
    new_flashcard = Flashcard(front=front, back=back, dynamic=False)
    flash_cards.append(new_flashcard)
    return new_flashcard

generate_url_prompt = """
I'm going to give you the text of an article.
Please generate a list of flashcards that covers the same information. Write each card on a new line, using the format "front | back". Do not add anything else.
Do you understand the instructions?
"""

class GenerateRequest(BaseModel):
    url: str

@app.post("/generate-url")
def generate_url(req: GenerateRequest = Body()):
    url = req.url
    article = Article(url)
    article.download()
    article.parse()
    print('ARTICLE TEXT:')
    print(article.text)
    text = article.text[:3000]
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=chat_history(generate_url_prompt, text)
    )
    output_gpt: str = str(response['choices'][0]['message']['content'])
    new_cards = []
    for line in output_gpt.split('\n'):
        parts = line.split(' | ')
        if len(parts) == 2:
            [front, back] = parts
        else:
            front = line
            back = "(No back)"
        new_cards.append(Flashcard(front=front, back=back))
    return new_cards

synthesis_prompt = """
Here is a list of flashcards that I need to study, formatted as front->back.
Please generate a different list of flashcards that covers the same information.
Each new flashcard must correspond to one or two old flashcards, with the number(s) in a comma-separated list before the question.
You may change the structure of the cards to add variety. For instance, you could turn "What year was the Declaration of Independence signed?->1776" into "What important event happened in 1776?->The Declaration of Independence was signed." However, do not introduce new information that wasn't in the original list. All information used in the new flashcards must be somewhere in the list of old flashcards.
If two cards are closely related, you may combine them into a new one that covers the same information. For example, you could combine "WW2 began in 1939" and "WW2 ended in 1945" into "WW2 lasted 6 years." Do not combine unrelated cards.
Do you understand the instructions?
"""

@app.get("/synthesize")
def synthesize():
    message = '\n'.join([f"{i+1} | {card.front} | {card.back}" for i, card in enumerate(flash_cards) if not card.dynamic])
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=chat_history(synthesis_prompt, message)
    )
    output_gpt: str = str(response['choices'][0]['message']['content'])
    lines = output_gpt.split('\n')
    synthesized_cards = []
    for line in lines:
        [numbers, front, back] = line.split(' | ')
        numbers = [int(n) for n in numbers.split(', ')]
        synthesized_cards.append(Flashcard(front=front, back=back))
    return synthesized_cards
     
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=os.getenv('PORT', 8000))
