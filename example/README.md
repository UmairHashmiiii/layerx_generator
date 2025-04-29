LayerX Generator Example
This example demonstrates how to use the layerx_generator package to generate a LayerX directory structure.
Setup

Add layerx_generator to your pubspec.yaml:dev_dependencies:
layerx_generator: ^1.0.5


Run:flutter pub get


Generate the structure:dart run layerx_generator --path .



Generated Structure
Running the generator creates:

lib/app/config/: Configuration files.
lib/app/mvvm/: MVVM directories.
lib/app/repository/: Repositories.
lib/app/services/: Services (e.g., LoggerService, LocationService).
lib/app/widgets/: Custom widgets.

Notes

Update app_urls.dart with your API endpoints.
Add routes to app_pages.dart for navigation.

