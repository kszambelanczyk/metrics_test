defmodule MetricsDemoWeb.Components.Shared do
  use MetricsDemoWeb, :html

  attr :current_user, :map, required: true

  def header(assigns) do
    ~H"""
    <header class="flex items-center justify-between px-6 py-4 bg-white h-[60px]">
      <div class="flex items-center">
        <button
          phx-click={navbar_clicked()}
          @click="sidebarOpen = true"
          class="text-gray-500 focus:outline-none lg:hidden"
        >
          <svg class="w-6 h-6" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M4 6H20M4 12H20M4 18H11"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
            </path>
          </svg>
        </button>
      </div>

      <div class="flex items-center gap-5">
        <div>
          Logged in as <span class="font-semibold"><%= @current_user.email %></span>
        </div>
        <div>
          <.link
            href={~p"/users/log_out"}
            method="delete"
            class="leading-6 text-zinc-900 font-semibold underline hover:text-zinc-700"
          >
            Log out
          </.link>
        </div>
      </div>
    </header>
    """
  end

  defp navbar_clicked(js \\ %JS{}) do
    js
    |> JS.toggle_class("hidden", to: "#mobile-navbar-overlay")
    |> JS.toggle_class("block", to: "#mobile-navbar-overlay")
    |> JS.toggle_class("translate-x-0 ease-out", to: "#mobile-nav-menu")
    |> JS.toggle_class("-translate-x-full ease-in", to: "#mobile-nav-menu")
  end

  attr :current_user, :map, required: true
  attr :current_page, :string, required: true

  def sidebar(assigns) do
    ~H"""
    <div
      id="mobile-navbar-overlay"
      class="fixed inset-0 z-20 transition-opacity bg-black opacity-50 lg:hidden hidden"
      phx-click={navbar_clicked()}
    >
    </div>
    <div
      id="mobile-nav-menu"
      class="fixed inset-y-0 left-0 z-30 w-64 overflow-y-auto transition duration-300 transform bg-gray-900 lg:translate-x-0 lg:static lg:inset-0 -translate-x-full ease-in"
    >
      <div class="flex items-center justify-center mt-8">
        <span class="mx-2 text-2xl font-semibold text-white">LOGO</span>
      </div>

      <nav class="mt-10">
        <.sidebar_link path={~p"/"} active={@current_page == "MainPageLive"} label="Dashboard">
          <:icon>
            <svg
              class="w-6 h-6"
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M11 3.055A9.001 9.001 0 1020.945 13H11V3.055z"
              >
              </path>
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M20.488 9H15V3.512A9.025 9.025 0 0120.488 9z"
              >
              </path>
            </svg>
          </:icon>
        </.sidebar_link>

        <.sidebar_link
          :if={@current_user.is_admin}
          path={~p"/charts"}
          active={@current_page == "ChartLive"}
          label="Charts"
        >
          <:icon>
            <svg
              class="w-6 h-6"
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M17 14v6m-3-3h6M6 10h2a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v2a2 2 0 002 2zm10 0h2a2 2 0 002-2V6a2 2 0 00-2-2h-2a2 2 0 00-2 2v2a2 2 0 002 2zM6 20h2a2 2 0 002-2v-2a2 2 0 00-2-2H6a2 2 0 00-2 2v2a2 2 0 002 2z"
              >
              </path>
            </svg>
          </:icon>
        </.sidebar_link>
      </nav>
    </div>
    """
  end

  attr :path, :string, required: true
  attr :label, :string, required: true
  attr :active, :boolean, default: false

  slot :icon

  defp sidebar_link(assigns) do
    ~H"""
    <.link
      href={@path}
      class={[
        "flex items-center px-6 py-2 mt-4",
        not @active && " text-gray-500 hover:bg-gray-700 hover:bg-opacity-25 hover:text-gray-100",
        @active && "text-gray-100 bg-gray-700 bg-opacity-25"
      ]}
    >
      <%= render_slot(@icon) %>
      <span class="mx-3"><%= @label %></span>
    </.link>
    """
  end
end
