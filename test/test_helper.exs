Dynamo.under_test(Firebrick.Dynamo)
Dynamo.Loader.enable
ExUnit.start

defmodule Firebrick.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
    :ok
  end
end
