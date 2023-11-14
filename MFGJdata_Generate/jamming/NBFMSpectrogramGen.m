function NBFMSpectrogramGen(jsr_range,f_range,f_num,fs,T,gnss_signal,P_s_dBW,noise,root_path,subfile_path,num_per_type,res)
    img_index = 1;
    t = 0:1/fs:T-(1/fs);
    for j = 1:f_num  
        close all;
        f = f_range(1) + rand()*(f_range(2)-f_range(1));  
        for jsr = jsr_range(1):jsr_range(2)
            P_j_dBW = jsr + P_s_dBW;
            P_j = 10^(P_j_dBW/10); 
            jamming = NBFMGen(P_j,f*4,fs,T);
            r = gnss_signal + jamming + noise;
            fig = figure;
            pspectrum(r,t,'spectrogram','TimeResolution',2.5e-6,'OverlapPercent',99,'Leakage',0.90);
            axis off;
            title('');
            colorbar('off');
            image_name = sprintf('%s%simage%05d_%02d%s_jsr%02d.png',root_path,subfile_path,img_index,10,'NBFM',jsr);
            exportgraphics(fig,image_name,'Resolution',res);
            img_index = img_index + 1;
            close all;
            if img_index > num_per_type
                close all;
                fprintf('Generate %d sheet of NBFM spectrogram\r',img_index-1);
                return;
            end
        end
    end
end

function jamming = NBFMGen(power,BW_NB_Hz,fs,T)

    
    t = 0:1/fs:T-(1/fs);
    
    white_noise=randn(1,length(t));
    white_noise=(white_noise-mean(white_noise))/std(white_noise);

    fcutoff=BW_NB_Hz/2;
    B_sinc=sinc(t*fcutoff);
    jamming=filter(B_sinc,1,white_noise);
    jamming=sqrt(power)*jamming/mean(abs(jamming).^2);
    
end

