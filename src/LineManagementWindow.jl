include(joinpath(@__DIR__, "LinesAndCablesList.jl"))
let
  showLinesAndCablesList=true
  global function LineManagementWindow(p_open::Ref{Bool})
    CImGui.Begin("Line management", p_open, window_flags) || (CImGui.End(); return)
    

    @cstatic center=Cfloat[0.0,0.0] centerLine=Cfloat[0.0,0.0] leftLine=Cfloat[0.0,0.0] rightLine=Cfloat[0.0,0.0] formationType=Cint(1) I=Cfloat(640.0) phaseAngle=Cfloat(0.0) gapThird=Cfloat[0.0,0.0,0.0] phaseOrder=Cint(0) phaseMultiplier=Cint[0,-1,1] gapFormation=Cfloat(4.0) bundleSpacing=Cfloat(4.0) numberOfBundledConductors=Cint(1) conductorThickness=Cfloat(4.0) elementType=Cint(0) voltage=Cfloat(123.0)  begin
    @c CImGui.RadioButton("Power lines", &elementType, 0); CImGui.SameLine()
    @c CImGui.RadioButton("Undeground Cables", &elementType, 1);
              CImGui.Separator()
              CImGui.Text("Electric details")
              CImGui.Separator()
              @c CImGui.InputFloat("Current Value[A]", &I, 1.0, 1.0)
              if elementType==0  
                @c CImGui.InputFloat("Voltage Value[kV]", &voltage, 1.0, 1.0)
                CImGui.Text("Bundle specification:")
                @c CImGui.InputFloat("Conductor thickness[cm]", &conductorThickness, 1.0, 1.0)
                @c CImGui.SliderInt("Number of bundle Conductors", &numberOfBundledConductors, 1, 10)
                if numberOfBundledConductors>1
                  @c CImGui.InputFloat("Spacing between conductors[cm]", &bundleSpacing, 1.0, 1.0)
                end
              end
              @c CImGui.SliderAngle("Phase shift Angle",&phaseAngle, 0.0, 360.0)

              
              CImGui.Text("Phase Order")
              CImGui.Separator()
              @c CImGui.RadioButton("ABC", &phaseOrder, 0); CImGui.SameLine()
              @c CImGui.RadioButton("ACB", &phaseOrder, 1); CImGui.SameLine()
              @c CImGui.RadioButton("BAC", &phaseOrder, 2);
              @c CImGui.RadioButton("BCA", &phaseOrder, 3); CImGui.SameLine()
              @c CImGui.RadioButton("CAB", &phaseOrder, 4); CImGui.SameLine()
              @c CImGui.RadioButton("CBA", &phaseOrder, 5);

              if phaseOrder==0
                phaseMultiplier=0,-1,1
                phaseName=["A","B","C"]
              elseif phaseOrder==1
                phaseMultiplier=0,1,-1
                phaseName=["A","C","B"]
              elseif phaseOrder==2
                phaseMultiplier=-1,0,1
                phaseName=["B","A","C"]
              elseif phaseOrder==3
                phaseMultiplier=-1,1,0
                phaseName=["B","C","A"]
              elseif phaseOrder==4
                phaseMultiplier=1,0,-1
                phaseName=["C","A","B"]
              else
                phaseMultiplier=1,-1,0
                phaseName=["C","B","A"]
              end



              CImGui.Separator()
              CImGui.Text("Arrangement method")
              CImGui.Separator()
              @c CImGui.RadioButton("Various positions", &formationType, 0); CImGui.SameLine()
              @c CImGui.RadioButton("Flat formation", &formationType, 1); CImGui.SameLine()
              @c CImGui.RadioButton("Trefoil formation", &formationType, 2);


              if formationType==0
                @c CImGui.InputFloat2("Vertical and horizontal coordinate of (nominally)left line[m]", leftLine); 
                @c CImGui.InputFloat2("Vertical and horizontal coordinate of (nominally)center line[m]", centerLine); 
                @c CImGui.InputFloat2("Vertical and horizontal coordinate of (nominally)right line[m]", rightLine) 

              elseif formationType==1
                @c CImGui.InputFloat2("Vertical and horizontal coordinate of center line[m]", center); 
                @c CImGui.InputFloat("Gap between lines", &gapFormation, 1.0, 1.0, "%.2f")
                centerLine=center
                leftLine=center-[gapFormation,0.0]
                rightLine=center+[gapFormation,0.0]

              else
                @c CImGui.InputFloat2("Vertical and Horizontal coordinate of center of formation[m]", centerLine);
                @c CImGui.InputFloat("Spacing between lines", &gapFormation, 1.0, 1.0, "%.2f")
                centerLine=center+[0.0,gapFormation*sqrt(2)/3]
                leftLine=center-gapFormation*[0.5,sqrt(2)/6]
                rightLine=center-gapFormation*[-0.5,sqrt(2)/6]
              end

              if CImGui.Button("Add route")
                if elementType==1
                  push!(CablesPositions,leftLine,centerLine,rightLine)
                  push!(CablesCurrents,I*exp(im*(phaseMultiplier[1]*phaseShift+phaseAngle)),I*exp(im*(phaseMultiplier[2]*phaseShift+phaseAngle)),I*exp(im*(phaseMultiplier[3]*phaseShift+phaseAngle)))
                  push!(CablesPhaseOrder,phaseName[1],phaseName[2],phaseName[3])
                  push!(CablesRouteShift,phaseAngle,phaseAngle,phaseAngle)
                else
                  push!(LinesPositions,leftLine,centerLine,rightLine)
                  push!(LinesCurrents,I*exp(im*(phaseMultiplier[1]*phaseShift+phaseAngle)),I*exp(im*(phaseMultiplier[2]*phaseShift+phaseAngle)),I*exp(im*(phaseMultiplier[3]*phaseShift+phaseAngle)))
                  push!(LinesVoltages,voltage*exp(im*(phaseMultiplier[1]*phaseShift+phaseAngle)),voltage*exp(im*(phaseMultiplier[2]*phaseShift+phaseAngle)),voltage*exp(im*(phaseMultiplier[3]*phaseShift+phaseAngle)))
                  push!(LinesPhaseOrder,phaseName[1],phaseName[2],phaseName[3])
                  push!(LinesRouteShift,phaseAngle,phaseAngle,phaseAngle)


                  push!(ConductorThickness,conductorThickness/100,conductorThickness/100,conductorThickness/100)
                  push!(NumberOfBundledConductors,Float64(numberOfBundledConductors),Float64(numberOfBundledConductors),Float64(numberOfBundledConductors))
                  push!(ConductorsSpacing,bundleSpacing/100,bundleSpacing/100,bundleSpacing/100)
                  
                end
              end
            end

    CImGui.Separator()

    showLinesAndCablesList && @c LinesAndCablesList(&showLinesAndCablesList)
    
      CImGui.End()
    end
  end