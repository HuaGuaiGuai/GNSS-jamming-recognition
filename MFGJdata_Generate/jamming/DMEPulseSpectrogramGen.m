function DMEPulseSpectrogramGen(jsr_range,f_range,f_num,sweep_num,fs,T,gnss_signal,P_s_dBW,noise,root_path,subfile_path,num_per_type,res)
    img_index = 1; 
    t = 0:1/fs:T-(1/fs);
    for k = 1:f_num   
        close all;
        f = f_range(1) + rand()*(f_range(2)-f_range(1)); 
        for num_period = 1:sweep_num
            for jsr = jsr_range(1):jsr_range(2)
                P_j_dBW = jsr + P_s_dBW;
                P_j = 10^(P_j_dBW/10); 
                jamming = DMEPulseGen(f,num_period,P_j,fs,T);
                r = gnss_signal + jamming + noise;
                fig = figure;
                pspectrum(r,t,'spectrogram','TimeResolution',2.5e-6,'OverlapPercent',99,'Leakage',0.90);
                axis off;
                title('');
                colorbar('off');
                image_name = sprintf('%s%simage%05d_%02d%s_jsr%02d.png',root_path,subfile_path,img_index,2,'DME',jsr);
                exportgraphics(fig,image_name,'Resolution',res);
                img_index = img_index + 1;
                close all;
                if img_index > num_per_type
                    close all;
                    fprintf('Generate %d sheet of DME spectrogram\r',img_index-1);
                    return;
                end
            end
        end
    end
end

function jamming = DMEPulseGen(fc,num_period,power,fs,T)
% Function: Generate a DME Pulse signal, using Gaussian pulse pairs.
% INPUT:   fc --> Carrier frequency component, unit: Hz
%          num_period --> Number of Gaussian pulse pairs in 100 us, values [1,4].
%          power --> Signal power, unit: W
%          fs --> Sampling rate, unit: Hz
%          T --> Sampling time, unit: s

    t = 0:1/fs:T-(1/fs); 

    a = 4.5e11; % The half width of a single Gaussian pulse is fixed at 3.5us, and the total width of a pair of Gaussian pulses is about 20.5us
    delta_t = 12e-6; % The interval between two Gaussian pulses in the X-channel is fixed at 12us (the DME signal is a pulse pair).

    g = exp(-a/2*(mod(t,T/num_period)-delta_t/2).*(mod(t,T/num_period)-delta_t/2))+... % Gaussian pulse pairs
        exp(-a/2*(mod(t,T/num_period)-delta_t*3/2).*(mod(t,T/num_period)-delta_t*3/2));
    jamming = sqrt(power/2)*(g.*exp(1j*2*pi*fc*t));
end

