defmodule Servy.Services.GenericServer do

  def start(callback_module, init_state, name) do
    pid = spawn(__MODULE__, :loop, [init_state, callback_module])
    Process.register(pid, name)
    pid
  end

  def loop(state, callback_module) do
    receive do
      {:call, sender, message} ->
        {reply, new_state} = callback_module.handle_call(message, state)
        send(sender, {:response, reply})
        loop(new_state, callback_module)
      {:cast, message} ->
        new_state = callback_module.handle_cast(message, state)
        loop(new_state, callback_module)
      message ->
        new_state = callback_module.handle_info(message, state)
        loop(new_state, callback_module)
      # unexpected ->
      #   IO.puts("Servy.Services.GenericServer received unexpected message: #{inspect unexpected}")
      #   loop(state, callback_module)
    end
  end

def call(pid, message) do
    send(pid, {:call, self(), message})
    receive do
      {:response, response} -> response
    end
  end

  def cast(pid, message) do
    send(pid, {:cast, message})
  end

end
