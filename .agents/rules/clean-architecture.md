---
trigger: always_on
---

# Rule: Feature-First Clean Architecture Enforcement

## Strict Rules
1. **Directory Constraints & Structure:** The project must strictly organize code by features. The directory structure must strictly follow this pattern:
   * `lib/shared/` — Contains common utilities, generic global widgets, and core helpers used across multiple features.
   * `lib/app/features/<feature_name>/` — Every individual feature (e.g., `auth`) must contain its own isolated three-layer architecture:
     * `data/` (Models, Data Sources, Repository Implementations)
     * `domain/` (Entities, Use Cases, Repository Interfaces/Contracts)
     * `presentation/` (Cubits/Blocs, Pages, Components/Widgets)

2. **Unidirectional Dependency Flow:** Dependencies within a feature must only flow inward toward the domain layer:
   * **Domain is Independent:** Code inside `domain/` MUST NOT import anything from its sibling `data/` or `presentation/` directories.
   * **Presentation Boundary:** Code inside `presentation/` can only call Use Cases or Entities from `domain/`. It MUST NOT import from `data/`.
   * **Cross-Feature Restriction:** A feature's internal layers must never directly import internal layers of a *different* feature. Cross-feature communication must happen strictly through shared code or explicit domain interfaces.

3. **Data Encapsulation:** Data models (e.g., JSON handling, API responses) belong exclusively to the `data/` layer. They must be mapped into domain `Entities` before reaching the `presentation/` layer.

## Agent Action Checklist
Before modifying or generating files, you MUST:
1. Verify that the file path correctly aligns with either `lib/shared/` or an explicit feature inside `lib/app/features/`.
2. Inspect the file's import statements to ensure no layer boundary rules are violated (e.g., a presentation file attempting a direct import from a data folder).
3. If structural anomalies or illegal cross-layer imports are detected, halt and refactor to protect architectural integrity.