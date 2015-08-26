function [r1_adj,r2_adj,r3_adj,r4_adj] = r_adjust(targets1,targets2,targets3,targets4,r1,r2,r3,r4)

targets= [targets1;targets2;targets3;targets4];
target_distances = zeros(length(r1)*4,length(r1)*4);
rs = [r1;r2;r3;r4];
r_distances = target_distances;

for target_index1 = 1:size(targets,1)
    for target_index2 = 1:size(targets,1)
        target_distances(target_index1,target_index2) = norm(targets(target_index1,:) - targets(target_index2,:));
        r_distances(target_index1,target_index2) = rs(target_index1,:) + rs(target_index2,:);
    end
end

r_flag = r_distances - target_distances ;
r_flag(r_flag > 0) = 0;
r_flag = - mean(r_flag,2);

r1_adj = r1 .* sqrt(1+(r_flag(1:length(r1))));
r2_adj = r2 .* sqrt(1+r_flag(length(r1)*1+1:length(r1)*2));
r3_adj = r3 .* sqrt(1+r_flag(length(r1)*2+1:length(r1)*3));
r4_adj = r4 .* sqrt(1+r_flag(length(r1)*3+1:length(r1)*4));