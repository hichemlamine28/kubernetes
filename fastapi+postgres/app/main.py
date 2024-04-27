from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel
from typing import List, Annotated
import os

# import models

from sqlalchemy.orm import Session
from fastapi.responses import HTMLResponse, FileResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates


if os.getenv("RUNNING_IN_DOCKER"):
    from app import models
    from app.database import engine, SessionLocal
else:
    import models
    from database import engine, SessionLocal






app = FastAPI()
models.Base.metadata.create_all(bind=engine)



app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="templates")

@app.get('/favicon.ico')
async def favicon():
    file_name = "favicon.ico"
    file_path = os.path.join(app.root_path, "static", file_name)
    return FileResponse(path=file_path, headers={"Content-Disposition": "attachment; filename=" + file_name})



@app.get("/")
def read_root():
    # return {"Welcome": "Hichem     " f"from: {os.environ.get('ENV', 'DEFAULT_ENV')}"}
    return {"Welcome": "Hichem     " f"from: {os.environ.get('HOSTNAME', 'DEFAULT_ENV')}"}




class ChoiceBase(BaseModel):
    choice_text: str
    is_correct: bool

class QuestionBase(BaseModel):
    question_text: str
    choices: List[ChoiceBase]



def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


db_dependency = Annotated[Session, Depends(get_db)]



@app.get("/questions")
async def list_questions(db: db_dependency):
    result = db.query(models.Questions).all()
    if not result:
        raise HTTPException(status_code=404, detail='No Questions found')
    return result




@app.get("/questions/{question_id}")
async def read_question(question_id: int, db: db_dependency):
    result = db.query(models.Questions).filter(models.Questions.id == question_id).first()
    if not result:
        raise HTTPException(status_code=404, detail='Question not found')
    return result


@app.get("/choices/{question_id}")
async def read_choices(question_id:int, db: db_dependency):
    result = db.query(models.Choices).filter(models.Choices.question_id == question_id).all()
    if not result:
        raise HTTPException(status_code=404, detail='Choices not found')
    return result


@app.post("/questions/")
async def create_questions(question: QuestionBase, db: db_dependency):
    db_question = models.Questions(question_text=question.question_text)
    db.add(db_question)
    db.commit()
    db.refresh(db_question)
    for choice in question.choices:
        db_choice = models.Choices(choice_text=choice.choice_text, is_correct=choice.is_correct, question_id=db_question.id)
        db.add(db_choice)

    db.commit()
