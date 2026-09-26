from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse

from app.core.errors.exceptions import PantriBoxError


def register_exception_handlers(app: FastAPI) -> None:
    @app.exception_handler(PantriBoxError)
    async def pantribox_exception_handler(  # type: ignore[no-untyped-def]
        _request: Request, exc: PantriBoxError
    ) -> JSONResponse:
        return JSONResponse(
            status_code=exc.status_code,
            content={"error": {"message": exc.message, "type": exc.__class__.__name__}},
        )
