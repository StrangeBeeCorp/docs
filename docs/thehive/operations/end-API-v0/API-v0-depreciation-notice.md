# API v0 Deprecation Notice

This topic explains the deprecation of API v0 in TheHive and why you should upgrade to API v1.

## Why API v0 is being deprecated

API v0 is the original version of TheHive's API. It doesn't include many of the enhancements, performance improvements, and security features introduced in API v1.

Deprecating API v0 simplifies the codebase and enables continued development of a faster, more secure, and more capable TheHive platform.

## Who is affected

You are affected by this deprecation if any of the following apply:

* You call API endpoints that include `/v0/` or don't specify a version.
* You use the TH4PY Python client version 1.8, which relies on API v0.

These calls may occur directly or through automation, such as analyzers, responders, scripts, or connectors.

If you're unsure, run the following tests to check your setup:

## Timeline

* July 1, 2025: TH4PY v2.1, which uses API v1, becomes the officially supported version.
* TheHive 5.6 release: API v0 will be disabled by default. A configuration option will be available to temporarily re-enable it if needed.
* TheHive 5.7 release: API v0 will be deleted and will no longer be available.

## What you should do

See [Upgrade from API v0 to API v1](upgrade-from-API-v0-to-API-v1.md) for detailed instructions.

<h2>Next steps</h2>