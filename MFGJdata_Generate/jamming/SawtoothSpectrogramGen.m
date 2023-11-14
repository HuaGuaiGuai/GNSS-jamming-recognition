function SawtoothSpectrogramGen(jsr_range,f_range,f_num,sweep_range,sweep_num,fs,T,gnss_signal,P_s_dBW,noise,root_path,...
                                subfile_path,num_per_type,res)
    img_index = 1;
    t = 0:1/fs:T-(1/fs);
    for j = 1:f_num  
        close all;
        f = f_range(1) + rand()*(f_range(2)-f_range(1));
        for i = 1:sweep_num
            num_period = sweep_range(1) + round(rand()*(sweep_range(2)-sweep_range(1)));
            for jsr = jsr_range(1):jsr_range(2)
                P_j_dBW = jsr + P_s_dBW;
                P_j = 10^(P_j_dBW/10); 
                jamming = SawtoothChirpGen(f,num_period,P_j,fs,T);
                r = gnss_signal + jamming + noise;
                fig = figure;
                pspectrum(r,t,'spectrogram','TimeResolution',2.5e-6,'OverlapPercent',99,'Leakage',0.90);
                axis off;
                title('');
                colorbar('off');
                image_name = sprintf('%s%simage%05d_%02d%s_jsr%02d.png',root_path,subfile_path,img_index,7,'Sawtooth',jsr);
                exportgraphics(fig,image_name,'Resolution',res);
                img_index = img_index + 1;
                close all;
                if img_index > num_per_type
                    close all;
                    fprintf('Generate %d sheet of Sawtooth spectrogram\r',img_index-1);
                    return;
                end
            end
        end
    end  
end

function jamming = SawtoothChirpGen(bandwidth,num_period,power,fs,T)
% Function: Generate a Sawtooth Chirp Interference Signal
%input:    bandwidth --> The one-sided bandwidth of the signal sweep, in Hz.
%          num_period --> Number of sweeps in 100us
%          power --> Signal power, unit: W
%          fs --> Sampling rate, unit: Hz
%          T --> Sampling time, unit: s

    t = 0:1/fs:T-(1/fs); 
    
    f0 = -bandwidth; % Sweep Start Frequency
    fe = bandwidth; % Sweep cutoff frequency

    chirp_wave = chirp(mod(t,T/num_period),f0,T/num_period,fe,'linear',0) +...
                 1j * chirp(mod(t,T/num_period),f0,T/num_period,fe,'linear',-90);
    square_wave = sqrt(power/2)*square(2*pi/(T/num_period)*t,100)+sqrt(power/2);
    jamming = chirp_wave .* square_wave;
end

