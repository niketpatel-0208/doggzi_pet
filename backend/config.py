import os
from pydantic import BaseSettings

class Settings(BaseSettings):
    SECRET_KEY: str
    MONGODB_URL: str
    DATABASE_NAME: str
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    
    # Map to lowercase attributes for backward compatibility
    @property
    def secret_key(self):
        return self.SECRET_KEY
        
    @property 
    def mongodb_url(self):
        return self.MONGODB_URL
        
    @property
    def database_name(self):
        return self.DATABASE_NAME
        
    @property
    def access_token_expire_minutes(self):
        return self.ACCESS_TOKEN_EXPIRE_MINUTES
    
    class Config:
        env_file = ".env"
        case_sensitive = True

settings = Settings()
