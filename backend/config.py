import os
from pydantic import BaseSettings

class Settings(BaseSettings):
    SECRET_KEY: str
    MONGODB_URL: str
    DATABASE_NAME: str
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    
    class Config:
        env_file = ".env"
        case_sensitive = True

settings = Settings()
