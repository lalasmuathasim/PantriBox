from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

from app.core.config.settings import get_settings

settings = get_settings()
engine = create_engine(settings.database_url, future=True)
SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False, future=True)


def get_db_session():  # type: ignore[no-untyped-def]
    session: Session = SessionLocal()
    try:
        yield session
    finally:
        session.close()
