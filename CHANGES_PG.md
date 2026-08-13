# Changes in PG Rust components kotlin 1.0.7 (07-2026)

Bugfix 🐛:

- Fixes corrupt sessions being stuck asking to verify the device, even after entering the recovery key

# Changes in PG Rust components kotlin 1.0.6 (07-2026)

Improvements 🙌:

- Update Argus integration

# Changes in PG Rust components kotlin 1.0.5 (07-2026)

Features ✨:

- Adds `featureFlags` profile field

# Changes in PG Rust components kotlin 1.0.4 (05-2026)

Upstream merge ✨:

- Base update to 26.05.13 (https://github.com/matrix-org/matrix-rust-components-kotlin/tree/sdk-v26.05.13) for element-x-android v26.05.01

# Changes in PG Rust components kotlin 1.0.3 (05-2026)

Features ✨:

- Adds argus integration

# Changes in PG Rust components kotlin 1.0.2 (03-2026)

Bugfix 🐛:

- Add `hasOtherJoinedMember()` method that queries actual member state events from the store instead of relying on the potentially stale `joinedMembersCount` summary count

# Changes in PG Rust components kotlin 1.0.1 (03-2026)

Upstream merge ✨:

- Base update to 26.03.05 (https://github.com/matrix-org/matrix-rust-components-kotlin/releases/tag/sdk-v26.03.05) for element-x-android v26.03.2

# Changes in PG Rust components kotlin 1.0.0 (03-2026)

Upstream merge ✨:

- Base update to v26.03.0 (https://github.com/matrix-org/matrix-rust-components-kotlin/releases/tag/sdk-v26.03.0) for element-x-android v26.03.0

# Changes in PG Rust sdk 0.2.15

Improvements 🙌:

- improves hidden users UX

# Changes in PG Rust sdk 0.2.11 (xx-xx-2025)

Features ✨:

- Rework HasPhoneBookConsent to PhonebookConsentType

# Changes in PG Rust components kotlin 0.2.10 (19-12-2025)

Upstream merge ✨:

- Base update to v25.12.2 (https://github.com/matrix-org/matrix-rust-components-kotlin/tree/sdk-v25.12.2) for element-x-android v25.12.0

# Changes in PG Rust sdk 0.2.9 (xx-xx-2025)

Features ✨:

- Add email to notification data

# Changes in PG Rust components kotlin 0.2.8 (02-10-2025)

Upstream merge ✨:

- Base update to v25.09.23 (https://github.com/matrix-org/matrix-rust-components-kotlin/tree/sdk-v25.09.23) for element-x-android v25.09.2

# Changes in PG Rust components kotlin 0.2.7 (xx-xx-2025)

Features ✨:

- QR login reciprocation (login on web with mobile)

# Changes in PG Rust components kotlin 0.2.5 (xx-xx-2025)

Upstream merge ✨:

Features ✨:

- Include isDirect (DM) info in element call widget url

Improvements 🙌:

Bugfix 🐛:

# Changes in PG Rust components kotlin 0.2.4 (xx-xx-2025)

Upstream merge ✨:

Features ✨:

- Get mxId of user by email using pg-pod-service

Improvements 🙌:

Bugfix 🐛:

- Remove pod-service url fetch causing slow load time, instead use matrix url override

# Changes in PG Rust components kotlin 0.2.3 (xx-xx-2025)

Upstream merge ✨:

- Base update to v25.07.28 (https://github.com/matrix-org/matrix-rust-components-kotlin/tree/sdk-v25.07.28)

Features ✨:

Improvements 🙌:

Bugfix 🐛:

# Changes in PG Rust components kotlin 0.2.2 (xx-xx-2025)

Upstream merge ✨:

Features ✨:

- Add new prop 'is_profile_initialized' to profile & ability to update the value of it.

Improvements 🙌:

Bugfix 🐛:

# Changes in PG Rust components kotlin 0.2.1 (xx-xx-2025)

Upstream merge ✨:

Features ✨:

- Expose profile data like department, function, email & phonebook consent.
- Make function & phonebook consent editable.

Improvements 🙌:

Bugfix 🐛:

# Changes in PG Rust components kotlin 0.2.0 (xx-xx-2025)

Upstream merge ✨:

Features ✨:

- Method for getting the pod_service url from the matrix client (from well-known)

Improvements 🙌:

Bugfix 🐛:

# Changes in PG Rust components kotlin 0.1.0 (xx-xx-2025)

Upstream merge ✨:

Features ✨:

- Extra property for room creation to set initial state of displayname for non-phonebook users
- Method to set initial state of displayname for non-phonebook users for existing rooms

Improvements 🙌:

Bugfix 🐛:

# Changes in PG Rust components kotlin 0.0.1 (xx-xx-2025)

Upstream merge ✨:

- Base update to v25.06.10 (https://github.com/matrix-org/matrix-rust-components-kotlin/tree/sdk-v25.06.10)

Features ✨:

- Use of custom pg-rust-sdk 0.0.1

Improvements 🙌:

- Make aar file deployable to our own Gitlab repo.

Bugfix 🐛:
