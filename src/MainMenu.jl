
include(joinpath(@__DIR__, "LineManagementWindow.jl"))
include(joinpath(@__DIR__, "AboutAuthor.jl"))

let
  showLineManagement=true
  showPlotWindow=true
  showAuthor=false
  showAbout=false

  no_titlebar = false
  no_scrollbar = false
  no_menu = false
  no_move = false
  no_resize = false
  no_collapse = false
  no_close = false
  no_nav = false
  no_background = false
  no_bring_to_front = false
  show_app_metrics=false
  show_app_style_editor=false

global function MainMenu(p_open::Ref{Bool})

  show_app_metrics && @c CImGui.ShowMetricsWindow(&show_app_metrics)
  if show_app_style_editor
      @c CImGui.Begin("Style Editor", &show_app_style_editor)
      CImGui.ShowStyleEditor()
      CImGui.End()
  end

  global window_flags = CImGui.ImGuiWindowFlags(0)
    no_titlebar       && (window_flags |= CImGui.ImGuiWindowFlags_NoTitleBar;)
    no_scrollbar      && (window_flags |= CImGui.ImGuiWindowFlags_NoScrollbar;)
    !no_menu          && (window_flags |= CImGui.ImGuiWindowFlags_MenuBar;)
    no_move           && (window_flags |= CImGui.ImGuiWindowFlags_NoMove;)
    no_resize         && (window_flags |= CImGui.ImGuiWindowFlags_NoResize;)
    no_collapse       && (window_flags |= CImGui.ImGuiWindowFlags_NoCollapse;)
    no_nav            && (window_flags |= CImGui.ImGuiWindowFlags_NoNav;)
    no_background     && (window_flags |= CImGui.ImGuiWindowFlags_NoBackground;)
    no_bring_to_front && (window_flags |= CImGui.ImGuiWindowFlags_NoBringToFrontOnFocus;)
    no_close && (p_open = C_NULL;)
    
  showLineManagement && @c LineManagementWindow(&showLineManagement)
  showPlotWindow && @c PlotWindow(&showPlotWindow)
  showAuthor && @c Author(&showAuthor)
  showAbout && @c About(&showAbout)
  
  if CImGui.BeginMainMenuBar()
    if CImGui.BeginMenu("Menu")
      @c CImGui.MenuItem("Open Line Management Window", C_NULL, &showLineManagement)
      @c CImGui.MenuItem("Show Main Result Window", C_NULL, &showPlotWindow)
        CImGui.EndMenu()
    end
    if CImGui.BeginMenu("Settings")
      if CImGui.BeginMenu("Windows Style Settings")
        @c CImGui.MenuItem("Metrics", C_NULL, &show_app_metrics)
        @c CImGui.MenuItem("Style Editor", C_NULL, &show_app_style_editor)
      CImGui.EndMenu()
      end
        CImGui.EndMenu()
    end
    if CImGui.BeginMenu("Help")
        @c CImGui.MenuItem("About", C_NULL, &showAbout)
        @c CImGui.MenuItem("Author", C_NULL, &showAuthor)
        CImGui.EndMenu()
    end
    CImGui.EndMainMenuBar()
end
end
end