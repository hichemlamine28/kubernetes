from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import os

app = FastAPI()

class Item(BaseModel):
    text: str = None
    is_done: bool = False


items = []

@app.get("/")
def read_root():
    # return {"Welcome": "Hichem     " f"from: {os.environ.get('ENV', 'DEFAULT_ENV')}"}
    return {"Welcome": "Hichem     " f"from: {os.environ.get('HOSTNAME', 'DEFAULT_ENV')}"}


@app.get("/items")
def list_items(limit: int = 10):
    if len(items)>0:
        return items[0:limit]
    else:
        raise HTTPException(status_code=404, detail=f"empty List, No items found")


@app.post("/items")
def create_item(item: str):
    items.append (item)
    return items


@app.post("/item")
def add_item(item: Item):
    items.append (item)
    return items


@app.get("/items/{item_id}")
def get_item(item_id: int) -> str:
    if item_id <len(items):
        return items[item_id]
    else:
        raise HTTPException(status_code=404, detail=f"item {item_id} not found, id must be betwen 0 and "+ str(len(items)-1))



