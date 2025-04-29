Changelog
All notable changes to the layerx_generator package are documented in this file. The format follows Keep a Changelog, and the project adheres to Semantic Versioning.
[1.0.5] - 2025-04-29
Added

LocationService for retrieving user location using geolocator and permission_handler.
ApiResponseHandler for standardized API response processing with GetX integration.
LoggerService for consistent logging across services.
New body models: DriverSignupBodyModel, GarageSignupBodyModel, AddCarBodyModel, BuyCarRequestModel.
Dynamic ApiResponse<T> model for flexible API data parsing.

Changed

Updated HttpsCalls with advanced multipart request handling for driver profiles, garage profiles, car CRUD operations, and buy requests.
Standardized repository pattern with AuthRepository and DataRepository using ApiResponseHandler.
Corrected naming conventions (e.g., AppUrls instead of ApiUrls for consistency).
Updated dependencies: geolocator: ^10.0.0, permission_handler: ^10.0.0.
Improved generator logic and documentation for scalability.

[1.0.4] - 2025-03-15
Changed

Optimized HttpsCalls retry logic for better performance.
Improved error handling in SharedPreferencesService.
Updated documentation for clarity and added usage examples.
Minor bug fixes in directory generation logic.

[1.0.3] - 2025-02-20
Added

Support for custom widget generation in widgets/ directory.
Basic unit tests for HttpsCalls and SharedPreferencesService.

Changed

Refined MessageExtractor to handle edge cases in JSON parsing.
Updated pubspec.yaml to include stricter dependency constraints.

[1.0.2] - 2025-01-10
Fixed

Fixed path handling issues on Windows for directory generation.
Resolved null safety warnings in generated code.

Changed

Improved README.md with detailed setup instructions.
Updated flutter_screenutil dependency to ^5.0.0.

[1.0.1] - 2024-12-01
Added

MessageExtractor service for parsing API response messages.
Initial support for repository generation (example_repo.dart).

Fixed

Minor bug in AppRoutes configuration generation.

[1.0.0] - 2024-11-15
Added

Stable release with full MVVM directory structure generation.
HttpsCalls service for HTTP requests with retry and timeout handling.
SharedPreferencesService for local storage management.
GetX integration for state management and navigation.
flutter_screenutil for responsive design support.
Configuration files: AppColors, AppRoutes, AppUrls, etc.

Changed

Refactored generator logic for better modularity.
Improved error handling during directory creation.

[0.0.3] - 2024-10-20
Added

Basic configuration files: app_colors.dart, app_routes.dart.
Support for AppWidget and main.dart generation.

Fixed

Fixed directory path resolution for cross-platform compatibility.

[0.0.2] - 2024-10-05
Added

Initial pubspec.yaml generation with core dependencies.
Basic documentation in README.md.

Fixed

Resolved issues with recursive directory creation.

[0.0.1] - 2024-09-15
Added

Initial release of layerx_generator.
Basic directory structure generation for MVVM under lib/app/.
Support for generating config/, mvvm/, and services/ directories.

