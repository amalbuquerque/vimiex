defmodule Vimiex.State do
  defstruct mode: :insert,
            command: "",
            history: [],
            counter: 0
end
