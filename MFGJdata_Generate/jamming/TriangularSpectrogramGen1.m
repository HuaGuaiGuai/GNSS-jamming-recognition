function TriangularSpectrogramGen1(jsr_range,f_range,f_num,sweep_range,sweep_num,fs,T,gnss_signal,P_s_dBW,noise,root_path,...
                                  subfile_path,num_per_type,res)
    img_index = 1;
    t = 0:1/fs:T-(1/fs);
    for j = 1:f_num  
        close all;
        f = f_range(1) + rand()*(f_range(2)-f_range(1));
        for i = 1:sweep_num
            num_period = sweep_range(1) + round(rand()*(sweep_range(2)-sweep_range(1)));
            a = round(rand(1,1)*80)+10;
            for jsr = jsr_range(1):jsr_range(2)
                P_j_dBW = jsr + P_s_dBW;   
                P_j = 10^(P_j_dBW/10); 
                jamming = TriangularChirpGen1(f,num_period,P_j,fs,T,a);
                r = gnss_signal + jamming + noise;
                fig = figure;
                pspectrum(r,t,'spectrogram','TimeResolution',2.5e-6,'OverlapPercent',99,'Leakage',0.90);
                axis off;
                title('');
                colorbar('off');
                image_name = sprintf('%s%simage%05d_%02d%s_jsr%02d.png',root_path,subfile_path,img_index,5,'Triangular',jsr);
                exportgraphics(fig,image_name,'Resolution',res);
                img_index = img_index + 1;
                close all;
                if img_index > num_per_type
                    close all;
                    fprintf('Generate %d sheet of Triangular spectrogram\r',img_index-1);
                    return;
                end
            end
        end
    end
end
function jamming = TriangularChirpGen1(bandwidth,num_period,power,fs,T,rate)
% Function: Generating a Triangular Chirp Interference Signal
% input:   bandwidth --> Unilateral bandwidth of the signal sweep
%          num_period --> Number of sweeps in 100us
%          power --> Signal power, unit: W
%          fs --> Sampling rate, unit: Hz
%          T --> Sampling time, unit: s
%          rate --> Percentage of time spent up-sweeping
    t = 0:1/fs:T-(1/fs); 
    
    f0 = -bandwidth; % Sweep Start Frequency
    fe = bandwidth; % Sweep cutoff frequency
    udr = rate/(100-rate);

    chirp_wave_up = chirp(mod(t,T/num_period),f0,udr*T/num_period/(1+udr),fe,'linear',0) +...
                1j * chirp(mod(t,T/num_period),f0,udr*T/num_period/(1+udr),fe,'linear',-90);
    chirp_wave_down = chirp((mod(t,T/num_period)-udr*T/num_period/(1+udr)),fe,T/num_period/(1+udr),f0,'linear',0) +...
                1j * chirp((mod(t,T/num_period)-udr*T/num_period/(1+udr)),fe,T/num_period/(1+udr),f0,'linear',-90);
    square_wave_up = sqrt(power/2)*square(2*pi/(T/num_period)*t,(udr/(1+udr))*100)+sqrt(power/2);
    square_wave_down = -sqrt(power/2)*square(2*pi/(T/num_period)*t,(udr/(1+udr))*100)+sqrt(power/2);
    jamming = chirp_wave_up .* square_wave_up + chirp_wave_down .* square_wave_down;
end

