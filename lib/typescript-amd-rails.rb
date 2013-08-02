require 'ts_rails/compile'
require 'ts_rails/template_handler'

Sprockets.register_engine('.ts', TypeScript::TypeScriptTemplate)