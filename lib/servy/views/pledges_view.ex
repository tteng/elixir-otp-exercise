defmodule Servy.Views.PledgesView do

  require EEx

  @templates_path Path.expand("../../../templates/pledges", __DIR__)

  EEx.function_from_file :def, :new, Path.join(@templates_path, "new.eex")

  EEx.function_from_file :def, :recent_pledges, Path.join(@templates_path, "recent_pledges.eex"), [:pledges]

end
