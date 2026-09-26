from dataclasses import dataclass


@dataclass(slots=True)
class ProviderNotes:
    receipt_storage: str = "ReceiptStorage abstraction; object storage provider not selected."
    receipt_extractor: str = (
        "ReceiptExtractor abstraction; AWS Textract is planned but not required."
    )
    product_normalizer: str = "ProductNormalizer abstraction; provider intentionally undecided."
    routing: str = "RoutingProvider abstraction; Google Maps or equivalent can be introduced later."
