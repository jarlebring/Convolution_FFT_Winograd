"""
    F23(d, g, b2, b3)

    # Arguments
    - `d::Array{Float}`: Array
    - `g::Array{Float}`: Array 
    - `b2::Float`: Multiplication constant
    - `b3::Float`: Multiplication constant 
    
Computes the Winograd convolution with output size 2 and filter size 3
"""
function F23(d, g, b2, b3)
    return [((d[1] - d[3]) * g[1])+((d[2] + d[3]) * b2)+((d[3] - d[2]) * b3)
     ((d[2] + d[3]) * b2)-((d[3] - d[2]) * b3)-((d[2] - d[4]) * g[3])]
end

"""
    Winograd1D(data, filter, N, output_list, b2, b3, i)

    # Arguments
    - `data::Array{Float}`: Data array to convolve
    - `filter::Array{Float}`: Filter array to convolve with 
    - `N::Integer`: Length of data
    - `output_list::Array{Float}`: Array to output convolved data into 
    - `b2::Float`: Multiplication constant
    - `b3::Float`: Multiplication constant
    - `i::Integer`: Iteration variable

    Computes the Winograd convolution with output size 2 and filter size 3. Note that 
this function works only on 1D data and filters.
"""
function Winograd1D!(d, g, N, s, b2, b3, i)
    @inline for i = 1:N-1
        s[i:i+1] = [((d[1] - d[3]) * g[1])+
        ((d[2] + d[3]) * b2)+((d[3] - d[2]) * b3)
        ((d[2] + d[3]) * b2)-
        ((d[3] - d[2]) * b3)-
        ((d[2] - d[4]) * g[3])]
    end
    return s
end