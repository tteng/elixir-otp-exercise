defmodule Servy.Views.BearsView do

  require EEx

  @templates_path Path.expand("../../../templates/bears", __DIR__)

  EEx.function_from_file :def, :index, Path.join(@templates_path, "index.eex"), [:bears]

  EEx.function_from_file :def, :show, Path.join(@templates_path, "show.eex"), [:bear]

end
