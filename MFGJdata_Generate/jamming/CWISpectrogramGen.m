function CWISpectrogramGen(jsr_range,f_range,f_num,fs,T,gnss_signal,P_s_dBW,noise,root_path,subfile_path,num_per_type,res)
    img_index = 1; 
    t = 0:1/fs:T-(1/fs);
    % Generate monophonic CWI
    for k = 1:ceil(f_num/3)
        close all;
        f0 = f_range(1) + rand()*(f_range(2)-f_range(1)); % f0 obeys uniform distribution u(f_range(1),f_range(2))
        f1 = f_range(1) + rand()*(f_range(2)-f_range(1)); % f1 obeys uniform distribution u(f_range(1),f_range(2))
        f2 = f_range(1) + rand()*(f_range(2)-f_range(1)); % f2 obeys uniform distribution u(f_range(1),f_range(2))
        for jsr = jsr_range(1):jsr_range(2)   
            P_j_dBW = jsr + P_s_dBW; 
            P_j = 10^(P_j_dBW/10); 
            jamming = CWIGen(1,f0,f1,f2,P_j,fs,T);
            r = gnss_signal + jamming + noise;
            fig = figure;
            pspectrum(r,t,'spectrogram','TimeResolution',2.5e-6,'OverlapPercent',99,'Leakage',0.90);
            axis off;
            title('');
            colorbar('off');
            image_name = sprintf('%s%simage%05d_%02d%s_jsr%02d.png',root_path,subfile_path,img_index,1,'CWI',jsr);
            exportgraphics(fig,image_name,'Resolution',res);
            img_index = img_index + 1;
            close all;
            if img_index > num_per_type
                close all;
                fprintf('Generate %d sheet of CWI spectrogram\r',img_index-1);
                return;
            end
        end  
    end
    % Generating a two-tone CWI
    for k = 1:ceil(f_num/3)
        close all;
        f0 = f_range(1) + rand()*(f_range(2)-f_range(1)); % f0 obeys a uniform distribution u(f_range(1),f_range(2))
        f1 = f_range(1) + rand()*(f_range(2)-f_range(1)); % f1 obeys uniform distribution u(f_range(1),f_range(2))
        f2 = f_range(1) + rand()*(f_range(2)-f_range(1)); % f2 obeys uniform distribution u(f_range(1),f_range(2))
        for jsr = jsr_range(1):jsr_range(2)   
            P_j_dBW = jsr + P_s_dBW; 
            P_j = 10^(P_j_dBW/10); 
            jamming = CWIGen(2,f0,f1,f2,P_j,fs,T);
            r = gnss_signal + jamming + noise;
            fig = figure;
            pspectrum(r,t,'spectrogram','TimeResolution',2.5e-6,'OverlapPercent',99,'Leakage',0.90);
            axis off;
            title('');
            colorbar('off');
            image_name = sprintf('%s%simage%05d_%02d%s_jsr%02d.png',root_path,subfile_path,img_index,1,'CWI',jsr);
            exportgraphics(fig,image_name,'Resolution',res);
            img_index = img_index + 1;
            close all;
            if img_index > num_per_type
                close all;
                fprintf('Generate %d sheet of CWI spectrogram\r',img_index-1);
                return;
            end
        end    
    end
    % Generate three-tone CWI
    for k = 1:ceil(f_num/3)
        close all;
        f0 = f_range(1) + rand()*(f_range(2)-f_range(1)); % f0 obeys uniform distribution u(f_range(1),f_range(2))
        f1 = f_range(1) + rand()*(f_range(2)-f_range(1)); % f1 obeys uniform distribution u(f_range(1),f_range(2))
        f2 = f_range(1) + rand()*(f_range(2)-f_range(1)); % f2 obeys uniform distribution u(f_range(1),f_range(2))
        for jsr = jsr_range(1):jsr_range(2)   
            P_j_dBW = jsr + P_s_dBW; 
            P_j = 10^(P_j_dBW/10); 
            jamming = CWIGen(3,f0,f1,f2,P_j,fs,T);
            r = gnss_signal + jamming + noise;
            fig = figure;
            pspectrum(r,t,'spectrogram','TimeResolution',2.5e-6,'OverlapPercent',99,'Leakage',0.90);
            axis off;
            title('');
            colorbar('off');
            image_name = sprintf('%s%simage%05d_%02d%s_jsr%02d.png',root_path,subfile_path,img_index,1,'CWI',jsr);
            exportgraphics(fig,image_name,'Resolution',res);
            img_index = img_index + 1;
            close all;
            if img_index > num_per_type
                close all;
                fprintf('Generate %d sheet of CWI spectrogram\r',img_index-1);
                return;
            end
        end
    end
end

function jamming = CWIGen(type,f0,f1,f2,power,fs,T)
% Function: Generate a single-tone or multi-tone CWI interference signalS
% input:   type --> Select the type of CWI generated:type=1, Generating a monophonic CWI
%                                                    type=2, Generating a two-tone CWI
%                                                    type=3, Generate a three-tone CWI
%          f0 --> Frequency of the first signal component: Hz
%          f1 --> Frequency of the 2nd signal component: Hz
%          f2 --> Frequency of the 3rd signal component: Hz
%          power --> Signal power, unit: W
%          fs --> Sampling rate, unit: Hz
%          T --> Sampling time, unit: s

    t = 0:1/fs:T-(1/fs); 
    
    if type == 1
        jamming = sqrt(power/2)*exp(1j*2*pi*f0*t);
    elseif type == 2
        jamming = sqrt(power/2)*exp(1j*2*pi*f0*t) + sqrt(power/2)*exp(1j*2*pi*f1*t);
    elseif type == 3
        jamming = sqrt(power/2)*exp(1j*2*pi*f0*t) + sqrt(power/2)*exp(1j*2*pi*f1*t) + ...
                  sqrt(power/2)*exp(1j*2*pi*f2*t);
    end
end

