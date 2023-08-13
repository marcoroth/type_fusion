# frozen_string_literal: true

require "nokogiri"
require_relative "lib/type_fusion"

TypeFusion.config do |config|
  config.type_sample_call_rate = 1.0

  config.type_sample_tracepoint_path = lambda do |tracepoint_path|
    tracepoint_path.include?("nokogiri")
  end
end

TypeFusion.with_sampling do
  Nokogiri.parse("<h1></h1>")
end

puts TypeFusion::Sampler.instance.samples
puts TypeFusion::Sampler.instance.to_s
