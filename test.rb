# frozen_string_literal: true

require "nokogiri"
require_relative "lib/type_fusion"

TypeFusion::Sampler.instance.with_sampling do
  Nokogiri.parse("<h1></h1>")
end

puts TypeFusion::Sampler.instance.samples
puts TypeFusion::Sampler.instance.to_s
