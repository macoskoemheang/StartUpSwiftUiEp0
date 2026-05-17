# SwiftUI Clean Architecture Starter

## Folder map

```text
StartUpSwiftUiEp0/
├── App/                 # Dependency wiring
├── Core/                # Shared networking + theme
├── Domain/Auth/         # Business models, repository contract, use cases
├── Data/Auth/           # DTOs and repository implementations
└── Presentation/        # SwiftUI screens and view models
```

## Request flow

```text
View → ViewModel → UseCase → AuthRepository → APIClient → Backend
```

The UI never talks to `URLSession` directly. The domain layer does not know about SwiftUI. The data layer can be swapped without rewriting screens.

## Offline request behavior

`ConnectivityMonitor` lives globally in `Core/Connectivity`. When a real API request starts while the device is offline, `APIClient` pauses before sending it. Once connectivity returns, all waiting requests resume automatically. The snackbar shows how many requests are waiting.

This starter intentionally does not auto-retry a request that was already sent before the connection dropped, because repeating `POST` requests can create duplicate server actions unless your backend supports idempotency keys.

## Demo vs real API

The app starts with `AppEnvironment.demo`, so the screens work immediately:

- email: `demo@swiftui.dev`
- password: `Password123`

To connect a backend:

1. Open `App/AppEnvironment.swift`
2. Replace `https://api.yourdomain.com/` with your backend base URL
3. Change `ContentView(repository: AppEnvironment.demo.authRepository)` to `AppEnvironment.live.authRepository`
4. Make your backend return this shape for login/register:

```json
{
  "id": "A UUID STRING",
  "name": "User Name",
  "email": "user@example.com",
  "token": "jwt-or-session-token"
}
```

Expected endpoints:

- `POST /auth/login`
- `POST /auth/register`
- `POST /auth/forgot-password`

## Why this structure scales

- Add a feature by repeating the same three slices: `Domain`, `Data`, `Presentation`
- Replace fake services with real services through protocols
- Unit test use cases without opening a simulator
- Keep views small and focused on rendering
