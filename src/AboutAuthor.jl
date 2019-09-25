function Author(p_open::Ref{Bool})
  CImGui.Begin("About Author", p_open, CImGui.ImGuiWindowFlags_AlwaysAutoResize) || (CImGui.End(); return)
  CImGui.Text("Wiktor Kujawa is a graduated engineer from Gdansk University Of Technology\non degree course of Technical Physics with specialization in Applied Physics\nand Fomer R&D engineer in Eltel Networks Energetyka S.A.\nSkilled in programming languages:")
  CImGui.BulletText("Calculations: Julia,C, C++, CUDA, Python, Matlab/Octave, Mathematica")
  CImGui.BulletText("Web: Javascript, HTML, CSS, Docker")
  CImGui.BulletText("MCU: C(AVR), Arduino")
  CImGui.Text("Specialized in numerical analysis, creating software applications\nallowing to solve engineering and scientific problems in fields of:")
  CImGui.BulletText("Heat Flows")
  CImGui.BulletText("Electromagnetic fields")
  CImGui.BulletText("Forces occuring on overhead lines in case of short-circuit currents")
  CImGui.BulletText("Induced sheath voltages and sheath circulating currents problems")
  CImGui.End()
end
function About(p_open::Ref{Bool})
  CImGui.Begin("About ", p_open, CImGui.ImGuiWindowFlags_AlwaysAutoResize) || (CImGui.End(); return)

  CImGui.Text("Magnetic and Electric Field 2D")
  CImGui.Separator()
  CImGui.Text("Magnetic and Electric Field 2D app allow to calculate magnetic and electric field in two dimensional arrangement of long parallel lines.")
  CImGui.Text("Application was written in Julia programming language and it uses Julia CImGui wrapper.")
  CImGui.Text("Program calculations are based on chapter 7 of EPRI AC Transmission Line Reference Book-200 kV and Above, Third Edition and\nZenczak Michal Analysis of electric and magnetic fields near power transmission lines and other electrical power equipment")
  CImGui.Text("The calculations were entirely verified on a large number of tests including all examples contained in\nEPRI AC Transmission Line Reference Book-200 kV and Above, Third Edition and CYMCAP 7.2 Reference Manual and Users Guide")
  CImGui.End()
end