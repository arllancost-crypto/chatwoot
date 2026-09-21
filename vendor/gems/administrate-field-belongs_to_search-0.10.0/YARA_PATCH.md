# Rails 8 / Administrate 1 compatibility build

Source: published administrate-field-belongs_to_search 0.10.0, MIT license.
Implementation is unchanged. Gemspec uses local file discovery and permits
Rails < 8.2 with Administrate ~> 1.0. This is a YARA compatibility build,
not an upstream release. Admin controller, field rendering and asset build
tests must pass before merge. No authentication or authorization is removed.
