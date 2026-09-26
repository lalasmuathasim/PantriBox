from dataclasses import dataclass


@dataclass(slots=True)
class AgentIntent:
    name: str
    payload: dict[str, object]


@dataclass(slots=True)
class StructuredRecommendation:
    summary: str
    data: dict[str, object]
