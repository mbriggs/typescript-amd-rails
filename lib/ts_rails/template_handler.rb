require 'tilt'

module TypeScript
  class TypeScriptTemplate < ::Tilt::Template
    self.default_mime_type = 'application/javascript'

    def prepare;
    end

    def evaluate(scope, locals, &block)
      beginning_time = Time.now
      path = file.gsub(/['\\]/, '\\\\\&')
      Rails.logger.warn("HIHI")

      @output ||= TypeScript::Compile.compile(TypeScript.inject_references(data), path)
      end_time = Time.now
      Rails.logger.warn "!!!!!!!!!!-> Total time elapsed #{(end_time - beginning_time)*1000} milliseconds"

      @output
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
