function TickSpectrogramGen(jsr_range,sweep_range,sweep_num,fs,T,gnss_signal,P_s_dBW,noise,root_path,subfile_path,num_per_type,res)
    img_index = 1;
    t = 0:1/fs:T-(1/fs);
    for i = 1:sweep_num
        close all;
        num_period = sweep_range(1) + round(rand()*(sweep_range(2)-sweep_range(1)));
        for jsr = jsr_range(1):jsr_range(2)
            P_j_dBW = jsr + P_s_dBW;  
            P_j = 10^(P_j_dBW/10); 
            jamming = TickChirp1Gen(num_period,P_j,fs,T);
            r = gnss_signal + jamming + noise;
            fig = figure;
            pspectrum(r,t,'spectrogram','TimeResolution',2.5e-6,'OverlapPercent',99,'Leakage',0.90);
            axis off;
            title('');
            colorbar('off');
            image_name = sprintf('%s%simage%05d_%02d%s_jsr%02d.png',root_path,subfile_path,img_index,8,'Tick',jsr);
            exportgraphics(fig,image_name,'Resolution',res);
            img_index = img_index + 1;
            close all;
            if img_index > num_per_type
                close all;
                fprintf('Generate %d sheet of Tick spectrogram\r',img_index-1);
                return;
            end
        end
    end    
end

function jamming = TickChirp1Gen(num_period,power,fs,T)
% Function: Generate a Tick Chirp Interference Signal
% input:   num_period --> Number of sweeps in 100us
%          power --> Signal power, unit: W
%          fs --> Sampling rate, unit: Hz
%          T --> Sampling time, unit: s

    t = 0:1/fs:T-(1/fs); 

    chirp_wave_1 = chirp(mod(t,T/num_period/12),-6e6,T/num_period/12,-7e6,'linear',0) +...
                    1j * chirp(mod(t,T/num_period/12),-6e6,T/num_period/12,-7e6,'linear',-90);

    chirp_wave_2 = chirp(mod(t,T/num_period/6),-9e6,T/num_period/6,-7e6,'linear',0) +...
                    1j * chirp(mod(t,T/num_period/6),-9e6,T/num_period/6,-7e6,'linear',-90);
    delay2= floor(0.5*(T/num_period/6)*fs);
    chirp_wave_2 = [zeros(1,delay2) chirp_wave_2];
    chirp_wave_2 = chirp_wave_2(1:length(t));

    chirp_wave_3 = chirp(mod(t,T/num_period/12),-2e6,T/num_period/12,-3e6,'linear',0) +...
                    1j * chirp(mod(t,T/num_period/12),-2e6,T/num_period/12,-3e6,'linear',-90);

    chirp_wave_4 = chirp(mod(t,T/num_period/6),-5e6,T/num_period/6,-3e6,'linear',0) +...
                    1j * chirp(mod(t,T/num_period/6),-5e6,T/num_period/6,-3e6,'linear',-90);
    delay4 = floor(2*(T/num_period/6)*fs);
    chirp_wave_4 = [zeros(1,delay4) chirp_wave_4];
    chirp_wave_4 = chirp_wave_4(1:length(t));

    chirp_wave_5 = chirp(mod(t,T/num_period/12),3e6,T/num_period/12,2e6,'linear',0) +...
                    1j * chirp(mod(t,T/num_period/12),3e6,T/num_period/12,2e6,'linear',-90);

    chirp_wave_6 = chirp(mod(t,T/num_period/6),0,T/num_period/6,2e6,'linear',0) +...
                    1j * chirp(mod(t,T/num_period/6),0,T/num_period/6,2e6,'linear',-90);
    delay6 = floor(3.5*(T/num_period/6)*fs);
    chirp_wave_6 = [zeros(1,delay6) chirp_wave_6];
    chirp_wave_6 = chirp_wave_6(1:length(t));

    chirp_wave_7 = chirp(mod(t,T/num_period/12),7e6,T/num_period/12,6e6,'linear',0) +...
                    1j * chirp(mod(t,T/num_period/12),7e6,T/num_period/12,6e6,'linear',-90);

    chirp_wave_8 = chirp(mod(t,T/num_period/6),4e6,T/num_period/6,6e6,'linear',0) +...
                    1j * chirp(mod(t,T/num_period/6),4e6,T/num_period/6,6e6,'linear',-90);
    delay8 = floor(5*(T/num_period/6)*fs);
    chirp_wave_8 = [zeros(1,delay8) chirp_wave_8];
    chirp_wave_8 = chirp_wave_8(1:length(t));

    square_wave_1 = sqrt(power/2)*square(2*pi/(T/num_period)*t,100/12)+sqrt(power/2);

    square_wave_2 = sqrt(power/2)*square(2*pi/(T/num_period)*t,100/6)+sqrt(power/2);
    square_wave_2 = [zeros(1,delay2) square_wave_2];
    square_wave_2 = square_wave_2(1:length(t));

    delay3 = floor(3*(T/num_period/12)*fs);
    square_wave_3 = [zeros(1,delay3) square_wave_1];
    square_wave_3 = square_wave_3(1:length(t));

    square_wave_4 = sqrt(power/2)*square(2*pi/(T/num_period)*t,100/6)+sqrt(power/2);
    square_wave_4 = [zeros(1,delay4) square_wave_4];
    square_wave_4 = square_wave_4(1:length(t));

    delay5 = floor(6*(T/num_period/12)*fs);
    square_wave_5 = [zeros(1,delay5) square_wave_1];
    square_wave_5 = square_wave_5(1:length(t));

    square_wave_6 = sqrt(power/2)*square(2*pi/(T/num_period)*t,100/6)+sqrt(power/2);
    square_wave_6 = [zeros(1,delay6) square_wave_6];
    square_wave_6 = square_wave_6(1:length(t));

    delay7 = floor(9*(T/num_period/12)*fs);
    square_wave_7 = [zeros(1,delay7) square_wave_1];
    square_wave_7 = square_wave_7(1:length(t));

    square_wave_8 = sqrt(power/2)*square(2*pi/(T/num_period)*t,100/6)+sqrt(power/2);
    square_wave_8 = [zeros(1,delay8) square_wave_8];
    square_wave_8 = square_wave_8(1:length(t));

    jamming = chirp_wave_1 .* square_wave_1 + chirp_wave_2 .* square_wave_2 + chirp_wave_3 .* square_wave_3 + chirp_wave_4 .* square_wave_4 + ...
                chirp_wave_5 .* square_wave_5 + chirp_wave_6 .* square_wave_6 + chirp_wave_7 .* square_wave_7 + chirp_wave_8 .* square_wave_8;
end

