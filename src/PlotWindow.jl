let
  plane=1
global function PlotWindow(p_open::Ref{Bool})
                    
          CImGui.Begin("Plot", p_open, window_flags) || (CImGui.End(); return)
          img_width=CImGui.GetWindowWidth()-120.0f0
          img_height=CImGui.GetWindowHeight()-270.0f0
          
          
          CImGui.SameLine()
          @cstatic X=Cfloat[-10.0, 0.20, 10.0] Y=Cfloat[-10, 0.20, 10.0] Yplane=Cint(1) fieldType=Cint(0)  begin
              if @isdefined B
                Bplane=Cfloat.(B[:,Yplane]/pi)
                if @isdefined E 
                  Eplane=Cfloat.(E[:,Yplane]*0.57735026919)
                  CImGui.SameLine();
                  @c CImGui.Combo("Field type", &fieldType, "Magnetic Field\0Electric Field\0");
                  Plot = fieldType == 0 ? Bplane : Eplane
                  text = fieldType == 0 ? "magnetic" : "electric"
                  unit = fieldType == 0 ? "A/m" : "kV/m"
                  maxval=maximum(Plot)
                else
                  Plot=Bplane
                  maxval=maximum(Plot)
                  text="magnetic"
                  unit="A/m"
                end
                if @c CImGui.VSliderInt("##v", ImVec2(bar_width,img_height), &Yplane, 1, length(y), @sprintf("%g m",y[Yplane]))
                        global plane=Yplane
                end
                CImGui.SameLine()
                io = CImGui.GetIO()
                pos = CImGui.GetCursorScreenPos()
                CImGui.PlotLines("", Plot, length(Plot), 0, @sprintf("Maximum %s field strength on height of %g m is equal %.2f %s in point X=%g m",text,y[plane],maxval,unit,x[argmax(Plot)]), 0.0, maxval*1.1, ImVec2(img_width,img_height))
                
                
                if CImGui.IsItemHovered()
                  region_x = Cint(div(length(x)*(io.MousePos.x - pos.x),img_width)+1)
                  CImGui.SetTooltip(@sprintf("X = %g m \n B = %.2f", x[region_x], Plot[region_x]))
                end

              end
              CImGui.Separator()
              CImGui.Text("Grid coordinate")
              CImGui.Separator()
              @c CImGui.InputFloat3("Xmin:dX:Xmax", X, "%g")
              @c CImGui.InputFloat3("Ymin:dY:Ymax", Y, "%g")
                

              if CImGui.Button("Generate plot")&&(!isempty(LinesCurrents)||!isempty(CablesCurrents))

                
                global x=X[1]:X[2]:X[3]
                global y=Y[1]:Y[2]:Y[3]

                XGridLength=length(x)
                YGridLength=length(y)

                Bx=fill(0.0+0im, (XGridLength,YGridLength))
                By=fill(0.0+0im, (XGridLength,YGridLength))

                B1=fill(0.0+0im, (XGridLength,YGridLength))
                B2=fill(0.0+0im, (XGridLength,YGridLength))

                global B=fill(0.0, (XGridLength,YGridLength))

                
                
                if !isempty(LinesCurrents)
                  XLines=hcat(LinesPositions...)[1,:]
                  YLines=hcat(LinesPositions...)[2,:]
                  numberOfLines=length(LinesPositions)
                  
                  C=Array{Float64}(undef,numberOfLines,numberOfLines)
                  for i=1:numberOfLines
                    GMR=ConductorThickness[i]+ConductorsSpacing[i]/cospi((NumberOfBundledConductors[i]-2)/(2*NumberOfBundledConductors[i]))
                    GMR=GMR*(NumberOfBundledConductors[i]*ConductorThickness[i]/GMR)^(1/NumberOfBundledConductors[i])
                    C[i,i]=log(4*YLines[i]/GMR)
                    for j=i+1:numberOfLines
                      C[i,j]=C[j,i]=log(sqrt(((XLines[j]-XLines[i])^2+(YLines[j]+YLines[i])^2)/((XLines[j]-XLines[i])^2+(YLines[j]-YLines[i])^2)))
                    end
                  end

                  C=inv(C)*LinesVoltages

                  

                  Ex=fill(0.0+0im, (XGridLength,YGridLength))
                  Ey=fill(0.0+0im, (XGridLength,YGridLength))

                  E1=fill(0.0+0im, (XGridLength,YGridLength))
                  E2=fill(0.0+0im, (XGridLength,YGridLength))

                  global E=fill(0.0, (XGridLength,YGridLength))
                else
                  numberOfLines=0
                end

                if !isempty(CablesCurrents)
                  XCables=hcat(CablesPositions...)[1,:]
                
                  YCables=hcat(CablesPositions...)[2,:]
                
                  numberOfCables=length(CablesPositions)

                else
                  numberOfCables=0
                end
                
                for YGrid=1:YGridLength, XGrid=1:XGridLength
                  for lineElement=1:numberOfLines
                    dx=x[XGrid]-XLines[lineElement]
                    dy=y[YGrid]-YLines[lineElement]

                    dyImage=y[YGrid]+YLines[lineElement]

                    mainFactor=1/(dx*dx+dy*dy)

                    Bx[XGrid,YGrid]+=LinesCurrents[lineElement]*mainFactor*dy
                    By[XGrid,YGrid]+=LinesCurrents[lineElement]*mainFactor*dx

                    Ex[XGrid,YGrid]+=C[lineElement]*dx*(mainFactor-1/(dx*dx+dyImage*dyImage))
                    Ey[XGrid,YGrid]+=C[lineElement]*(dy*mainFactor-dyImage/(dx*dx+dyImage*dyImage))
                  end
                  
                  for cableElement=1:numberOfCables
                    dx=x[XGrid]-XCables[cableElement]
                    dy=y[YGrid]-YCables[cableElement]

                    mainFactor=1/(dx*dx+dy*dy)

                    Bx[XGrid,YGrid]+=CablesCurrents[cableElement]*mainFactor*dy
                    By[XGrid,YGrid]+=CablesCurrents[cableElement]*mainFactor*dx
                  end

                  if numberOfCables+numberOfLines>0
                    B1[XGrid,YGrid]=(By[XGrid,YGrid]+im*Bx[XGrid,YGrid])*0.25
                    B2[XGrid,YGrid]=conj(By[XGrid,YGrid]-im*Bx[XGrid,YGrid])*0.25

                    if numberOfLines>0
                      E1[XGrid,YGrid]=(Ey[XGrid,YGrid]+im*Ex[XGrid,YGrid])*0.5
                      E2[XGrid,YGrid]=conj(Ey[XGrid,YGrid]-im*Ex[XGrid,YGrid])*0.5


                      for t=0:pi/1000:pi
                        if abs(E1[XGrid,YGrid]*exp(im*t)+E2[XGrid,YGrid]*exp(-im*t))>E[XGrid,YGrid]
                          E[XGrid,YGrid]=abs(E1[XGrid,YGrid]*exp(im*t)+E2[XGrid,YGrid]*exp(-im*t))
                        end

                        if abs(B1[XGrid,YGrid]*exp(im*t)+B2[XGrid,YGrid]*exp(-im*t))>B[XGrid,YGrid]
                          B[XGrid,YGrid]=abs(B1[XGrid,YGrid]*exp(im*t)+B2[XGrid,YGrid]*exp(-im*t))
                        end
                      end


                    else
                      for t=0:pi/1000:pi
                        if abs(B1[XGrid,YGrid]*exp(im*t)+B2[XGrid,YGrid]*exp(-im*t))>B[XGrid,YGrid]
                          B[XGrid,YGrid]=abs(B1[XGrid,YGrid]*exp(im*t)+B2[XGrid,YGrid]*exp(-im*t))
                        end
                      end
                      
                    end
                      
                  end
                end
       
            end

            end
            CImGui.End()
          end
        end