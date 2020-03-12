function [itemcorr ClusterMaps item_vs_voxel dCluster SxClusterAssignment sumd TotalMap] = SymptomClusters(Pre,Post,maps,RefMap)

dItems = Post - Pre;
%dTotal = sum(dItems,2);
%item_vs_voxel = corr(dItems,maps','rows','complete');
item_vs_voxel = -partialcorr(Post,maps',Pre,'rows','complete');
item_vs_voxel(find(isnan(item_vs_voxel)))=0;
item_vs_voxel = item_vs_voxel';
%total_vs_voxel = corr(dTotal,maps','rows','complete');
itemcorr = corr(atanh(item_vs_voxel),'rows','complete');
%itemcorr = atanh(itemcorr);
%itemcorr_adj = matrix_thresholder(itemcorr,0.8,'kden');
[SxClusterAssignment c sumd] = kmeans(itemcorr,2,'distance','correlation');
tmp = mean(abs(atanh(itemcorr(itemcorr<1))));
mean_itemcorr = mean(tmp);

for i=1:2
ClustersPre(:,i) = sum(Pre(:,SxClusterAssignment==i),2);
ClustersPost(:,i) = sum(Post(:,SxClusterAssignment==i),2);
dCluster = ClustersPre - ClustersPost;
ClusterMaps(:,i) = -partialcorr((ClustersPost(:,i)),maps',(ClustersPre(:,i)),'rows','complete');
end

ClusterMaps(find(isnan(ClusterMaps)))=0;
%Cluster1 = dItems(:,SxClusterAssignment==1);
%Cluster2 = dItems(:,SxClusterAssignment==2);
%Cluster1 = sum(Cluster1,2);
%Cluster2 = sum(Cluster2,2);
%dCluster = [Cluster1 Cluster2];
%dCluster = ClustersPre - ClustersPost;

%ClusterMaps = corr(dCluster,maps','rows','complete')';

%tmp1 = corr(ClusterMaps(:,1),RefMap,'rows','complete');
%tmp2 = corr(ClusterMaps(:,2),RefMap,'rows','complete');
%if tmp2>tmp1
%    dCluster = [Cluster2 Cluster1];
%    ClusterMaps = ClusterMaps(:,[2 1]);
%end
%TotalMap = corr(dTotal,maps','rows','complete')';