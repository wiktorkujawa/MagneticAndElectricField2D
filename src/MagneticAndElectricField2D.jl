using CImGui
using CImGui.CSyntax
using CImGui.CSyntax.CStatic
using CImGui: ImVec2, ImVec4
using CImGui.GLFWBackend
using CImGui.OpenGLBackend
using CImGui.GLFWBackend.GLFW
using CImGui.OpenGLBackend.ModernGL
using Printf

include(joinpath(@__DIR__, "LineManagementWindow.jl"))
include(joinpath(@__DIR__, "PlotWindow.jl"))
include(joinpath(@__DIR__, "MainMenu.jl"))

@static if Sys.isapple()
    # OpenGL 3.2 + GLSL 150
    const glsl_version = 150
    GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, 3)
    GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, 2)
    GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE) # 3.2+ only
    GLFW.WindowHint(GLFW.OPENGL_FORWARD_COMPAT, GL_TRUE) # required on Mac
else
    # OpenGL 3.0 + GLSL 130
    const glsl_version = 130
    GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, 3)
    GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, 0)
    # GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE) # 3.2+ only
    # GLFW.WindowHint(GLFW.OPENGL_FORWARD_COMPAT, GL_TRUE) # 3.0+ only
end

# setup GLFW error callback
error_callback(err::GLFW.GLFWError) = @error "GLFW ERROR: code $(err.code) msg: $(err.description)"
GLFW.SetErrorCallback(error_callback)

# create window
window = GLFW.CreateWindow(1280, 720, "Demo")
@assert window != C_NULL
GLFW.MakeContextCurrent(window)
GLFW.SwapInterval(1)
# enable vsync

# setup Dear ImGui context
ctx = CImGui.CreateContext()

# setup Dear ImGui style
CImGui.StyleColorsDark()
# CImGui.StyleColorsClassic()
# CImGui.StyleColorsLight()



fonts_dir = joinpath(@__DIR__, "..", "fonts")
fonts = CImGui.GetIO().Fonts
CImGui.AddFontFromFileTTF(fonts, joinpath(fonts_dir, "OpenSans-Regular.ttf"), 18, C_NULL, CImGui.GetGlyphRangesCyrillic(fonts))


bar_width=40;
plane=1;

LinesPositions=Array{Float64,1}[]
LinesCurrents=ComplexF64[]
LinesVoltages=ComplexF64[]
ConductorThickness=Float64[]
NumberOfBundledConductors=Float64[]
ConductorsSpacing=Float64[]

CablesPositions=Array{Float64,1}[]
CablesCurrents=ComplexF64[]


const phaseShift=2*pi/3
# setup Platform/Renderer bindings
ImGui_ImplGlfw_InitForOpenGL(window, true)
ImGui_ImplOpenGL3_Init(glsl_version)

showMainMenu=true
clear_color = Cfloat[0.45, 0.55, 0.60, 1.00]



while !GLFW.WindowShouldClose(window)
    global showMainMenu
    global LinesPositions,LinesCurrents, LinesVoltages
    global ConductorThickness, NumberOfBundledConductors, ConductorsSpacing
    global CablesPositions,CablesCurrents
    

    global  phaseShift
    GLFW.PollEvents()
    # start the Dear ImGui frame
    ImGui_ImplOpenGL3_NewFrame()
    ImGui_ImplGlfw_NewFrame()
    CImGui.NewFrame()

    showMainMenu && @c MainMenu(&showMainMenu)
    
    # rendering
    CImGui.Render()
    GLFW.MakeContextCurrent(window)
    display_w, display_h = GLFW.GetFramebufferSize(window)
    glViewport(0, 0, display_w, display_h)
    glClearColor(clear_color...)
    glClear(GL_COLOR_BUFFER_BIT)
    ImGui_ImplOpenGL3_RenderDrawData(CImGui.GetDrawData())

    GLFW.MakeContextCurrent(window)
    GLFW.SwapBuffers(window)
end

# cleanup
ImGui_ImplOpenGL3_Shutdown()
ImGui_ImplGlfw_Shutdown()
CImGui.DestroyContext(ctx)
GLFW.DestroyWindow(window)