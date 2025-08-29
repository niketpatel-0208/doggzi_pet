import motor.motor_asyncio
from config import settings
import logging
import asyncio

logger = logging.getLogger(__name__)

class Database:
    def __init__(self):
        self.client = None
        self.database = None
        self._connection_lock = asyncio.Lock()

database = Database()

async def ensure_connection():
    """Ensure database connection with auto-reconnection"""
    async with database._connection_lock:
        if database.database is not None:
            try:
                # Test existing connection
                await database.client.admin.command('ping')
                return  # Connection is good
            except Exception as e:
                logger.warning(f"Existing connection failed, reconnecting: {e}")
                database.client = None
                database.database = None
        
        # Create new connection
        await connect_to_mongo()

async def connect_to_mongo():
    """Create database connection"""
    try:
        logger.info("🔄 Connecting to MongoDB Atlas...")
        database.client = motor.motor_asyncio.AsyncIOMotorClient(
            settings.MONGODB_URL,
            serverSelectionTimeoutMS=5000,
            connectTimeoutMS=10000,
            maxPoolSize=10,
            retryWrites=True,
        )
        database.database = database.client[settings.DATABASE_NAME]
        # Test the connection
        await database.client.admin.command('ping')
        logger.info(f"✅ Connected to MongoDB successfully. Database: {settings.DATABASE_NAME}")
    except Exception as e:
        logger.error(f"❌ MongoDB connection failed: {str(e)}", exc_info=True)
        database.client = None
        database.database = None
        raise

async def close_mongo_connection():
    """Close database connection"""
    if database.client:
        database.client.close()
        logger.info("MongoDB connection closed")

async def get_database():
    """Get database with auto-reconnection"""
    await ensure_connection()
    if database.database is None:
        raise Exception("Failed to establish database connection after retry")
    return database.database
