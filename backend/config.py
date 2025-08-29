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

# Create lowercase aliases for backward compatibility
settings.secret_key = settings.SECRET_KEY
settings.mongodb_url = settings.MONGODB_URL  
settings.database_name = settings.DATABASE_NAME
settings.access_token_expire_minutes = settings.ACCESS_TOKEN_EXPIRE_MINUTES
