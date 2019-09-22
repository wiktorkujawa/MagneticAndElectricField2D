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
      CImGui.Columns(2, "word-wrapping")
      CImGui.TextWrapped("Route nr $(div(i,3)+1):\nPosition info:\n First Line: [X,Y]=[$(trunc(LinesPositions[i][1],digits=2)),$(trunc(LinesPositions[i][2],digits=2))] m\n Second Line: [X,Y]=[$(trunc(LinesPositions[i+1][1],digits=2)),$(trunc(LinesPositions[i+1][2],digits=2))] m\n Third Line: [X,Y]=[$(trunc(LinesPositions[i+2][1],digits=2)),$(trunc(LinesPositions[i+2][2],digits=2))] m\nBundle Conductor specification:\n Conductor Thickness=$(round(ConductorThickness[i]*100)) cm\n Number of conductor per bundle=$(Int(NumberOfBundledConductors[i]))\n Spacing=$(round(ConductorsSpacing[i]*100)) cm\nElectric Info:\n Current Value: $(abs(LinesCurrents[i]))A\n Voltage Value: $(abs(LinesVoltages[i]))V\n PhaseShift: $(trunc(rad2deg(angle(LinesCurrents[i])))) degrees "); CImGui.SameLine()

      
      CImGui.Button("X") && (deleteat!(LinesPositions,i:i+2); deleteat!(LinesCurrents,i:i+2); deleteat!(LinesVoltages,i:i+2); deleteat!(ConductorThickness,i:i+2); deleteat!(NumberOfBundledConductors,i:i+2); deleteat!(ConductorsSpacing,i:i+2))
      CImGui.NextColumn()
      CImGui.Separator()
      CImGui.PopStyleColor(3)
      CImGui.PopID()
      i+=3
    end
    if length(LinesPositions)%2!=0
      CImGui.NextColumn()
    end
    
    if length(CablesPositions)!=0 
      CImGui.Text("Cableslist:")
    end
    CImGui.Separator()
    j=1;
    while j<length(CablesPositions)
      CImGui.PushID((j+length(LinesPositions))*3-1)
      CImGui.PushStyleColor(CImGui.ImGuiCol_Button, CImGui.HSV(0.0, 100.0, 100.0))
      CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonHovered, CImGui.HSV(0.1, 0.7, 0.7))
      CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonActive, CImGui.HSV(0.1, 0.8, 0.8))
      CImGui.Columns(2, "word-wrapping")
      CImGui.TextWrapped("Route nr $(div(j,3)+1):\nPosition info:\n First Line: [X,Y]=[$(trunc(CablesPositions[j][1],digits=2)),$(trunc(CablesPositions[j][2],digits=2))] m\n Second Line: [X,Y]=[$(trunc(CablesPositions[j+1][1],digits=2)),$(trunc(CablesPositions[j+1][2],digits=2))] m\n Third Line: [X,Y]=[$(trunc(CablesPositions[j+2][1],digits=2)),$(trunc(CablesPositions[j+2][2],digits=2))] m\nElectirc info:\n Current Value: $(abs(CablesCurrents[j]))A\n PhaseShift: $(trunc(rad2deg(angle(CablesCurrents[j])))) degrees "); CImGui.SameLine()
      CImGui.Button("X") && (deleteat!(CablesPositions,j:j+2); deleteat!(CablesCurrents,j:j+2))
      CImGui.NextColumn()
      CImGui.Separator()
      CImGui.PopStyleColor(3)
      CImGui.PopID()
      j+=3
    end
  end