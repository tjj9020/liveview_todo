defmodule LiveViewTodosWeb.TodoLive do
  use Phoenix.LiveView

  alias LiveViewTodos.Todos
  alias LiveViewTodosWeb.TodoView

  def mount(_session, socket) do
    Todos.subscribe()
    {:ok, fetch(socket)}
  end

  @spec handle_info(
          {LiveViewTodos.Todos, nonempty_maybe_improper_list, any},
          Phoenix.LiveView.Socket.t()
        ) :: {:noreply, any}
  def handle_info({Todos, [:todo | _], _}, socket) do
    {:noreply, fetch(socket)}
  end

  def handle_event("add", %{"todo" => todo}, socket) do
    Todos.create_todo(todo)

    {:noreply, fetch(socket)}
  end

  def handle_event("toggle_done", id, socket) do
    todo = Todos.get_todo!(id)
    Todos.update_todo(todo, %{done: !todo.done})
    {:noreply, fetch(socket)}
  end

  def handle_event("delete", id, socket) do
    todo = Todos.get_todo!(id)
    Todos.delete_todo(todo)
    {:noreply, fetch(socket)}
  end

  defp fetch(socket) do
    assign(socket, todos: Todos.list_todos())
  end


  def render(assigns) do
    TodoView.render("todos.html", assigns)
  end
end

