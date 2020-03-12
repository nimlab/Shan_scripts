t function [zmat networks] = covmat(outsub,dataset,WTAdir,ROIset,tcdir,zscorecorrection,subnum,CorrCov)
%ROI sets: 
%1. WangChoiTMS = Wang 17, Choi 5, other TMS-related ROIs in Fox dataset
%2. YeoChoi = Yeo 17, Choi 5

%Creates correlation matrix for each specified subject based on WTA
%parcellation (which has already been constructed), MLP-generated seeds
%(from Shan's TargetGen.csh script), and other ROIs specified in script
%(currently including L/R sgACC sphere, L/R NA sphere, and Yeo OFC parcels
%split into medial and lateral).
%Reprocorrection option corrects for reproducibility map (1 or 0)

% Load Dependencies
addpath('~/scripts/PetersenScripts/fcimage_analysis/fcimage_analysis_v3');

if WTAdir~=0

if dataset=='Fox'
    subdir = 'Fox'
elseif dataset=='TBI'
    subdir = 'TBIDpilot'
else
    subdir = dataset;
end


outf=[WTAdir '/' outsub]; 

%mkdir(outf);
%load(['~/data/' subdir '/MLP_output/Interp_' outsub '/Test_RSNs_' outsub '.mat'],'V3_UNU');

cd(outf)
end

%make corrmat

AntiSG_Half1 = ['~/data/Fox/Analysis/TargetComparison/SplitHalf/Half1/' outsub '/Target_r10'];
AntiSG_Half2 = ['~/data/Fox/Analysis/TargetComparison/SplitHalf/Half2/' outsub '/Target_r10'];
MLP_L = ['~/data/ROIs/MLPseeds/' outsub '/' outsub '_MLP_Lseed'];
MLP_Lweighted = ['~/data/ROIs/MLPseeds/' outsub '/' outsub '_weighted_GM_target_L'];
MLP_Rweighted = ['~/data/ROIs/MLPseeds/' outsub '/' outsub '_weighted_GM_target_R'];
MLP_R = ['~/data/ROIs/MLPseeds/' outsub '/' outsub '_MLP_Rseed'];
Cone = ['~/data/ROIs/Fox/Cones/333/' outsub '_CONE'];
ConeGM = ['~/data/ROIs/Fox/Cones/333/' outsub '_CONE_GM'];
ConeSubpial = ['~/data/ROIs/Fox/Cones/333/' outsub '_CONE_subpial_ero2'];
ConeYeo = ['~/data/ROIs/Fox/Cones/333/' outsub '_CONE_YeoMask'];
sgFox = ['~/data/ROIs/Fox/sgFox_333'];
sgFoxGM = ['~/data/ROIs/Fox/sgFox_333_GM'];
AntiSG = ['~/data/Fox/Analysis/TargetComparison/sgFox/' outsub '/Target_r10'];
AntiSGfull = ['~/data/Fox/Analysis/TargetComparison/sgFull_333/' outsub '/Anti_sgFull_333_target_r10'];
AntiBothcon = ['~/data/Fox/Analysis/TargetComparison/Bothcon_333/' outsub '/Anti_Bothcon_333_target_r10'];
ConeGM = ['~/data/ROIs/Fox/Cones/333/' outsub '_CONE_GM'];
ConeSubpial = ['~/data/ROIs/Fox/Cones/333/' outsub '_CONE_subpial_ero2'];
ConeYeo = ['~/data/ROIs/Fox/Cones/333/' outsub '_CONE_YeoMask'];
sgFox = ['~/data/ROIs/Fox/sgFox_333'];
sgFoxL = ['~/data/ROIs/Fox/sgFoxL_333'];
sgFoxBilat = ['~/data/ROIs/Fox/sgFoxBilat'];
sgFoxGM = ['~/data/ROIs/Fox/sgFox_333_GM'];
sgFull = ['~/data/ROIs/Fox/sgFull_333_thresh1'];
Bothcon = ['~/data/ROIs/Fox/Bothcon_333_thresh0'];
sgFullGM = ['~/data/ROIs/Fox/sgFull_333_GM'];
FoxL = ['~/data/ROIs/Fox/FoxL'];
FoxL_GM = ['~/data/ROIs/Fox/FoxL_GM'];
FoxR = ['~/data/ROIs/Fox/FoxR'];
R_5cm = ['~/data/ROIs/Fox/R_5cm'];
L_5cm = ['~/data/ROIs/Fox/L_5cm'];
Gordon117 = ['~/data/ROIs/Gordon/single_ROIs/Parcels_711-2b_333_roi_117'];
Gordon280 = ['~/data/ROIs/Gordon/single_ROIs/Parcels_711-2b_333_roi_280'];
Gordon116 = ['~/data/ROIs/Gordon/single_ROIs/Parcels_711-2b_333_roi_116'];
Gordon279 = ['~/data/ROIs/Gordon/single_ROIs/Parcels_711-2b_333_roi_279'];
Gordon142 = ['~/data/ROIs/Gordon/single_ROIs/Parcels_711-2b_333_roi_142'];
Gordon312 = ['~/data/ROIs/Gordon/single_ROIs/Parcels_711-2b_333_roi_312'];
Gordon = ['~/data/ROIs/Gordon/single_ROIs/Parcels_711-2b_333_roi_'];
Schaefer283 = ['~/data/ROIs/Schaefer/333/Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_2mm_roi_283_333'];
Schaefer811 = ['~/data/ROIs/Schaefer/333/Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_2mm_roi_811_333'];
Schaefer807 = ['~/data/ROIs/Schaefer/333/Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_2mm_roi_807_333'];
Schaefer278 = ['~/data/ROIs/Schaefer/333/Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_2mm_roi_278_333'];
NA = ['~/data/ROIs/42/NA'];
VTA = ['~/data/ROIs/42/VTA'];
VSsup = ['~/data/ROIs/42/VSsup'];
InsulaR = ['~/data/ROIs/42/R_insula'];
InsulaL = ['~/data/ROIs/42/L_insula'];
CerebellumDot = ['~/data/ROIs/42/Cerebellum'];
GordonSalienceInsula = ['~/data/ROIs/42/GordonSalienceInsula'];
GordonSalienceDorsalCC = ['~/data/ROIs/42/GordonSalienceDorsalCC'];

Yeo = ['~/data/ROIs/Yeo/ROIs_333/Yeo7_tight_roi_'];
Yeo17 = ['~/data/ROIs/Yeo/17_ROIs_333/Yeo17_tight_roi_'];
YeoSG = ['~/data/ROIs/Yeo/17_ROIs_333/SG'];
Choi = ['~/data/ROIs/Choi/ROIs_333/Choi7_tight_roi_'];
Cerebellum = ['~/data/ROIs/BucknerCerebellum/7_ROIs_333/Buckner7_tight_roi_'];  
Wang = ['~/data/Fox/Collaborators/IndiPar/' outsub '/labels/333/Network'];
StimParcel = [13
13
13
8
16
13
17
17
16
13
13
16
17
13
11
4
8
12
8
13
7
17
16
17
13];

%networks = {'L_DAN' 'R_DAN' 'L_VAN' 'R_VAN' 'L_MOT' 'R_MOT' 'L_VIS' 'R_VIS' 'L_FPC' 'R_FPC' 'L_LAN' 'R_LAN' 'L_DMN' 'R_DMN' '~/data/' subdir '/SeedMapping/ROIS/sgACC_rois/Talairach_Coords/sgACC_rois_D10mm_-5_13_-9_10mm_reg' '~/data/' subdir '/SeedMapping/ROIS/sgACC_rois/Talairach_Coords/sgACC_rois_D10mm_6_13_-10_10mm_reg' '~/data/' subdir '/SeedMapping/Yeo/17_ROIs_liberal/mOFC' '~/data/' subdir '/SeedMapping/Yeo/17_ROIs_liberal/lOFC' '~/data/' subdir '/SeedMapping/Yeo/17_ROIs_liberal/L_MTL' '~/data/' subdir '/SeedMapping/Yeo/17_ROIs_liberal/R_MTL' '~/data/' subdir '/SeedMapping/ROIS/subcortical/subcortical_D6mm_-11_5_-6_6mm_reg' '~/data/' subdir '/SeedMapping/ROIS/subcortical/subcortical_D6mm_9_6_-7_6mm_reg' MLP_L MLP_R};
if dataset=='Fox'

%    networks = {'DAN' 'VAN' 'FPC' 'LAN' 'DMN' [Yeo '3'] [Yeo '4'] [Yeo '6'] [Yeo '5'] [Yeo '7'] [Choi '4'] [Choi '2'] [Choi '6'] [Choi '5'] [Choi '7'] sgFox [Gordon '125'] Gordon280 Gordon116 Gordon279 Gordon142 Gordon312 '~/data/ROIs/Atlases/Juelich/JuelichAmygdalaL_333' '~/data/ROIs/Atlases/Juelich/JuelichAmygdalaR_333' Gordon117 [Gordon '288'] [Gordon '112'] [Gordon '75'] [Gordon '238'] [Gordon '116'] [Gordon '84'] '~/data/ROIs/Yeo/17_ROIs_333/mOFC_noSG' '~/data/ROIs/Yeo/17_ROIs_333/ltOFC' '~/data/ROIs/Fox/rACC_Boes_333' GordonSalienceInsula GordonSalienceDorsalCC InsulaL InsulaR CerebellumDot [Cerebellum '3'] [Cerebellum '4'] [Cerebellum '2'] [Cerebellum '1'] [Cerebellum '6'] [Cerebellum '5'] [Cerebellum '7'] NA VTA VSsup FoxL FoxR L_5cm R_5cm Cone};
 %   networks = {[Wang '1'] [Wang '2'] [Wang '3'] [Wang '4'] [Wang '5'] [Wang '6'] [Wang '7'] [Wang '8'] [Wang '9'] [Wang '10'] [Wang '11'] [Wang '12'] [Wang '13'] [Wang '14'] [Wang '15'] [Wang '16'] [Wang '17'] [Choi '4'] [Choi '2'] [Choi '6'] [Choi '5'] [Choi '7'] sgFox [Gordon '123'] Gordon280 Gordon116 Gordon279 Gordon142 Gordon312 '~/data/ROIs/Atlases/Juelich/JuelichAmygdalaL_333' '~/data/ROIs/Atlases/Juelich/JuelichAmygdalaR_333' Gordon117 [Gordon '288'] [Gordon '125'] [Gordon '75'] [Gordon '238'] [Gordon '116'] [Gordon '84'] '~/data/ROIs/Yeo/17_ROIs_333/mOFC_noSG' '~/data/ROIs/Yeo/17_ROIs_333/ltOFC' '~/data/ROIs/Fox/rACC_Boes_333' GordonSalienceInsula GordonSalienceDorsalCC InsulaL InsulaR NA VTA VSsup FoxL FoxR L_5cm R_5cm Cone};
if ROIset=='WangChoiTMS'
    networks = {[Wang '5'] [Wang '6'] [Wang '7'] [Wang '8'] [Wang '9'] [Wang '10'] [Wang '16'] [Wang '17'] [Choi '4'] [Choi '2'] [Choi '6'] [Choi '5'] [Choi '7'] sgFox sgFoxL sgFoxBilat [Gordon '123'] Gordon280 Gordon116 Gordon279 Gordon142 [Gordon '140'] Gordon312 [Gordon '296'] '~/data/ROIs/Atlases/Juelich/JuelichAmygdalaL_333' '~/data/ROIs/Atlases/Juelich/JuelichAmygdalaR_333' Gordon117 [Gordon '288'] '~/data/ROIs/Yeo/17_ROIs_333/mOFC_noSG' '~/data/ROIs/Yeo/17_ROIs_333/ltOFC' '~/data/ROIs/Fox/rACC_Boes_333' GordonSalienceInsula GordonSalienceDorsalCC FoxL FoxR L_5cm R_5cm [Wang num2str(StimParcel(subnum))] Cone};
end
%    networks = {[Yeo '1'] [Yeo '2'] [Yeo '3'] [Yeo '4'] [Yeo '6'] [Yeo '5'] [Yeo '7'] sgFox FoxL};
%networks = {Cone FoxL AntiSG AntiSG_Half1 AntiSG_Half2 AntiSGfull AntiBothcon sgFox sgFull Bothcon};
    subdir = 'Fox'
    CowMask = read_4dfpimg([Cone '.4dfp.img']);
elseif dataset=='TBI' 
%    networks = {'DAN' 'L_DAN' 'R_DAN' 'VAN' 'FPC' 'LAN' 'DMN' 'L_DMN' 'R_DMN' [Yeo '3'] [Yeo '4'] [Yeo '6'] [Yeo '5'] [Yeo '7'] [Choi '4'] [Choi '2'] [Choi '6'] [Choi '5'] [Choi '7'] sgFox [Gordon '125'] Gordon280 Gordon116 Gordon279 Gordon142 Gordon312 '~/data/ROIs/Atlases/Juelich/JuelichAmygdalaL_333' '~/data/ROIs/Atlases/Juelich/JuelichAmygdalaR_333' Gordon117 [Gordon '288'] [Gordon '112'] [Gordon '75'] [Gordon '238'] [Gordon '84'] '~/data/ROIs/Yeo/17_ROIs_333/mOFC_noSG' '~/data/ROIs/Yeo/17_ROIs_333/ltOFC' '~/data/ROIs/Fox/rACC_Boes_333' InsulaL InsulaR NA VTA VSsup FoxL FoxR L_5cm R_5cm MLP_L [MLP_L '_r12'] [MLP_L '_r20'] MLP_R [MLP_R '_r12'] [MLP_R '_r20']};
%networks = {'DAN' 'L_DAN' 'R_DAN' 'DMN' 'L_DMN' 'R_DMN' [Yeo '3'] [Yeo '5'] [Yeo '7'] sgFox [Gordon '123'] Gordon280 [Gordon '125'] [Gordon '286'] Gordon142 Gordon312 '~/data/ROIs/Atlases/Juelich/JuelichAmygdalaL_333' '~/data/ROIs/Atlases/Juelich/JuelichAmygdalaR_333' Gordon117 [Gordon '288'] '~/data/ROIs/Yeo/17_ROIs_333/mOFC_noSG' '~/data/ROIs/Yeo/17_ROIs_333/ltOFC' '~/data/ROIs/Fox/rACC_Boes_333' FoxL FoxR L_5cm R_5cm MLP_L [MLP_L '_r12'] [MLP_L '_r20'] MLP_R [MLP_R '_r12'] [MLP_R '_r20']};
%networks = {'DAN' 'VAN' 'FPC' 'LAN' 'DMN' [Yeo '3'] [Yeo '4'] [Yeo '6'] [Yeo '5'] [Yeo '7'] '~/data/ROIs/Shan/SG_TBI' YeoSG sgFox sgFoxL [Gordon '123'] Gordon280 [Gordon '125'] [Gordon '286'] Gordon142 Gordon312 '~/data/ROIs/Atlases/Juelich/JuelichAmygdalaL_333' '~/data/ROIs/Atlases/Juelich/JuelichAmygdalaR_333' Gordon117 [Gordon '288'] '~/data/ROIs/Yeo/17_ROIs_333/mOFC_noSG' '~/data/ROIs/Yeo/17_ROIs_333/ltOFC' '~/data/ROIs/Fox/rACC_Boes_333' FoxL FoxR L_5cm R_5cm [MLP_L '_r10'][MLP_R '_r10']};
networks = {'DAN' 'VAN' 'DMN' [Yeo17 '5'] [Yeo17 '6'] [Yeo17 '7'] [Yeo17 '8'] [Yeo17 '9'] [Yeo17 '10'] [Yeo17 '16'] [Yeo17 '17'] [Yeo17 '13'] '~/data/ROIs/Shan/L_ShanSG' '~/data/ROIs/Shan/R_ShanSG'  sgFoxBilat Schaefer278 Schaefer283 Schaefer807 Schaefer811 Gordon142 Gordon312 FoxL FoxR [MLP_L] [MLP_R]};
%networks = {'DAN' 'DMN' sgFoxBilat Schaefer278 Schaefer283 Schaefer807 Schaefer811 [MLP_L '_r10'] [MLP_R '_r10'] MLP_L MLP_R};
%networks = {'DAN' 'VAN' 'FPC' 'LAN' 'DMN' [Yeo '3'] [Yeo '4'] [Yeo '6'] [Yeo '5'] [Yeo '7'] YeoSG sgFox [Gordon '123'] Gordon280 [Gordon '125'] [Gordon '286'] FoxL FoxR L_5cm R_5cm MLP_L [MLP_L '_r12'] MLP_R [MLP_R '_r12'];
%    networks = {[Yeo '1'] [Yeo '2'] [Yeo '3'] [Yeo '4'] [Yeo '6'] [Yeo '5'] [Yeo '7']};

    CowMaskL = read_4dfpimg([MLP_L '_r20.4dfp.img']);
    CowMaskR = read_4dfpimg([MLP_R '_r20.4dfp.img']);
    CowMask = CowMaskL + CowMaskR;
else
%        networks = {'DAN' 'VAN' 'FPC' 'LAN' 'DMN' [Yeo '3'] [Yeo '4'] [Yeo '6'] [Yeo '5'] [Yeo '7'] [Choi '4'] [Choi '2'] [Choi '6'] [Choi '5'] [Choi '7'] sgFox YeoSG Gordon117 Gordon280 Gordon116 Gordon279 Gordon142 Gordon312 '~/data/ROIs/Atlases/Juelich/JuelichAmygdalaL_333' '~/data/ROIs/Atlases/Juelich/JuelichAmygdalaR_333' [Gordon '125'] [Gordon '288'] [Gordon '112'] [Gordon '75'] [Gordon '238'] [Gordon '116'] [Gordon '84'] '~/data/ROIs/Yeo/17_ROIs_333/mOFC_noSG' '~/data/ROIs/Yeo/17_ROIs_333/ltOFC' '~/data/ROIs/Fox/rACC_Boes_333' GordonSalienceInsula GordonSalienceDorsalCC InsulaL InsulaR CerebellumDot [Cerebellum '3'] [Cerebellum '4'] [Cerebellum '2'] [Cerebellum '1'] [Cerebellum '6'] [Cerebellum '5'] [Cerebellum '7'] NA VTA VSsup FoxL FoxR L_5cm R_5cm};
 if ROIset=='Yeo'
       for i=1:17
            networks{i} = [Yeo17 num2str(i)];
        end
        networks{18} = [Choi '2'];
        networks{19} = [Choi '4'];
        networks{20} = [Choi '5'];
        networks{21} = [Choi '6'];
        networks{22} = [Choi '7'];
        networks{23} = sgFoxBilat;
        networks{24} = Schaefer278;
        networks{25} = Schaefer283;
        networks{26} = Schaefer807;
        networks{27} = Schaefer811;
      networks{28} = '~/data/OtherData/Adamson/Analysis/aMFG_r12';
        networks{29} = 'DAN'
        networks{30} = 'DMN'
                networks{31} = '~/data/ROIs/Yeo/17_ROIs_333/mOFC_noSG';
        networks{32} = '~/data/ROIs/Yeo/17_ROIs_333/ltOFC';
        networks{33} = Gordon142
        networks{34} = Gordon312
  
        networks{35} = MLP_L;
        networks{36} = MLP_R;
        networks{37} = [MLP_L '_r12'];
        networks{38} = [MLP_R '_r12'];
        CowMask = zeros(147456,1);
        
 elseif ROIset=='Ye7'
       for i=1:7
            networks{i} = [Yeo num2str(i)];
        end
        networks{8} = [Choi '2'];
        networks{9} = [Choi '4'];
        networks{10} = [Choi '5'];
        networks{11} = [Choi '6'];
        networks{12} = [Choi '7'];
        networks{13} = sgFoxBilat;
        networks{14} = '~/data/ROIs/Yeo/17_ROIs_333/mOFC_noSG';
        networks{15} = '~/data/ROIs/Yeo/17_ROIs_333/ltOFC';
        networks{16} = Gordon142
        networks{17} = Gordon312
        networks{18} = '~/data/OtherData/Adamson/Analysis/aMFG_r12';
        networks{19} = 'DAN'
        networks{20} = 'DMN'
        networks{21} = MLP_L;
        networks{22} = MLP_R;
        networks{23} = [MLP_L '_r12'];
        networks{24} = [MLP_R '_r12'];
     CowMaskL = read_4dfpimg([MLP_L '_r20.4dfp.img']);
    CowMaskR = read_4dfpimg([MLP_R '_r20.4dfp.img']);
    CowMask = CowMaskL + CowMaskR;
        
elseif ROIset=='MLP'
networks = {'DAN' 'VAN' 'FPC' 'LAN' 'DMN' [Yeo '3'] [Yeo '4'] [Yeo '6'] [Yeo '5'] [Yeo '7'] [Choi '2'] [Choi '4']  [Choi '5'] [Choi '6'] [Choi '7'] '~/data/ROIs/Shan/SG_TBI' YeoSG sgFox};

end
end

numrois = size(networks,2);
%[datapre frames voxelsize] = read_4dfpimg(['~/data/' subdir '/FCProcess/corrfile_fcimages/ConnProcessed/' outsub '.4dfp.img']);
[datapre frames voxelsize] = read_4dfpimg([tcdir '/' outsub '_total_tmask.4dfp.img']);
datapre = zerovoxelmean_4dfpimg(datapre);

 %   datapre = mask_4dfpimg(datapre,[FSdir '/' outsub '/nusmask/aseg_GM_mask_333.4dfp.img'],'zero');
%    datapre = datapre.*GMmask;


%[datapre] = mask_4dfpimg(datapre,'~/data/ROIs/masks/GMmask_711.4dfp.img','zero');
    
clear tcmat;
            for p=1:(numrois+1)
                clear temproitc avgroitc seed;
                if p==(numrois+1)
                    seed = read_4dfpimg([networks{p-1} '.4dfp.img']) + read_4dfpimg([networks{p-2} '.4dfp.img']);
                else
                     seed = read_4dfpimg([networks{p} '.4dfp.img']);
                end
%                    seed(seed<0.3)=0;
 
               temproitc = datapre;
%                if p<3
%                    temproitc(CowMask>0)=0;
%                end
                    %WEIGHTED ROI
%                   [weightedroitc] = datapre;
%                    [temproitc] = mask_4dfpimg(weightedroitc,seed,'remove');
%                else
                 %   [temproitc] = temproitc.*seed;
                    [temproitc] = mask_4dfpimg(temproitc,seed,'remove');
%                end
                %[temproitc] = datapre.*seed;
                avgroitc=mean(temproitc,1);
                tcmat(:,p)=avgroitc';
 %               for q=1:numrois
 %                   seed2 = read_4dfpimg([networks{q} '.4dfp.img']);
 %                    [temproitc2] = mask_4dfpimg(datapre,seed2,'remove');
 %                    avgroitc2 = mean(temproitc,1);
 %                    r = cov(avgroitc',avgroitc2');
 %                    zmat(p,q) = FisherTransform(r(1,2));
 %               end
            end
            
%            pre(:,:)=(corrcoef(tcmat));
if CorrCov=='cov'
            zmat(:,:)=(cov(tcmat));
                        for p=1:numrois
                clear temproitc avgroitc1 avgroitc2 seed;
                %seed = read_4dfpimg([networks{p} '.4dfp.img']);
                [temproitc] = mask_4dfpimg(datapre,[networks{p} '.4dfp.img'],'remove');
                %[temproitc] = mask_4dfpimg(temproitc,temproitc(:,1),'remove');
                if dataset=='Fox'
                    %tmpr = corrcoef(temproitc');
                    tmpr = nancov(temproitc');
                   tmpz = tmpr(1,2);
                   % tmpz = FisherTransform(tmpr);
                    meanz = mean(mean(tmpz));
                   % sdz = mean(std(tmpz,0,2));
                   % zmat(p,p) = meanz/sdz;
                   zmat(p,p) = meanz;
                else
                    s = size(temproitc,1);
                    if s>1
                        h = round(s/2);
                        row_idx = randperm(s);
                        roitc1 = temproitc(row_idx(1:h),:);
                        roitc2 = temproitc(row_idx(h:s),:);
                        avtc1 = mean(roitc1,1);
                        avtc2 = mean(roitc2,1);
                    %    r = corr(avtc1',avtc2');
                    r = cov(avtc1',avtc2');
                    %   zmat(p,p) = FisherTransform(r);
                        zmat(p,p) = r(1,2);
                    else
                        zmat(p,p) = 0.5
                        disp(outsub)
                        disp(p)
                        disp(0.5)
                    end
                end
            end
else if CorrCov=='cor'
        zmat(:,:)=FisherTransform(corrcoef(tcmat))
         for p=1:numrois
                clear temproitc avgroitc1 avgroitc2 seed;
                %seed = read_4dfpimg([networks{p} '.4dfp.img']);
                [temproitc] = mask_4dfpimg(datapre,[networks{p} '.4dfp.img'],'remove');
                %[temproitc] = mask_4dfpimg(temproitc,temproitc(:,1),'remove');
                if dataset=='Fox'
                    tmpr = corrcoef(temproitc');
                    %tmpr = nancov(temproitc');
                   %tmpz = tmpr(1,2);
                    tmpz = FisherTransform(tmpr);
                    meanz = mean(mean(tmpz));
                   % sdz = mean(std(tmpz,0,2));
                   % zmat(p,p) = meanz/sdz;
                   zmat(p,p) = meanz;
                else
                    s = size(temproitc,1);
                    if s>1
                        h = round(s/2);
                        row_idx = randperm(s);
                        roitc1 = temproitc(row_idx(1:h),:);
                        roitc2 = temproitc(row_idx(h:s),:);
                        avtc1 = mean(roitc1,1);
                        avtc2 = mean(roitc2,1);
                        r = corr(avtc1',avtc2');
                    %r = cov(avtc1',avtc2');
                       zmat(p,p) = FisherTransform(r);
                    %    zmat(p,p) = r(1,2);
                    else
                        zmat(p,p) = 0.5
                        disp(outsub)
                        disp(p)
                        disp(0.5)
                    end
                end
            end
    end;
%zmat = FisherTransform(pre);
            

            
            if zscorecorrection==1
                sd = (std(zmat,0,1).^2 + std(zmat,0,2).^2).^0.5;
                zmat = zmat./sd;
            end

            
    clear tcmat;

            covmat = zmat;
          matname = [outsub '.mat'];
            save(matname,'covmat');
  %          fprintf('Writing %s\n',matname);
            
end