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
            {
                "name": "get_spending_summary",
                "description": "Future actor-authorized household spending summary.",
            },
            {
                "name": "get_purchase_trends",
                "description": "Future actor-authorized household purchase trends.",
            },
            {
                "name": "get_household_nutrition_coverage",
                "description": "Future deterministic household grocery nutrition coverage.",
            },
            {
                "name": "get_product_nutrition",
                "description": "Future source-backed product nutrition capability.",
            },
            {
                "name": "find_nutrition_opportunities",
                "description": "Future methodology-governed nutrition opportunities.",
            },
            {
                "name": "add_items_to_shopping_list",
                "description": "Future actor-authorized shopping-list mutation capability.",
            },
        ]


class McpServerFacade:
    def describe(self) -> dict[str, object]:
        return {
            "transport": "mcp",
            "shared_service_layer": True,
            "capability_count": len(McpCapabilityRegistry().list_capabilities()),
        }
