using CUDAnative
using CuArrays
a=cu(rand(5))

function findmaxelement(a)
  i=threadIdx().x
  @atomic a[i]+=5.0f0
  return nothing
end

@cuda threads=5 findmaxelement(a)