function snr = SNR(sub,FCdir,boldruns)

tcfull = [];

for i=1:boldruns
    bold = read_4dfpimg([FCdir '/' sub '/bold' num2str(i) '/' sub '_b' num2str(i) '_faln_dbnd_xr3d_atl.4dfp.img']);
    tcfull = [tcfull bold];
end

tc_mean = mean(tcfull,2);
tc_sd = std(tcfull,0,2);

snr = tc_mean./tc_sd;

write_4dfpimg(snr,[FCdir '/SNR/' sub '_SNR.4dfp.img'],'littleendian');
write_4dfpifh([FCdir '/SNR/' sub '_SNR.4dfp.img'],1,'littleendian');