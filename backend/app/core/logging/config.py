import logging

from app.core.config.settings import Settings


def configure_logging(settings: Settings) -> None:
    logging.basicConfig(
        level=getattr(logging, settings.log_level.upper(), logging.INFO),
        format=(
            "%(asctime)s %(levelname)s env=%(pantribox_env)s request_id=%(request_id)s "
            "logger=%(name)s message=%(message)s"
        ),
    )

    base_factory = logging.getLogRecordFactory()

    def factory(*args, **kwargs):  # type: ignore[no-untyped-def]
        record = base_factory(*args, **kwargs)
        record.pantribox_env = settings.env
        if not hasattr(record, "request_id"):
            record.request_id = "-"
        return record

    logging.setLogRecordFactory(factory)
