import openai
import os
from fastapi import FastAPI
from typing import Dict
import requests
from pydantic import BaseModel
import uvicorn

app = FastAPI()
flash_cards: Dict[str, str] = {}

@app.post("/addflash/")
async def add_flashcard(question: str, answer: str):
    flash_cards[question] = answer
    return{"message":"Flashcard added successfully"}

@app.get("/flashcards/")
async def get_flashcards():
    return flash_cards



openai.api_key = "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"
flash_cards: dict[str, str] = {}

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


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
