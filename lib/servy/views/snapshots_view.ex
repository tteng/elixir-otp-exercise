defmodule Servy.Views.SnapshotsView do

  require EEx

  @templates_path Path.expand("../../../templates/snapshots", __DIR__)

  EEx.function_from_file :def, :index, Path.join(@templates_path, "index.eex"), [:snapshots, :location]

end
