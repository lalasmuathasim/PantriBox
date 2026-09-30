from enum import StrEnum


class SupportedAuthProvider(StrEnum):
    EMAIL = "email"
    MOBILE_OTP = "mobile_otp"
    OIDC = "oidc"
    APPLE = "apple"
    GOOGLE = "google"


class AuthBoundary:
    """Placeholder for future auth provider composition."""

    def supported_providers(self) -> list[SupportedAuthProvider]:
        return [
            SupportedAuthProvider.EMAIL,
            SupportedAuthProvider.MOBILE_OTP,
            SupportedAuthProvider.OIDC,
            SupportedAuthProvider.APPLE,
            SupportedAuthProvider.GOOGLE,
        ]
