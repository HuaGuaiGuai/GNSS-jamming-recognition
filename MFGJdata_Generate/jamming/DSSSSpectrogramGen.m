function DSSSSpectrogramGen(jsr_range,f_range,f_num,fs,T,gnss_signal,P_s_dBW,noise,root_path,subfile_path,num_per_type,res)
    img_index = 1; 
    t = 0:1/fs:T-(1/fs);
    for k = 1:f_num   
        close all;
        f = f_range(1) + rand()*(f_range(2)-f_range(1));
        for jsr = jsr_range(1):jsr_range(2)
            P_j_dBW = jsr + P_s_dBW; 
            P_j = 10^(P_j_dBW/10);
            jamming = DSSSGen(f,P_j,fs,T);
            r = gnss_signal + jamming + noise;
            fig = figure;
            pspectrum(r,t,'spectrogram','TimeResolution',2.5e-6,'OverlapPercent',99,'Leakage',0.90);
            axis off;
            title('');
            colorbar('off');
            image_name = sprintf('%s%simage%05d_%02d%s_jsr%02d.png',root_path,subfile_path,img_index,9,'DSSS',jsr);
            exportgraphics(fig,image_name,'Resolution',res);
            img_index = img_index + 1;
            close all;
            if img_index > num_per_type
                close all;
                fprintf('Generate %d sheet of DSSS spectrogram\r',img_index-1);
                return;
            end
        end
    end
end

function jamming = DSSSGen(fc,power,fs,T)
% Function: Generate DSSS signal
% input:   power --> Signal power, unit: W
%          fs --> Sampling rate, unit: Hz
%          T --> Sampling time, unit: s

    t = 0:1/fs:T-(1/fs);  
    

    modulation = 'L1CA';
    prn_time = 1e-3; 
    n_periods = T / prn_time;
    [I Q] = GNSSsignalgen(1,modulation,fs,n_periods);
    for i=1:length(I) 
        if I(i)==-1
            I(i)=0;
        end
    end
    ca_code = I+1j*Q;
    ca_code = ca_code.';
    

    jamming = ca_code.*sqrt(power/2).*exp(1j*2*pi*fc*t);

end

