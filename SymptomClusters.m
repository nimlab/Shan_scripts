function [itemcorr ClusterMaps item_vs_voxel dCluster ClusterRatio ClusterRatioMap SxClusterAssignment TotalMap sumd] = SymptomClusters(dItems,maps,RefMap,covariate)

gmmask = RefMap;
gmmask(gmmask~=0)=1;
dTotal = sum(dItems,2);
item_vs_voxel = corr(dItems,maps','rows','complete')';
if nargin>3
    item_vs_voxel = partialcorr(dItems,maps',covariate,'rows','complete')';
end
item_vs_voxel(gmmask==0,:)=0;
item_vs_voxel_masked = item_vs_voxel(gmmask==1,:);
item_vs_voxel = atanh(item_vs_voxel);
total_vs_voxel = corr(dTotal,maps','rows','complete');
total_vs_voxel(gmmask==0)=0;
%total_vs_voxel(find(isnan(total_vs_voxel)))=0;
total_vs_voxel = atanh(total_vs_voxel)';
itemcorr = corr(item_vs_voxel_masked,'rows','complete');
%itemcorr = atanh(itemcorr);
%itemcorr_adj = matrix_thresholder(itemcorr,0.8,'kden');

%[SxClusterAssignment c sumd] = kmeans(itemcorr,2);
item_vs_voxel_masked(find(isnan(item_vs_voxel_masked)))=0;
SxClusterAssignment = clusterdata(itemcorr,'distance','correlation','maxclust',2,'linkage','ward');
tmp = mean(abs(itemcorr));
mean_itemcorr = mean(tmp);

Cluster1 = dItems(:,SxClusterAssignment==1);
Cluster2 = dItems(:,SxClusterAssignment==2);
Cluster1 = sum(Cluster1,2);
Cluster2 = sum(Cluster2,2);
dCluster = [Cluster1 Cluster2];

%ClusterMaps = atanh(corr(dCluster,maps','rows','complete'))';
ClusterMaps(:,1) = mean(item_vs_voxel(:,SxClusterAssignment==1),2);
ClusterMaps(:,2) = mean(item_vs_voxel(:,SxClusterAssignment==2),2);
%tmp1 = corr(ClusterMaps(:,1),RefMap,'rows','complete');
%tmp2 = corr(ClusterMaps(:,2),RefMap,'rows','complete');
tmp1 = size(SxClusterAssignment(SxClusterAssignment==1),1);
tmp2 = size(SxClusterAssignment(SxClusterAssignment==2),1);
if tmp2<tmp1
    dCluster = [Cluster2 Cluster1];
    ClusterMaps = ClusterMaps(:,[2 1]);
end
TotalMap = total_vs_voxel;
ClusterRatio = tiedrank(Cluster2)./tiedrank(Cluster1);
ClusterRatioMap = corr(ClusterRatio,maps','rows','complete','type','Spearman');
ClusterMaps(find(isnan(ClusterMaps)))=0;