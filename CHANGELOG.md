## [Unreleased]

## [0.0.4] - 2023-08-16

- Implement sample collection by sending samples to gem.sh endpoint
- Introduce Litejob to enqueue samples to be collected async
- Updates to `SampleCall`
  - Split up `gem_and_version` to `gem` and `version` in `SampleCall`
  - Also collect `application_name` and `type_fusion_version` with `SampleCall`
  - Change `Tracepoint` API from `:call` to `:return` to also collect `return_value` in `SampleCall`
- Introduce `endpoint` and `application_name` configs

## [0.0.3] - 2023-08-13

- Introduce `TypeFusion::Middleware` to allow type-sampling in Rack-powered apps
- Introduce `TypeFusion::Railtie` to automatically setup type-sampling in Rails apps
- Introduce `TypeFusion::Config` to control sampling
  - Add `config.type_sample_call_rate` config
  - Add `config.type_sample_request` config
  - Add `config.type_sample_tracepoint_path` config

## [0.0.2] - 2023-08-12

- Initial Proof-of-Concept release
- Implementation of the `TypeFusion::Sampler` class

## [0.0.1] - 2023-08-11

- Initial release
