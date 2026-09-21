# Rails 8 compatibility build

Source: chatwoot/devise-secure_password, exact previous locked revision
adcc85fe1babfe40feae73dbcae64d14fff86e69 (2.0.1), MIT license.
Runtime implementation, controllers, views and policy defaults are unchanged.
The local gemspec allows railties < 8.2 instead of < 8.0. This is a YARA
compatibility build, not an upstream claim of support. Authentication and
password policy regression tests are mandatory before merge.
