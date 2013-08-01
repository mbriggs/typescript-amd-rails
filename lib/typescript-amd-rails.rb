require 'ts_rails/compile'
require 'ts_rails/template_handler'

ActiveSupport.on_load(:action_view) do
  Sprockets.register_engine('.ts', TypeScript::TypeScriptTemplate)
end
