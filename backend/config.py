import os
from pydantic import BaseSettings

class Settings(BaseSettings):
    secret_key: str
    mongodb_url: str
    database_name: str
    access_token_expire_minutes: int = 30
    
    class Config:
        env_file = ".env"
        case_sensitive = False

settings = Settings()
