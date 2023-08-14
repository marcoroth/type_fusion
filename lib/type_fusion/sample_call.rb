# frozen_string_literal: true

require "json"

module TypeFusion
  SampleCall = Struct.new(:gem_name, :gem_version, :receiver, :method_name, :application_name, :location, :type_fusion_version, :parameters) do
    def to_s
      JSON.pretty_generate(to_h)
    end

    def inspect
      "#<TypeFusion::SampleCall receiver=#{receiver.inspect} method_name=#{method_name.inspect} gem_name=#{gem_name.inspect}>"
    end
  end
end
