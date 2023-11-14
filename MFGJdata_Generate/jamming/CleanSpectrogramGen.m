function CleanSpectrogramGen(img_num,modulation,n_periods,P_s,f_L1,fs,T,n0,bandwidth,root_path,subfile_path,res)
    img_index = 1; 
    t = 0:1/fs:T-(1/fs);
    for i = 1:img_num
        [I,Q] = GNSSsignalgen(1,modulation,fs,n_periods); 
        ca_code = I+1j*Q;
        ca_code = ca_code.';
        navigation_data = ones(size(ca_code)); 
        L1_carrier = sqrt(P_s)*sin(2*pi*f_L1*t); 
        gnss_signal = ca_code.*navigation_data.*L1_carrier;
        noise = wgn(1,length(t),n0*bandwidth,'linear');
        r = gnss_signal + noise;
        fig = figure;
        pspectrum(r,t,'spectrogram','TimeResolution',2.5e-6,'OverlapPercent',99,'Leakage',0.90);
        axis off;
        title('');
        colorbar('off');
        image_name = sprintf('%s%simage%05d_%02d%s.png',root_path,subfile_path,img_index,0,'Clean');
        exportgraphics(fig,image_name,'Resolution',res);
        img_index = img_index + 1;
        close all;
    end
    close all;
    fprintf('Generate %d sheet of Clean spectrogram\r',img_index-1);
end
