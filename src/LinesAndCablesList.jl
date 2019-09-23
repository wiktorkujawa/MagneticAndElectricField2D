  global function LinesAndCablesList(p_open::Ref{Bool})
    if length(LinesPositions)!=0 
      CImGui.Text("Lines list:")
    end
    i=1;
    while i<length(LinesPositions)
      CImGui.PushID(i*3-1)
      CImGui.PushStyleColor(CImGui.ImGuiCol_Button, CImGui.HSV(0.0, 100.0, 100.0))
      CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonHovered, CImGui.HSV(0.1, 0.7, 0.7))
      CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonActive, CImGui.HSV(0.1, 0.8, 0.8))
      CImGui.Columns(2, "Lines and Cables Column")
      CImGui.TextWrapped(@sprintf("Route nr %d\nPosition info:\n    First Line: [X , Y]=[%.2f , %.2f] m Phase %s\n    Second Line: [X , Y]=[%.2f , %.2f] m Phase %s\n    Third Line: [X , Y]=[%.2f , %.2f] m Phase %s\nBundle Conductor specification:\n    Conductor Thickness=%g cm\n    Number of conductor per bundle=%g\n    Spacing=%g cm\nElectric Info:\n    Current Value=%g A\n    Voltage Value=%g kV\n    Phase Shift=%g degrees",div(i,3)+1,LinesPositions[i][1],LinesPositions[i][2],LinesPhaseOrder[i],LinesPositions[i+1][1],LinesPositions[i+1][2],LinesPhaseOrder[i+1],LinesPositions[i+2][1],LinesPositions[i+2][2],LinesPhaseOrder[i+2],ConductorThickness[i]*100,NumberOfBundledConductors[i],ConductorsSpacing[i]*100,abs(LinesCurrents[i]),abs(LinesVoltages[i]),rad2deg(LinesRouteShift[i]))); CImGui.SameLine()

      
      CImGui.Button("X") && (deleteat!(LinesPositions,i:i+2); deleteat!(LinesCurrents,i:i+2); deleteat!(LinesVoltages,i:i+2); deleteat!(ConductorThickness,i:i+2); deleteat!(NumberOfBundledConductors,i:i+2); deleteat!(ConductorsSpacing,i:i+2); deleteat!(LinesPhaseOrder,i:i+2); deleteat!(LinesRouteShift,i:i+2))
      CImGui.NextColumn()
      CImGui.Separator()
      CImGui.PopStyleColor(3)
      CImGui.PopID()
      i+=3
    end
    if length(LinesPositions)%2!=0
      CImGui.NextColumn()
    end
    CImGui.Separator()
    if length(CablesPositions)!=0 
      CImGui.Text("Cables list:")
    end
    CImGui.Separator()
    j=1;
    while j<length(CablesPositions)
      CImGui.PushID((j+length(LinesPositions))*3-1)
      CImGui.PushStyleColor(CImGui.ImGuiCol_Button, CImGui.HSV(0.0, 100.0, 100.0))
      CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonHovered, CImGui.HSV(0.1, 0.7, 0.7))
      CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonActive, CImGui.HSV(0.1, 0.8, 0.8))
      CImGui.Columns(2, "Lines and Cables Column")
      
      CImGui.TextWrapped(@sprintf("Route nr %d\nPosition info:\n    First Line: [X , Y]=[%.2f , %.2f] m Phase %s\n    Second Line: [X , Y]=[%.2f , %.2f] m Phase %s\n    Third Line: [X , Y]=[%.2f , %.2f] m Phase %s\nElectric Info:\n    Current Value=%g A\n    Phase Shift=%g degrees",div(j,3)+1,CablesPositions[j][1],CablesPositions[j][2],CablesPhaseOrder[j],CablesPositions[j+1][1],CablesPositions[j+1][2],CablesPhaseOrder[j+1],CablesPositions[j+2][1],CablesPositions[j+2][2],CablesPhaseOrder[j+2],abs(CablesCurrents[j]),rad2deg(CablesRouteShift[j]))); CImGui.SameLine()

      CImGui.Button("X") && (deleteat!(CablesPositions,j:j+2); deleteat!(CablesCurrents,j:j+2); deleteat!(CablesPhaseOrder,j:j+2); deleteat!(CablesRouteShift,j:j+2))
      CImGui.NextColumn()
      CImGui.Separator()
      CImGui.PopStyleColor(3)
      CImGui.PopID()
      j+=3
    end
  end