from dataclasses import dataclass


@dataclass(frozen=True)
class McpCapability:
    name: str
    description: str


class McpCapabilityRegistry:
    def list_capabilities(self) -> list[dict[str, str]]:
        return [
            {
                "name": "compare_prices",
                "description": "Future structured price comparison for shopping lists.",
            },
            {
                "name": "get_price_history",
                "description": "Future price history capability sourced from price observations.",
            },
            {
                "name": "get_household_purchase_history",
                "description": "Future household purchase history capability for agents.",
            },
        ]


class McpServerFacade:
    def describe(self) -> dict[str, object]:
        return {
            "transport": "mcp",
            "shared_service_layer": True,
            "capability_count": len(McpCapabilityRegistry().list_capabilities()),
        }
