function TriangularWaveSpectrogramGen(jsr_range,f_range,f_num,sweep_range,sweep_num,fs,T,gnss_signal,P_s_dBW,...
                                      noise,root_path,subfile_path,num_per_type,res)
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
                jamming = TriangularWaveChirpGen(f,num_period,P_j,fs,T);
                r = gnss_signal + jamming + noise;
                fig = figure;
                pspectrum(r,t,'spectrogram','TimeResolution',2.5e-6,'OverlapPercent',99,'Leakage',0.90);
                axis off;
                title('');
                colorbar('off');
                image_name = sprintf('%s%strain%05d_%02d%s_jsr%02d.png',root_path,subfile_path,img_index,6,'TriangularWave',jsr);
                exportgraphics(fig,image_name,'Resolution',res);
                img_index = img_index + 1;
                close all;
                if img_index > num_per_type
                    close all;
                    fprintf('Generate %d sheet of TriangularWave spectrogram\r',img_index-1);
                    return;
                end
            end
        end
    end
end

function jamming = TriangularWaveChirpGen(bandwith,num_period,power,fs,T)
% Function: Generate a Triangular Wave Chirp Interference Signal
% input:   bandwidth --> Unilateral bandwidth of the signal sweep
%          num_period --> Number of sweeps in 100us
%          power --> Signal power, unit: W
%          fs --> Sampling rate, unit: Hz
%          T --> Sampling time, unit: s
    
    t = 0:1/fs:T-(1/fs);
    
    B = bandwith; % Sweep bandwidth, in the range of [0,fs/2], which is determined by the VCO function.
    if B > fs/2
        B = fs/2;
    end
    
    fq = sin(2*pi/T*num_period*t); % Frequency function that determines the shape of the sweep
    % Only Triangular Wave Chirp is a real signal, so multiply sqrt(power) directly, while complex signal multiply sqrt(power/2).
    jamming = sqrt(power)*vco(fq,[0.01 B/fs]*fs,fs); 
end

