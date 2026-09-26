from enum import StrEnum


class SupportedAuthProvider(StrEnum):
    OIDC = "oidc"
    APPLE = "apple"
    GOOGLE = "google"


class AuthBoundary:
    """Placeholder for future auth provider composition."""

    def supported_providers(self) -> list[SupportedAuthProvider]:
        return [
            SupportedAuthProvider.OIDC,
            SupportedAuthProvider.APPLE,
            SupportedAuthProvider.GOOGLE,
        ]
