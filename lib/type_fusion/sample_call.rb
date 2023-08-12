# frozen_string_literal: true

require "json"

module TypeFusion
  SampleCall = Struct.new(:gem_and_version, :receiver, :method_name, :location, :parameters) do
    def to_s
      JSON.pretty_generate(to_h)
    end
  end
end
