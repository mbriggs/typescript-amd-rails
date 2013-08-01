require 'tilt'

module TypeScript
  class TypeScriptTemplate < ::Tilt::Template
    self.default_mime_type = 'application/javascript'

    def prepare;
    end

    def evaluate(scope, locals, &block)
      path = template.identifier.gsub(/['\\]/, '\\\\\&')
      @output ||= TypeScript::Compile.compile(TypeScript.inject_references(data), path)
    end
  end

  def self.inject_references(code)
    refs = create_refs(Dir.glob(::Rails.root.to_s + '/references/**/*.d.ts'))
    [refs, code].join("\n")
  end

  def self.create_refs(*paths)
    paths.flatten.map { |r| "/// <reference path=\"#{r}\"/>" }.join("\n")
  end
end
