clc
clear
close all

% General Parameter Configuration
fs = 40e6; % The sampling rate is fixed at 40MHz.
T = 100e-6; % The sampling window length is 100 microseconds.
t = 0:1/fs:T-(1/fs); 

% GNSS Signal Parameter Configuration
modulation = 'L1CA';
prn_chips = 1023; % The prn_chips and prn_time jointly determine the rate of the CA code, with 1023 chips generated in 1ms, resulting in a chip rate of 1.023MHz.
prn_time = 1e-3;
n_periods = 0.1; % Determining the length of the CA code, prn_time * n_periods = 1e-3 * 0.1 = 100e-6, which is equal to 100 microseconds.
f_L1 = 1575.42e6; % The frequency of the GPS L1 carrier is 1575.42MHz.
P_s_dBW = -157; % GNSS signal power, unit: dBW.  
P_s = 10^(P_s_dBW/10); % GNSS signal power, unit: watts.

% Noise Parameter Configuration
bandwidth = 20e6; % One-Sided Bandwidth of Noise.
n0_dBW = -205; % One-Sided Power Spectral Density of Noise, unit: dBW/Hz.
n0 = 10^(n0_dBW/10); % Power Spectral Density of Noise, unit: W/Hz.

% Interference Signal Parameter Configuration
root_path = 'your_traindata_path'; % Root Directory of the Dataset
resolution = 50; % Spectrogram Resolution
jsr_range = [15,50]; % Range of JSR
num_per_type = input('please input the number of spectrogram for each type of jamming:'); % Number of Samples for Each Type of Interference

% 00Clean
img_num = num_per_type;

% 01CWI
f_range_cwi = [-10e6,10e6]; 
f_num_cwi = ceil(num_per_type/(jsr_range(2)-jsr_range(1)+1));

% 02DME
sweep_num_dme = 3;
f_range_dme = [-10e6,10e6];
f_num_dme = ceil(num_per_type/sweep_num_dme/(jsr_range(2)-jsr_range(1)+1));

% 03HookedSawtooth
sweep_range_hooksaw = [2,10];
sweep_num_hooksaw = 5;
f_range_hooksaw = [1e6,20e6];
f_num_hooksaw = ceil(num_per_type/sweep_num_hooksaw/(jsr_range(2)-jsr_range(1)+1));

% 04Linear 
sweep_range_w= [2,16];
sweep_num_w = 6;
f_range_w = [1e6,20e6];
f_num_w = ceil(num_per_type/(jsr_range(2)-jsr_range(1)+1));

% 05Triangular
sweep_range_tri = [2,10];
sweep_num_tri = 5;
f_range_tri = [1e6,20e6];
f_num_tri = ceil(num_per_type/sweep_num_tri/(jsr_range(2)-jsr_range(1)+1));

% 06TriangularWave
sweep_range_triw = [2,10];
sweep_num_triw = 5;
f_range_triw = [1e6,20e6];
f_num_triw =ceil(num_per_type/sweep_num_tri/(jsr_range(2)-jsr_range(1)+1));

% 07Sawtooth
sweep_range_saw = [2,10];
sweep_num_saw = 5;
f_range_saw = [1e6,20e6];
f_num_saw = ceil(num_per_type/sweep_num_saw/(jsr_range(2)-jsr_range(1)+1));

% 08Tick
sweep_range_tick = [2,10];
sweep_num_tick = ceil(num_per_type/(jsr_range(2)-jsr_range(1)+1));

% 9DSSS
f_range_dsss = [-10e6,10e6];
f_num_dsss = ceil(num_per_type/(jsr_range(2)-jsr_range(1)+1));

% 10NBFM
f_range_nbfm = [0.1e6,2e6];
f_num_nbfm = ceil(num_per_type/(jsr_range(2)-jsr_range(1)+1));

% 11BLGNI
f_range_blgni = [6e6,20e6];
f_num_blgni = ceil(num_per_type/(jsr_range(2)-jsr_range(1)+1));


% Generate GNSS Signals
[I,Q] = GNSSsignalgen(1,modulation,fs,n_periods); % C/A Code
ca_code = I+1j*Q;
ca_code = ca_code.'; % Matrix Transposition
navigation_data = ones(size(ca_code)); % Navigation Information, Fixed Transmission of 1.
L1_carrier = sqrt(P_s/2)*exp(1j*2*pi*f_L1*t); % Complex L1 Carrier (Other Interferences Use Complex Carriers)
gnss_signal = ca_code.*navigation_data.*L1_carrier;

% Generate Additive Gaussian White Noise.
noise = wgn(1,length(t),n0*bandwidth,'linear');

% Generation of interfering signalsea
CleanSpectrogramGen(img_num,modulation,n_periods,P_s,f_L1,fs,T,n0,bandwidth,root_path,'00Clean/',resolution);
CWISpectrogramGen(jsr_range,f_range_cwi,f_num_cwi,fs,T,gnss_signal,P_s_dBW,noise,root_path,'01CWI/',num_per_type,...
                  resolution);
DMEPulseSpectrogramGen(jsr_range,f_range_dme,f_num_dme,sweep_num_dme,fs,T,gnss_signal,P_s_dBW,noise,root_path,...
                       '02DME/',num_per_type,resolution);
HookedSawtoothSpectrogramGen(jsr_range,f_range_hooksaw,f_num_hooksaw,sweep_range_hooksaw,sweep_num_hooksaw,fs,...
                             T,gnss_signal,P_s_dBW,noise,root_path,'03HookedSawtooth/',num_per_type,resolution);
WideSweepSpectrogramGen(jsr_range,f_range_w,f_num_w,sweep_range_w,sweep_num_w,fs,T,gnss_signal,P_s_dBW,...
                        noise,root_path,'04Linear/',4,'Linear',num_per_type,resolution);
TriangularSpectrogramGen1(jsr_range,f_range_tri,f_num_tri,sweep_range_tri,sweep_num_tri,fs,T,gnss_signal,P_s_dBW,...
                            noise,root_path,'05Triangular/',num_per_type,resolution);
SawtoothSpectrogramGen(jsr_range,f_range_saw,f_num_saw,sweep_range_saw,sweep_num_saw,fs,T,gnss_signal,P_s_dBW,...
                       noise,root_path,'07Sawtooth/',num_per_type,resolution);
TickSpectrogramGen(jsr_range,sweep_range_tick,sweep_num_tick,fs,T,gnss_signal,P_s_dBW,noise,root_path,'08Tick/',...
                   num_per_type,resolution);
DSSSSpectrogramGen(jsr_range,f_range_dsss,f_num_dsss,fs,T,gnss_signal,P_s_dBW,noise,root_path,'09DSSS/',num_per_type,...
                   resolution);
NBFMSpectrogramGen(jsr_range,f_range_nbfm,f_num_nbfm,fs,T,gnss_signal,P_s_dBW,noise,root_path,'10NBFM/',num_per_type,resolution);
BLGNISpectrogramGen(jsr_range,f_range_blgni,f_num_blgni,fs,T,gnss_signal,P_s_dBW,noise,root_path,'11BLGNI/',num_per_type,resolution);
L1_carrier = sqrt(P_s)*sin(2*pi*f_L1*t); % Real L1 carriers (only TriangulaerWaveChirp uses real carriers)
gnss_signal = ca_code.*navigation_data.*L1_carrier;
TriangularWaveSpectrogramGen(jsr_range,f_range_triw,f_num_triw,sweep_range_triw,sweep_num_triw,fs,T,gnss_signal,...
                             P_s_dBW,noise,root_path,'06TriangularWave/',num_per_type,resolution);
                         
                         
