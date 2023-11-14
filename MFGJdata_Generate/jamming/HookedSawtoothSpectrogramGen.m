function HookedSawtoothSpectrogramGen(jsr_range,f_range,f_num,sweep_range,sweep_num,fs,T,gnss_signal,P_s_dBW,noise,root_path,...
                                      subfile_path,num_per_type,res)
    img_index = 1;
    t = 0:1/fs:T-(1/fs);
    for j = 1:f_num
        close all;
        f = f_range(1) + rand()*(f_range(2)-f_range(1)); 
        for i = 1:sweep_num
            % For HookedSawtooth, num_period is 2 times the number of sweeps.
            num_period = 2*(sweep_range(1)+round(rand()*(sweep_range(2)-sweep_range(1))));
            for jsr = jsr_range(1):jsr_range(2)
                P_j_dBW = jsr + P_s_dBW; 
                P_j = 10^(P_j_dBW/10);
                jamming = HookedSawtoothChirpGen(f,num_period,P_j,fs,T);
                r = gnss_signal + jamming + noise;
                fig = figure;
                pspectrum(r,t,'spectrogram','TimeResolution',2.5e-6,'OverlapPercent',99,'Leakage',0.90);
                axis off;
                title('');
                colorbar('off');
                image_name = sprintf('%s%simage%05d_%02d%s_jsr%02d.png',root_path,subfile_path,img_index,3,'HookedSawtooth',jsr);
                exportgraphics(fig,image_name,'Resolution',res);
                img_index = img_index + 1;
                close all;
                if img_index > num_per_type
                    close all;
                    fprintf('Generate %d sheet of HookedSawtooth spectrogram\r',img_index-1);
                    return;
                end
            end
        end
    end
end

function jamming = HookedSawtoothChirpGen(bandwidth,num_period,power,fs,T)
% Function: Generate a Hooked Sawtooth Chirp Interference Signal
% input:   num_period --> 2 times the number of sweeps in 100us, for example, to sweep 6 times in 100us, then num_period=12
%          power --> Signal power, unit: W
%          fs --> Sampling rate, unit: Hz
%          T --> Sampling time, unit: s

    t = 0:1/fs:T-(1/fs); 
    
    f0_1 = -2e6; % Starting frequency of 1st sweep
    fe_1 = -bandwidth; % Cutoff frequency of 1st sweep
    f0_2 = -bandwidth; % Start frequency of 2nd sweep
    fe_2 = bandwidth; % Cutoff frequency of 2nd sweep

    chirp_wave_up = chirp(mod(t,T/num_period/2),f0_1,T/num_period/2,fe_1,'linear',0) +...
                    1j * chirp(mod(t,T/num_period/2),f0_1,T/num_period/2,fe_1,'linear',-90);
    chirp_wave_down = chirp(mod(t,T/num_period/2),f0_2,T/num_period/2,fe_2,'linear',0) +...
                      1j * chirp(mod(t,T/num_period/2),f0_2,T/num_period/2,fe_2,'linear',-90);
    square_wave_fst = sqrt(power/2)*square(2*pi/(T/num_period)*t,50)+sqrt(power/2);
    square_wave_snd = -sqrt(power/2)*square(2*pi/(T/num_period)*t,50)+sqrt(power/2);
    square_wave_total = 0.5*square(2*pi/(T/num_period*2)*t,50) + 0.5;
    jamming = square_wave_total .* (chirp_wave_up .* square_wave_fst + chirp_wave_down .* square_wave_snd);
end

