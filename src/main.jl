import Pkg; 
Pkg.add(["FFTW", "DSP", "BenchmarkTools", "Plots", "LaTeXStrings", "ProgressBars"]);
using FFTW, DSP, BenchmarkTools, Plots, LaTeXStrings, ProgressBars
include("Winograd.jl")

################################################
##
## PLOT 1D AND TIME RESULTS WITH COMPLEXITY PLOT
##
################################################

# Specify threads (lasts through executions)
FFTW.set_num_threads(1)

# Create data of different input sizes, and filter with one size
filter1d = [1.0 2.0 1.0]
g = filter1d
b1 = g[1] + g[3]
b2 = 0.5*(b1 + g[2])
b3 = 0.5*(b1 - g[2])
times_fft = []
times_wino = []
batches = 20
#=
for d in tqdm(batches)
    global data1d = rand(Float64, (1, d))
    global data1d_padded = zeropad(data1d,filter1d);
    global N = Int64(length(data1d_padded) - length(filter1d) + 1);
    global output_list = zeros(1,N);
    global i = 1;
    t1 = @belapsed conv($data1d, $filter1d);
    t2 = @belapsed Winograd($data1d_padded, $filter1d, $N, $output_list, $b2, $b3, $i);
    @benchmark Winograd($data1d_padded, $filter1d, $N, $output_list, $b2, $b3, $i)
    #global times_fft = [times_fft; t1]
    #global times_wino = [times_wino; t2]
end
=#
d = 100
data1d = rand(Float64, (1, d))
data1d_padded = zeropad(data1d,filter1d);
N = Int64(length(data1d_padded) - length(filter1d) + 1);
output_list = zeros(1,N);
i = 1;
@benchmark Winograd($data1d_padded, $filter1d, $N, $output_list, $b2, $b3, $i)

#p = plot(batches, [times_fft, times_wino], title="log-log complexity plot", label=["FFT" "Winograd"], linewidth=2, xscale=:log10, yscale=:log10, minorgrid=true)
#xlabel!(L"$log_{10}(N)$")
#ylabel!(L"$log_{10}(t)$")


################################################
##
## WORK ON MATRIX FORM WINOGRAD
##
################################################

#=
filter2d = [1.0 1.0 1.0; 1.0 2.0 1.0; 1.0 1.0 1.0]
data2d = [0.0 1.0 1.0 1.0; 2.0 3.0 4.0 5.0; 1.0 2.0 3.0 4.0; 0.0 2.0 1.0 3.0]
At = [1 1 1 0; 0 1 -1 -1]
G = [1 0 0; 0.5 0.5 0.5; 0.5 -0.5 0.5; 0 0 1]
Bt = [1 0 -1 0; 0 1 1 0; 0 -1 1 0; 0 1 0 -1]

y = At*((G*filter2d*transpose(G)).*(Bt*data2d*transpose(Bt)))*transpose(At)
y2 = conv(data2d, filter2d)
print(y)
print(y2)
=#
