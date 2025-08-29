import motor.motor_asyncio
from config import settings
import logging

logger = logging.getLogger(__name__)

class Database:
    client: motor.motor_asyncio.AsyncIOMotorClient = None
    database = None

database = Database()

async def connect_to_mongo():
    """Create database connection"""
    try:
        database.client = motor.motor_asyncio.AsyncIOMotorClient(settings.MONGODB_URL)
        database.database = database.client[settings.DATABASE_NAME]
        # Test the connection
        await database.client.admin.command('ismaster')
        logger.info("Connected to MongoDB successfully")
    except Exception as e:
        logger.error(f"Could not connect to MongoDB: {e}")
        raise

async def close_mongo_connection():
    """Close database connection"""
    if database.client:
        database.client.close()
        logger.info("MongoDB connection closed")

def get_database():
    return database.database
