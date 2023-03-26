from datetime import datetime
import openai
import os
from fastapi import FastAPI
from typing import Dict, List, Optional
from pydantic import BaseModel
import uvicorn
from fastapi.middleware.cors import CORSMiddleware

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

@app.post("/addflash/")
async def add_flashcard(card: Flashcard):
    # Get the request body as json
    flash_cards.append(card)
    return{"message":"Flashcard added successfully"}

@app.get("/flashcards/")
async def get_flashcards():
    return flash_cards

openai.api_key = os.getenv('OPENAI_API_KEY')
print(openai.api_key)

@app.get("/generate/")
def generate_response(prompts:str):
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=[
            {"role":"user","content":f"{prompts}"}
        ]
    )
    output_gpt: str = str(response['choices'][0]['message']['content'])
    data = {"question": prompts, "answer": output_gpt}
    flash_cards[prompts] = output_gpt
    return output_gpt

synthesis_prompt = """
Here is a list of flashcards that I need to study, formatted as front->back.
Please generate a different list of flashcards that covers the same information.
Each new flashcard must correspond to one or two old flashcards, with the number(s) in a comma-separated list before the question.
You may change the structure of the cards to add variety. For instance, you could turn "What year was the Declaration of Independence signed?->1776" into "What important event happened in 1776?->The Declaration of Independence was signed." However, do not introduce new information that wasn't in the original list. All information used in the new flashcards must be somewhere in the list of old flashcards.
If two cards are closely related, you may combine them into a new one that covers the same information. For example, you could combine "WW2 began in 1939" and "WW2 ended in 1945" into "WW2 lasted 6 years." Do not combine unrelated cards.
"""

@app.get("/synthesize/")
def synthesize():
    message = synthesis_prompt + '\n\n' + '\n'.join([f"({i+1}) {card.front}->{card.back}" for i, card in enumerate(flash_cards) if not card.dynamic])
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=[
            {"role":"user","content":message}
        ]
    )
    output_gpt: str = str(response['choices'][0]['message']['content'])
    lines = output_gpt.split('\n')
    synthesized_cards = []
    for line in lines:
        [front, back] = line.split('->')
        synthesized_cards.append(Flashcard(front=front, back=back))
    return synthesized_cards
     

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
