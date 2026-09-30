from sqlalchemy import UniqueConstraint

from app.domains.audit.models import AuditEvent
from app.domains.households.models import HouseholdInvitation, HouseholdMember, HouseholdMembership
from app.domains.pricing.models import PriceObservation
from app.domains.purchases.models import Purchase, PurchaseItem
from app.domains.receipts.models import Receipt
from app.domains.users.models import User, UserIdentity


def test_identity_and_household_access_schema_remain_separate() -> None:
    assert {"email_verified_at", "mobile_e164", "platform_role", "account_status"} <= set(
        User.__table__.columns.keys()
    )
    assert {"user_id", "provider", "provider_subject"} <= set(UserIdentity.__table__.columns.keys())
    assert {"household_id", "user_id", "role", "is_active"} <= set(
        HouseholdMembership.__table__.columns.keys()
    )
    assert {"token_hash", "expires_at", "invited_by_user_id"} <= set(
        HouseholdInvitation.__table__.columns.keys()
    )
    assert {"display_name", "user_id"} <= set(HouseholdMember.__table__.columns.keys())

    membership_constraints = [
        constraint
        for constraint in HouseholdMembership.__table__.constraints
        if isinstance(constraint, UniqueConstraint)
    ]
    assert any(
        {column.name for column in constraint.columns} == {"household_id", "user_id"}
        for constraint in membership_constraints
    )


def test_transactional_provenance_and_price_history_indexes_exist() -> None:
    assert {"source", "extraction_status", "extraction_provider", "extraction_confidence"} <= set(
        Receipt.__table__.columns.keys()
    )
    assert {"recorded_by_user_id", "source"} <= set(Purchase.__table__.columns.keys())
    assert {
        "match_source",
        "match_confidence",
        "matched_by_user_id",
        "source_line_reference",
    } <= set(PurchaseItem.__table__.columns.keys())
    assert "product_variant_id" in PriceObservation.__table__.columns
    assert "details" in AuditEvent.__table__.columns

    index_names = {index.name for index in PriceObservation.__table__.indexes}
    assert "ix_price_observations_product_variant_observed_at" in index_names
    assert "ix_price_observations_product_observed_at" in index_names
