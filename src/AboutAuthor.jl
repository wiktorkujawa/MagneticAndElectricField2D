global function AboutAuthor(p_open::Ref{Bool})
  CImGui.Button("About Author")&&CImGui.OpenPopup("About Author")
  if CImGui.BeginPopupModal("About Author", C_NULL, CImGui.ImGuiWindowFlags_MenuBar)
    CImGui.Text("Lirum oPsum")

  CImGui.Button("Close") && CImGui.CloseCurrentPopup()
  CImGui.EndPopup()
end
end