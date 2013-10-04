Dynamo.under_test(Rinket.Dynamo)
Dynamo.Loader.enable
ExUnit.start

defmodule Rinket.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
    :ok
  end
end
